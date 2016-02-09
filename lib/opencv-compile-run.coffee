OpencvPackageView = require './opencv-compile-run-view'
{CompositeDisposable} = require 'atom'
require 'shelljs/global'
exec = require("child_process").exec
path = "~/workspace/OpenCV_Projects/cone-shape-detection"

module.exports = MyPackage =
  messageView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @messageView = new OpencvPackageView(state.myPackageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @messageView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'opencv-compile-run:toggle': => @toggle()
    atom.commands.add 'atom-text-editor', 'opencv-compile-run:compile': => @compile(@messageView, @modalPanel)
    atom.commands.add 'atom-text-editor', 'opencv-compile-run:run': => @run(@messageView, @modalPanel)
    atom.commands.add 'atom-text-editor', 'opencv-compile-run:compile-run': => @compile_run(@messageView, @modalPanel)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @messageView.destroy()

  serialize: ->
    myPackageViewState: @messageView.serialize()

  compile: (messageView, modalPanel)->
    if modalPanel.isVisible()
      modalPanel.hide()
    else
      console.log "compile opencv code"
      cd path

      exec 'cmake .', (err, stdout, stderr) ->
        if err
          messageView.setContent "Error: " + err
          modalPanel.item = messageView.getElement()

          modalPanel.show()
          return
        messageView.setContent "Done: \n" + stdout
        modalPanel.item = messageView.getElement()

        modalPanel.show()

        exec 'make', (err, stdout, stderr) ->
          if err
            messageView.setContent "Error: " + err
            modalPanel.item = messageView.getElement()

            modalPanel.show()
            return
          messageView.setContent "Done: " + stdout
          modalPanel.item = messageView.getElement()

          modalPanel.show()

  run: (messageView, modalPanel)->
    console.log "running opencv code"

  compile_run: (messageView, modalPanel)->
    console.log "compile and run opencv code"

  toggle: ->
    console.log "path"
    console.log 'MyPackage was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

# require('shelljs/global');
# var exec = require('child_process').exec;
# var path = "~/workspace/OpenCV_Projects/cone-shape-detection";
#
# module.exports = {
#   activate: function() {
#       atom.commands.add('atom-text-editor', 'opencv-compile-run:compile', this.compile);
#       atom.commands.add('atom-text-editor', 'opencv-compile-run:run', this.run);
#       atom.commands.add('atom-text-editor', 'opencv-compile-run:compile-run', this.compile_run);
#   },
#   compile: function(){
#       cd(path);
#       var editor = atom.workspace.getActiveTextEditor();
#       exec('cmake .',
#       function(err, stdout, stderr) {
#           if (err) {
#             editor.insertText("error"+err);
#             return;
#           }
#           //editor.insertText("done"+stdout);
#           exec('make',
#           function(err, stdout, stderr) {
#               if (err) {
#                 editor.insertText("error"+err);
#                 return;
#               }
#               //editor.insertText("done"+stdout);
#             });
#         });
#   },
#   run: function(){
#       cd(path);
#       var editor = atom.workspace.getActiveTextEditor();
#
#     exec('./app',
#     function(err, stdout, stderr) {
#         if (err) {
#           editor.insertText("error"+err);
#           return;
#         }
#         //editor.insertText("done"+stdout);
#       });
#
#   },
#   compile_run: function(){
#       cd(path);
#       var editor = atom.workspace.getActiveTextEditor();
#
#       exec('make',
#       function(err, stdout, stderr) {
#           if (err) {
#             editor.insertText("error"+err);
#             return;
#           }
#           //editor.insertText("done"+stdout);
#           exec('./app',
#           function(err, stdout, stderr) {
#               if (err) {
#                 editor.insertText("error"+err);
#                 return;
#               }
#               //editor.insertText("done"+stdout);
#             });
#         });
#   }
# };
