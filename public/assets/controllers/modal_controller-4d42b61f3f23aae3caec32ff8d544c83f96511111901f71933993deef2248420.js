import { Controller } from "@hotwired/stimulus"

export default class Modal extends Controller {
  static values ={mode: String}
  connect() {
    //console.log('modal_controller connected')
    if (this.modeValue == 'hideScroll') {
      document.body.style.overflow = 'hidden'
      document.addEventListener('keydown', (k) => {
        let key = k.witch || k.keyCode
        if ( key == 27 ) {
          k.preventDefault()
          this.close()
        }
      })
    }
  }

  disconnect() {
    //console.log('modal disconnect')
    this.close()
  }

  close() {
    this.element.style.display = 'none'
    this.element.innerHTML = ''
    if (this.modeValue == 'hideScroll') {
      document.body.style.overflow = 'visible'
      this.element.remove()
    }
  }

  flash_close() {
    this.element.remove()

  }
};
