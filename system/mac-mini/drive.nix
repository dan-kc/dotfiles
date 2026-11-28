# Shared drive: a 40 GiB disk image served over WebDAV (nginx behind `tailscale serve`)
# and SMB (macOS File Sharing). Both protocols act as the hidden `drive` account.
{ config, lib, pkgs, ... }:
let
  owner = config.system.primaryUser;
  account = "drive";
  uid = 550;
  passwordFile = config.sops.secrets.drive_password.path;
  state = "/var/db/drive";

  size = "40g";
  # Root-owned parent, so nothing unprivileged can pre-create the image or mount point.
  base = "/Library/Drive";
  bundle = "${base}/Drive.sparsebundle";
  provisioned = "${base}/.provisioned";
  mountPoint = "${base}/Volume";
  share = "${mountPoint}/files";
  uploads = "${mountPoint}/.uploads";

  webdavPort = 4790;
  httpsPort = 8446;
  tailscale = "${config.services.tailscale.package}/bin/tailscale --socket=/var/run/tailscaled.socket";
  smbServer = "/Library/Preferences/SystemConfiguration/com.apple.smb.server";
  jq = "${pkgs.jq}/bin/jq";

  nginx = pkgs.nginx.override { modules = [ pkgs.nginxModules.dav ]; };

  attachVolume = pkgs.writeShellScript "drive-volume" ''
    set -u
    mounted() { [ "$(/usr/bin/stat -f %d ${mountPoint})" != "$(/usr/bin/stat -f %d ${base})" ]; }
    attach() { /usr/bin/hdiutil attach -nobrowse -owners on -mountpoint ${mountPoint} ${bundle}; }

    # Idempotent, so an interrupted first run or a recovered mount ends up complete.
    reconcile() {
      /usr/sbin/chown root:wheel ${mountPoint}
      /bin/chmod 755 ${mountPoint}
      if [ ! -d ${share} ]; then
        /bin/mkdir -m 775 ${share}
        /usr/sbin/chown ${account}:staff ${share}
        /bin/chmod +a "user:${owner} allow list,add_file,search,delete,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" ${share}
      fi
      /usr/bin/install -d -o ${account} -g staff -m 700 ${uploads}
      /usr/bin/mdutil -i off ${mountPoint} >/dev/null
      /usr/sbin/sharing -l -f json | ${jq} -e 'has("Drive")' >/dev/null \
        || /usr/sbin/sharing -a ${share} -n Drive -S Drive -s 001 -g 000
    }

    /usr/bin/install -d -o root -g wheel -m 755 ${base} ${mountPoint}

    ready=0
    while true; do
      if ! mounted; then
        ready=0
        if [ -d ${bundle} ]; then
          attach || exit 1
        elif [ -e ${provisioned} ]; then
          echo "drive: ${bundle} is missing; refusing to replace it with an empty drive" >&2
          /bin/sleep 300
          continue
        else
          /usr/bin/hdiutil create -type SPARSEBUNDLE -size ${size} -fs APFS -volname Drive ${bundle} || exit 1
          /usr/bin/touch ${provisioned}
          attach || exit 1
        fi
      fi
      if [ "$ready" = 0 ] && mounted; then
        reconcile && ready=1
      fi
      /bin/sleep 30
    done
  '';

  nginxConf = pkgs.writeText "drive-nginx.conf" ''
    # The master runs as root to read the secret; workers serve files as `drive`.
    user ${account} staff;
    pid ${state}/nginx.pid;
    error_log ${state}/webdav.log warn;
    events {}
    http {
      include ${nginx}/conf/mime.types;
      default_type application/octet-stream;
      charset utf-8;
      access_log off;
      sendfile on;

      # Uploads are staged on the volume so they count against the quota and land by rename.
      client_body_temp_path ${uploads};
      # The volume size is the limit, so a single file may use all of it.
      client_max_body_size 0;
      proxy_temp_path ${state}/tmp/proxy;
      fastcgi_temp_path ${state}/tmp/fastcgi;
      uwsgi_temp_path ${state}/tmp/uwsgi;
      scgi_temp_path ${state}/tmp/scgi;

      dav_ext_lock_zone zone=drive:10m;

      # TLS ends at `tailscale serve`, and the dav module rejects a Destination
      # whose scheme differs from its own connection, so this hop rewrites it.
      map $http_destination $dav_destination {
        default $http_destination;
        "~^https://(?<rest>.*)$" "http://$rest";
      }

      server {
        listen 127.0.0.1:${toString webdavPort};

        auth_basic "Drive";
        auth_basic_user_file ${state}/htpasswd;

        location / {
          # A COPY or MOVE onto the share root would replace the whole drive.
          if ($dav_destination ~ "^https?://[^/]+/*$") {
            return 403;
          }
          proxy_pass http://unix:${state}/tmp/dav.sock;
          proxy_http_version 1.1;
          proxy_set_header Host $http_host;
          proxy_set_header Destination $dav_destination;
          proxy_request_buffering off;
          proxy_buffering off;
        }
      }

      server {
        listen unix:${state}/tmp/dav.sock;
        root ${share};
        absolute_redirect off;
        disable_symlinks on;

        location / {
          if (!-d ${share}) {
            return 503 "Drive volume is not mounted\n";
          }
          # Finder and some clients omit the trailing slash nginx requires for MKCOL.
          if ($request_method = MKCOL) {
            rewrite ^(.*[^/])$ $1/ break;
          }

          dav_methods PUT DELETE MKCOL COPY MOVE;
          dav_ext_methods PROPFIND OPTIONS LOCK UNLOCK;
          dav_ext_lock zone=drive;
          dav_access user:rw group:rw all:r;
          min_delete_depth 1;
          create_full_put_path on;
          autoindex on;
        }
      }
    }
  '';

  runWebdav = pkgs.writeShellScript "drive-webdav" ''
    set -eu
    [ -d ${share} ] || { echo "drive: ${share} missing, volume not mounted" >&2; exit 1; }
    /usr/bin/install -d -o root -g wheel -m 755 ${state}
    /usr/bin/install -d -o ${account} -g staff -m 700 ${state}/tmp
    /bin/rm -f ${state}/tmp/dav.sock
    hash=$(${pkgs.openssl}/bin/openssl passwd -apr1 -stdin < ${passwordFile})
    ( umask 077; printf '%s:%s\n' ${account} "$hash" > ${state}/htpasswd )
    /usr/sbin/chown ${account} ${state}/htpasswd
    exec ${nginx}/bin/nginx -p ${state} -e ${state}/webdav.log -c ${nginxConf} -g 'daemon off;'
  '';

  # macOS smbd listens on every interface; this limits SMB to loopback and the tailnet.
  smbFirewall = pkgs.writeText "drive-smb.pf" ''
    pass in quick on lo0 proto tcp to any port { 139 445 }
    pass in quick inet proto tcp from 100.64.0.0/10 to any port { 139 445 }
    pass in quick inet6 proto tcp from fd7a:115c:a1e0::/48 to any port { 139 445 }
    block drop in quick proto { tcp udp } to any port { 137 138 139 445 }
  '';

  loadFirewall = pkgs.writeShellScript "drive-firewall" ''
    set -eu
    /sbin/pfctl -s rules 2>/dev/null | /usr/bin/grep -q 'anchor "com.apple/\*"' || /sbin/pfctl -q -f /etc/pf.conf
    /sbin/pfctl -q -a com.apple/drive-smb -f ${smbFirewall}
    /sbin/pfctl -s info 2>/dev/null | /usr/bin/grep -q 'Status: Enabled' || /sbin/pfctl -q -E
  '';

  daemon = arguments: log: {
    serviceConfig = {
      ProgramArguments = arguments;
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 10;
      StandardOutPath = log;
      StandardErrorPath = log;
    };
  };
in
{
  users.knownUsers = [ account ];
  users.users.${account} = {
    inherit uid;
    description = "Drive file share";
  };
  services.openssh.extraConfig = "DenyUsers ${account}";

  sops.secrets.drive_password.sopsFile = ../../secrets/mac-mini.yaml;

  launchd.daemons."dev.keone.drive-volume" = daemon [ "${attachVolume}" ] "/var/log/drive-volume.log";
  launchd.daemons."dev.keone.drive-webdav" = daemon [ "${runWebdav}" ] "/var/log/drive-webdav.log";
  # Re-applied every five minutes in case something reloads the pf ruleset.
  launchd.daemons."dev.keone.drive-firewall" = lib.recursiveUpdate (daemon [ "${loadFirewall}" ] "/var/log/drive-firewall.log") {
    serviceConfig.KeepAlive = false;
    serviceConfig.StartInterval = 300;
  };

  # Runs after sops-nix installs secrets, which it appends with mkAfter.
  system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
    echo "setting up drive..." >&2
    ${tailscale} serve --bg --https=${toString httpsPort} http://127.0.0.1:${toString webdavPort} >/dev/null \
      || echo "warning: tailscale serve for the drive failed; rerun darwin-rebuild once Tailscale is up" >&2

    # macOS only stores the SMB-NT hash when the password is set.
    sum=$(/usr/bin/shasum -a 256 < ${passwordFile} | /usr/bin/cut -d' ' -f1)
    if [ "$(/usr/bin/id -u ${account} 2>/dev/null)" != ${toString uid} ]; then
      echo "warning: ${account} is not uid ${toString uid}; leaving its password alone" >&2
    elif [ "$sum" != "$(/bin/cat /var/db/drive-password.sha256 2>/dev/null)" ]; then
      if /usr/bin/pwpolicy -u ${account} -sethashtypes SMB-NT on >/dev/null \
        && /usr/bin/dscl . -passwd /Users/${account} "$(/bin/cat ${passwordFile})"; then
        ( umask 077; echo "$sum" > /var/db/drive-password.sha256 )
        # nginx builds its password file at startup.
        /bin/launchctl kickstart -k system/org.nixos.dev.keone.drive-webdav 2>/dev/null || true
      else
        echo "warning: could not set the SMB password for ${account}" >&2
      fi
    fi

    /usr/bin/defaults write ${smbServer} AllowGuestAccess -bool false
    /usr/bin/defaults write ${smbServer} EnabledServices -array disk
    /bin/launchctl enable system/com.apple.smbd
    /bin/launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.smbd.plist 2>/dev/null || true

    # Only the drive is served: SMB stays off for the default Public folder share.
    /usr/sbin/sharing -l -f json \
      | ${jq} -r 'to_entries[] | select(.value.path == "${config.users.users.${owner}.home}/Public" and .value.smb_shared == 1) | .key' \
      | while IFS= read -r name; do /usr/sbin/sharing -e "$name" -s 000; done
  '';
}
