import { Controller } from "@hotwired/stimulus"

export default class Form extends Controller {
  static targets = ["cancel", "timming", "spammsg", "disponibilizacao"]
  static values = {cancel: String, cancelTarget: String, url: String, timming: Number }
  initialize() {


    console.log('form controller', this.element)

    if (this.hasCancelTarget) {
      //console.log(this.cancelTarget)
      this.cancelTarget.addEventListener('click', (event) => this.cancelForm(event))
    } else {
      console.log( 'no cancel present' )
    }

    let f = this.element
    let fields = f.querySelectorAll('input, select, textarea, trix-editor')
    fields.forEach(k => {
      k.addEventListener('change', () => {
        let message = f.querySelector('.frm-message')
        if ( message != null) {
          message.innerText = ''
        }
      })
    })
  }

  cancelForm(e) {
    //console.log('cancelForm',e)

    if (this.cancelValue === 'remove') {
      this.element.closest('.frm').remove()
    }
    if (this.cancelValue === 'restore') {
      this.token = document.querySelector('meta[name="csrf-token"]').content
      fetch(`${this.urlValue}?target=${this.cancelTargetValue}`, {method: 'PATCH', credentials: 'same-origin', headers: { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token } })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch(function(e) {

      })
    }
  }

  timmingTargetConnected(e) {
    e.disabled = true
    var t = (parseInt(e.dataset.timming) * 1000)
    var timming = setTimeout( () => {
      e.classList.remove('disabled')
      e.disabled = false
      this.spammsgTarget.innerHTML = ''
    }, t )
    //clearTimeout(timming)
  }

  disponibilizacaoTargetConnected(e) {
    console.log('disponibilizacao')
    e.addEventListener('change', () => {
      let target = this.element.querySelector(e.dataset.target)
      if ( e.value == e.dataset.showValue) {
        target.style.display = 'block'
      } else {
        target.style.display = 'none'
      }
    })
  }
}
