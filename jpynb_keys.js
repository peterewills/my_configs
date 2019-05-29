// I use this file to make custom keybindings. I basically want emacs-like text
// navigation within CodeMirror. Nothing fancy really.
//
// To function, this file must seen by jupyter as  ~/.jupyter/custom/custom.js

$([IPython.events]).on('notebook_loaded.Notebook', function() {
    console.log('Adding emacs keybindings');

	// Here is where we define our custom keymaps
    var extraKeys = {
		'Ctrl-Left' : 'goWordLeft',
		'Ctrl-Right' : 'goWordRight',
		'Ctrl-Backspace' : 'delWordBefore',
		'Cmd-Left' : 'indentLess',
		'Cmd-Right' : 'indentMore'
		// Wanted:
		// map Ctrl-X Ctrl-S to save
		// map Ctrl-S to find
    };

    // this adds these extra keys to the base class, so that
    // all newly created cells will have them.
    IPython.Cell.options_default.cm_config.extraKeys = extraKeys;
    IPython.Cell.options_default.cm_config.lineWrapping = true;

    // but we also need to add them to any existing cells
    var cells = IPython.notebook.get_cells();
    var numCells = cells.length;
    for (var i = 0; i < numCells; i++) {
	var theseExtraKeys = cells[i].code_mirror.getOption('extraKeys');
	for (var k in extraKeys) {
	    theseExtraKeys[k] = extraKeys[k];
	}
	cells[i].code_mirror.setOption('extraKeys', theseExtraKeys);
	cells[i].code_mirror.setOption('lineWrapping', true);
    }
});
