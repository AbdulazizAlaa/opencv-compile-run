module.exports =
class OpencvInputView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('opencv-path-input')

    # Create path_input element
    path_input = document.createElement('input')
    path_input.classList.add('input-path')
    path_input.placeholder = "Enter the path to the opencv project"
    path_input.type = "text"
    path_input.size = 70
    #
    path_submit = document.createElement('input')
    path_submit.classList.add('path-submit')
    path_submit.value = "Submit"
    path_submit.type = "submit"
    path_submit.size = 40

    @element.appendChild(path_input)
    @element.appendChild(path_submit)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  setContent: (content) ->
    #

  getElement: ->
    @element
