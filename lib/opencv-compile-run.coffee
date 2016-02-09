OpencvPackageView = require './opencv-compile-run-view'
{CompositeDisposable} = require 'atom'
exec = require("child_process").exec
path = '~/workspace/OpenCV_Projects/cone-shape-detection'

module.exports = MyPackage =
  messageView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @messageView = new OpencvPackageView(state.myPackageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @messageView.getElement(), visible: false)

    @callback this, document

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor', 'opencv-compile-run:compile': => @compile(this)
    atom.commands.add 'atom-text-editor', 'opencv-compile-run:run': => @run(this)
    atom.commands.add 'atom-text-editor', 'opencv-compile-run:compile-run': => @compile_run(this)
    # atom.commands.add 'atom-text-editor', 'opencv-compile-run:path': => @path(this)
    # if window.File && window.FileReader && window.FileList && window.Blob
    #   # do your stuff!
    #   @readfile(this, state)
    # else
    #   console.log  'The File APIs are not fully supported by your browser.'

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @messageView.destroy()

  serialize: ->
    myPackageViewState: @messageView.serialize()

  callback: (t, document) ->
    t.messageView.element.onmousedown = (e) ->
      atom.clipboard.write t.messageView.element.firstChild.outerText

    document.getElementsByClassName('workspace')[0].onmousedown = (e) ->
      if t.modalPanel.isVisible()
        t.modalPanel.hide()

  showMessageBox: (t, message)->
    t.messageView.setContent t.messageView.element.childNodes[0].outerText + "----" + message
    t.modalPanel.item = t.messageView.getElement()

    t.modalPanel.show()

  clearMessageBox: (t)->
    t.messageView.element.firstChild.textContent = ""

  compile: (t)->
    if t.modalPanel.isVisible()
      t.modalPanel.hide()
    else
      t.clearMessageBox t
      console.log "compile opencv code"
      exec 'cd ' + path + ' && cmake .', (err, stdout, stderr) ->
        if err
          t.showMessageBox t,"Error: " + err
          return
        t.showMessageBox t,"Done: " + stdout
        exec 'cd ' + path + ' && make', (err, stdout, stderr) ->
          if err
            t.showMessageBox t,"Error: " + err
            return
          t.showMessageBox t,"Done: " + stdout

  run: (t)->
    if t.modalPanel.isVisible()
      t.modalPanel.hide()
    else
      t.clearMessageBox t
      console.log "running opencv code"
      exec 'cd ' + path + ' && ./app', (err, stdout, stderr) ->
        if err
          t.showMessageBox t,"Error: " + err
          return
        t.showMessageBox t,"Done: " + stdout

  compile_run: (t)->
    if t.modalPanel.isVisible()
      t.modalPanel.hide()
    else
      t.clearMessageBox t
      console.log "compile and run opencv code"
      exec 'cd ' + path + ' && make', (err, stdout, stderr) ->
        if err
          t.showMessageBox t,"Error: " + err
          return
        t.showMessageBox t,"Done: " + stdout
        exec 'cd ' + path + ' && ./app', (err, stdout, stderr) ->
          if err
            t.showMessageBox t,"Error: " + err
            return
          t.showMessageBox t,"Done: " + stdout
