import { Controller } from "@hotwired/stimulus"
//import Rails from "@rails/ujs"

var elm
export default class Formfind extends Controller {
  static targets = [ "field", "textfield", "findField", "filterResult" ]
  static values = { url: String, target: String}

  initialize() {

    console.log('formfind')

    this.token = document.querySelector('meta[name="csrf-token"]').content

  }

  connect() {

    elm = this

  }

  /*
  textfieldTargetConnected(e) {

    let textfield = e.querySelector('input[type=text]')
    let clear = e.querySelector('#clear_field')
    textfield.addEventListener('keyup', () => {
      if ( textfield.value.length > 0 ) {
        clear.style.display = 'unset'
      } else {
        clear.style.display = 'none'
      }
    })
    textfield.addEventListener('keydown', (k) => {
      let key = k.witch || k.keyCode
      if ( key == 13 ) {
        elm.fireFind()
      }
      if ( key == 27 ) {
        textfield.value = ''
        clear.style.display = 'none'
        elm.fireFind()
      }
    })

    let clearBtn = e.querySelector('#clear_field')
    clearBtn.addEventListener('click', () => {
      textfield.value = ''
      elm.fireFind()
    })
    let findBtn = e.querySelector('#find_ico')
    findBtn.addEventListener('click', () => {
      if (textfield.value.length > 0) {
        elm.fireFind()
      }
    })
  }

  change() {
    elm.fireFind()
  }

  clearSelect(e) {

    this.fieldTargets.forEach( function(k) {
      if (k.dataset.formfindIdParam === e.params.id) {
        k.value = ''
       elm.fireFind()
      }
    })
  }

  fireFind() {

    let data = []
    elm.fieldTargets.map(function(k){
      data.push(`query[${k.dataset.formfindIdParam}]=${k.value}`)
    })

    //console.log('data:', data)

    document.querySelector(elm.targetValue).innerHTML = elm.loadingIco

    fetch(`${this.urlValue}&${data.join('&')}`, { method: 'PATCH', credentials: 'same-origin', headers: { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token } } )
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch(function(e) {
      document.getElementById(this.targetValue).innerHTML = this.lnkErrorMessage()
      console.log(this.lnkErrorMessage())
      alert('Não foi possivel atenter a solicitaçao!')
    })

  }
  */

  findFieldTargetConnected(e) {
    console.log(e)
    if (e.tagName === 'INPUT') {
      e.addEventListener('keyup', () => {
       this.fireAppsFind()
      })
    }
    if (e.tagName === 'SELECT') {
      e.addEventListener('change', () => {
        this.fireAppsFind()
      })
    }
  }


  async fireAppsFind() {
    let data = []
    this.findFieldTargets.map((k) => {
      data.push(`query[${k.name}]=${k.value}`)
    })

    let target = this.targetValue
    let method = 'PATCH'
    let credentials = 'same-origin'
    let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
    let timeout = 8000

    let url = `${this.urlValue}?target=${target}&${data.join('&')}`

    document.getElementById(this.targetValue).innerHTML = this.loadingIco

    try {
      const find = await fetch(url, { method: method, credentials: credentials, headers: headers, signal: AbortSignal.timeout(timeout)  } )
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch((error) => {
        alert(`Não foi possivel atenter a solicitaçao!`)
      })
    } catch (error) {
      const response = await this.fireAppsFindWithTimeout(url, method, credentials, headers, timeout)
    }
  }

  async fireAppsFindWithTimeout(url, method, credentials, headers, timeout) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeout)
    const response = await fetch (url, { method: method, credentials: credentials, headers: headers, signal: controller.signal})
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch((error) =>  {
      alert(`Não foi possivel atenter a solicitaçao!/n[${erro.name}]!`)
    })
    clearTimeout(id)
    return response
  }

  resultItemTargetConnected(e) {

    e.addEventListener('click', (k) => {
      let target = this.element.dataset.itemTarget
      let content = (e.dataset.tipo == 'lista' ? e.outerHTML : `<input type="hidden" name="email" value="${e.innerText}">${e.outerHTML}`)
      document.getElementById(target).innerHTML = `<input type="hidden" name="invite" value="${e.dataset.visitorId}"><input type="hidden" name="tipo" value="${e.dataset.tipo}"> ${content}<div class="msg" id="invite_turma_status" style="margin-top: 10px; text-align: right; color: green; font-size: 10px;"></div>`
      this.filterResultTarget.innerHTML = ''

      let form = document.getElementById(this.element.dataset.formTarget)
      form.getElementsByClassName('btn-form')[0].classList.remove('disabled')
      form.querySelector('input[type=submit]').disabled = false


    })
  }


  get lnkErrorMessage(){
    return `<div class="lnk-error">Não foi possivel atenter sua solicitação</div>`
  }

  get loadingIco() {
    return `<div class="loading" style="text-align: center"><svg class="svg-inline--fa fa-spinner fa-spin" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="spinner" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M304 48C304 74.51 282.5 96 256 96C229.5 96 208 74.51 208 48C208 21.49 229.5 0 256 0C282.5 0 304 21.49 304 48zM304 464C304 490.5 282.5 512 256 512C229.5 512 208 490.5 208 464C208 437.5 229.5 416 256 416C282.5 416 304 437.5 304 464zM0 256C0 229.5 21.49 208 48 208C74.51 208 96 229.5 96 256C96 282.5 74.51 304 48 304C21.49 304 0 282.5 0 256zM512 256C512 282.5 490.5 304 464 304C437.5 304 416 282.5 416 256C416 229.5 437.5 208 464 208C490.5 208 512 229.5 512 256zM74.98 437C56.23 418.3 56.23 387.9 74.98 369.1C93.73 350.4 124.1 350.4 142.9 369.1C161.6 387.9 161.6 418.3 142.9 437C124.1 455.8 93.73 455.8 74.98 437V437zM142.9 142.9C124.1 161.6 93.73 161.6 74.98 142.9C56.24 124.1 56.24 93.73 74.98 74.98C93.73 56.23 124.1 56.23 142.9 74.98C161.6 93.73 161.6 124.1 142.9 142.9zM369.1 369.1C387.9 350.4 418.3 350.4 437 369.1C455.8 387.9 455.8 418.3 437 437C418.3 455.8 387.9 455.8 369.1 437C350.4 418.3 350.4 387.9 369.1 369.1V369.1z"></path></svg><!-- <i class="fas fa-spinner fa-spin"></i> Font Awesome fontawesome.com --></div>`
  }

}

