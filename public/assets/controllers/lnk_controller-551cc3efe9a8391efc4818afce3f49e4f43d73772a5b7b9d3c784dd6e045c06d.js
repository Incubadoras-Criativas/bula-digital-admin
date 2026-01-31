import { Controller } from "@hotwired/stimulus"

var obj
export default class Lnk extends Controller {

  static values = { url: String, target: String, params: Object, loading: Boolean, meth: String, containerLoading: String, dialogMsg: Boolean, msg: String, targetHidden: Boolean, timeout: String }

  static targets = ["showHide", "copy", "onLoad"]

  initialize() {

    console.log('lnk initialize')

    this.token = document.querySelector('meta[name="csrf-token"]').content

    obj = this

    this.currentHTML = this.element.innerHTML

    //console.log('LNK', this)
  }

  async click() {

    if (this.loadingValue) {
      this.originalContent = this.element.innerHTML
      this.element.innerHTML = this.loadingIco
    }
    if (this.containerLoadingValue) {
      //console.log('containerLoading')
      document.getElementById(this.containerLoadingValue).innerHTML = this.loadingIco
    }

    let params = ''

    if( this.hasParamsValue) {
      //console.log('params',this.paramsValue)
      let j = this.paramsValue
      params = Object.keys(j).map(function(k){
        return `${encodeURIComponent(k)}=${encodeURIComponent(j[k])}`
      }).join('&')
    }
    let meth = 'PATCH'
    if (this.hasMethValue) {
      meth = this.methValue
    }

    if ( meth === 'PATCH') {

      let url = `${this.urlValue}?target=${this.targetValue}${params.length > 0 ? '&'+params : ''}`
      let method = 'PATCH'
      let credentials = 'same-origin'
      let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }

      try {
        const link = await fetch(url, { method: method, credentials: credentials, headers: headers } )
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html))
        .catch((error) => {
          if( this.loadingValue) {
            this.element.innerHTML = this.originalContent;
          }
          alert(`Não foi possivel atenter a solicitaçao!`)
        })
      } catch (error) {
        const response = await this.fetchWithTimeout(url, method, credentials, headers, 360000)
      }

    } else if ( meth === 'GET') {
      window.location.href = `${this.urlValue}${params.length > 0 ? '?'+params : ''}`
    }

    if ( this.hasTargetHiddenValue && this.targetHiddenValue ) {
      document.getElementById(this.targetValue).style.display = 'none'
    }
  }

  async fetchWithTimeout(url, method, credentials, headers, timeout) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeout)
    const response = await fetch (url, { method: method, credentials: credentials, headers: headers, signal: controller.signal})
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch((error) =>  {
      if( this.loadingValue) {
        this.element.innerHTML = this.originalContent
      }
      alert(`Não foi possivel atenter a solicitaçao!/n[${erro.name}]!`)
    })
    clearTimeout(id)
    return response
  }

  confirm() {
    if (this.hasDialogMsgValue && this.dialogMsgValue) {
      var val = confirm(this.msgValue)
      if (val == true ) {
        this.click()
      }
    }
  }

  showHideTargetConnected(e) {
    e.addEventListener('click', () => {
      e.style.display = 'none'
      let index = this.showHideTargets.indexOf(e)
      let next = index < this.showHideTargets.length - 1 ? index + 1 : 0
      //console.log(index)
      this.showHideTargets[next].style.display = 'block'
    })
  }

  onLoadTargetConnected() {
    console.log('onLoad')
    this.click()
  }



  get loadingIco(){
    return `<div class="page-loading" style="width: 100%; color: #ccc; display: flex; align-items: center; justify-content: center; font-size: 1em;">
      <i class="fas fa-circle-notch fa-spin"></i>
    </div>`
  }

  get lnkErrorMessage(){
    return `<div class="lnk-error">Não foi possivel atenter sua solicitação</div>`
  }
};
