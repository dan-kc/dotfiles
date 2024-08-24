// ==UserScript==
// @name        Prevent keyboard shortcut hijacking
// @description Personal config to prevent certain keyboard hijacking
// @namespace   Violentmonkey Scripts
// @match       *://*/*
// @grant       none
// @version     1.0
// @author      Daniel
// ==/UserScript==

(window.opera ? document.body : document).addEventListener(
  "keydown",
  function (e) {
    // alert(e.keyCode );

    // var OS = "Unknown";
    // if (navigator.appVersion.toUpperCase().indexOf("MAC") >= 0) OS = "macOS";
    //if (navigator.appVersion.toUpperCase().indexOf("LINUX")>=0) OS="Linux";
    //if (navigator.appVersion.toUpperCase().indexOf("X11")>=0) OS="UNIX";
    //if (navigator.appVersion.toUpperCase().indexOf("WIN")>=0) OS="Windows";
    //console.log(OS);

    var modifier_cmd = e.metaKey;
    var modifier_ctrl = e.ctrlKey;
    var modifier_alt = e.altKey;
    var modifier_shift = e.shiftKey;

    var no_mods =
      !modifier_shift && !modifier_ctrl && !modifier_alt && !modifier_cmd;
    if (no_mods) {
      return;
    }

    // F5
    if (e.keyCode === 116) {
      e.stopImmediatePropagation();
      return;
    }

    if (modifier_cmd && modifier_alt) {
      switch (e.keyCode) {
        case 37: // <- - tab left
        case 39: // -> - tab right
          e.stopImmediatePropagation();
          return;
      }
    }

    if (modifier_cmd) {
      switch (e.keyCode) {
        case 188: // , - settings
        case 82: // r - reload
        case 70: // f - find
        case 191: // / - command menu
          e.stopImmediatePropagation();
          return;
      }
    }
  },
  true,
);
