import { Controller } from "@hotwired/stimulus"
//import Trix from 'trix'

export default class Trix extends Controller {

  static values = { mode: String }
  static targets = ["editor"]
  initialize() {
    console.log(this.editor)
    console.log(this.toolbar)
    this.toolbar.remove()

    this.editorTarget.addEventListener('trix-before-paste', (event) => this.contentPaste(event))

    this.editorTarget.addEventListener('trix-file-accept', (event) => this.contentFile(event))
  }


  get editor() {
    return this.element.editor
  }

  get toolbar () {
    return this.element.toolbarElement
  }

  contentPaste(e) {

    if (e.paste.type === 'text/html' || e.paste.type === 'text/plain')  {
      if (e.paste.type === 'text/html') {
        if (e.paste.dataTransfer.files.length > 0) {
          this.pasteFile(e.paste.dataTransfer.files = null)
          e.paste.html = ''
        }
        e.paste.html = e.paste.html.replaceAll(/<[^>]*>/g, '')
      }

    } else {
      e.preventDefault()
    }
  }

  contentFile(e) {
    e.preventDefault()
  }

};
