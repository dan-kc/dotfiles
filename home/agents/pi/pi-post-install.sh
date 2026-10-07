pi_bundle="$out/lib/node_modules/pi-monorepo/dist/bundle"
command_file=$(grep -R -l 'name:"quit",description:`Quit ' "$pi_bundle" | head -n1)
autocomplete_matches=$(grep -R -l -F 'this.autocompletePrefix.startsWith("/")' "$pi_bundle/chunks" || true)
test "$(printf '%s\n' "$autocomplete_matches" | grep -c .)" -eq 1
autocomplete_file="$autocomplete_matches"
test "$(grep -F -o 'this.autocompletePrefix.startsWith("/")' "$autocomplete_file" | wc -l)" -eq 1

substituteInPlace "$command_file" \
  --replace-fail '{name:"quit",description:`Quit ${APP_NAME}`}' \
                 '{name:"quit",description:`Quit ${APP_NAME}`},{name:"exit",description:`Quit ${APP_NAME}`}' \
  --replace-fail 'if(text==="/quit"){this.editor.setText(""),await this.shutdown();return}' \
                 'if(text==="/quit"||text==="/exit"){this.editor.setText(""),await this.shutdown();return}'

substituteInPlace "$autocomplete_file" \
  --replace-fail 'this.autocompletePrefix.startsWith("/"))this.cancelAutocomplete();else{this.cancelAutocomplete(),this.onChange&&this.onChange(this.getText());return' \
                 'this.autocompletePrefix.startsWith("/")&&!selected.value.startsWith("skill:"))this.cancelAutocomplete();else{this.cancelAutocomplete(),this.onChange&&this.onChange(this.getText());return'
