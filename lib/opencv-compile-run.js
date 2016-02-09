require('shelljs/global');
var exec = require('child_process').exec;
var path = "~/workspace/OpenCV_Projects/cone-shape-detection";

module.exports = {
  activate: function() {
      atom.commands.add('atom-text-editor', 'opencv-compile-run:compile', this.compile);
      atom.commands.add('atom-text-editor', 'opencv-compile-run:run', this.run);
      atom.commands.add('atom-text-editor', 'opencv-compile-run:compile-run', this.compile_run);
  },
  compile: function(){
      cd(path);
      var editor = atom.workspace.getActiveTextEditor();

      exec('ls',{cwd : path},
      function(err, stdout, stderr) {
          if (err) {
            editor.insertText("error"+err);
            return;
          }
          editor.insertText("done"+stdout);
      });

      exec('cmake .',
      function(err, stdout, stderr) {
          if (err) {
            editor.insertText("error"+err);
            return;
          }
          //editor.insertText("done"+stdout);
          exec('make',
          function(err, stdout, stderr) {
              if (err) {
                editor.insertText("error"+err);
                return;
              }
              //editor.insertText("done"+stdout);
            });
        });
  },
  run: function(){
      cd(path);
      var editor = atom.workspace.getActiveTextEditor();

    exec('./app',
    function(err, stdout, stderr) {
        if (err) {
          editor.insertText("error"+err);
          return;
        }
        //editor.insertText("done"+stdout);
      });

  },
  compile_run: function(){
      cd(path);
      var editor = atom.workspace.getActiveTextEditor();

      exec('make',
      function(err, stdout, stderr) {
          if (err) {
            editor.insertText("error"+err);
            return;
          }
          //editor.insertText("done"+stdout);
          exec('./app',
          function(err, stdout, stderr) {
              if (err) {
                editor.insertText("error"+err);
                return;
              }
              //editor.insertText("done"+stdout);
            });
        });
  }
};
