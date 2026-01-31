import { Controller } from "@hotwired/stimulus"

export default class Pagination extends Controller {

  static values =  { mainUrl: String, nextPageUrl: String, page: Number, query: String, filterUrl: String }
  static targets = [ "main", "nextPage", "viewport", "findField"]

  initialize() {

    console.log('pagination controller')

    this.token = document.querySelector('meta[name="csrf-token"]').content

    this.loading = false
  }

  connect() {
    if ( !this.hasViewportTarget ) {
      document.addEventListener('scroll', () => {
        if (this.nextPageTarget.dataset.more == 1 && !this.loading) {
          this.scroll(this.nextPageTarget)
        }
      })
    }
  }

  ///*
  viewportTargetConnected(e) {
    e.addEventListener('scroll', () => {
      if (this.hasViewportTarget && this.hasNextPageTarget && this.inViewPort(this.nextPageTarget) && this.nextPageTarget.dataset.more == 1 && !this.loading) {
        this.scroll(this.nextPageTarget)
      }
    })
  }
  //*/

  async scroll(e) {
    const scrl = await this.nextPage(e)
    return true
  }

  async mainTargetConnected(e) {
    console.log(e)
    let url = this.mainUrlValue
    let method =  'PATCH'
    let credentials =  'same-origin'
    let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
    let timeout = 8000
    try {
      const mainLoad = await fetch(url, { method: method, credentials: credentials, headers: headers, signal: AbortSignal.timeout(timeout)})
      .then(response => response.text() )
      .then(html => Turbo.renderStreamMessage(html))
      .catch(function(e) { console.log(e)})
    } catch (error) {
      mainLoad = await this.mainTargetTimeout(url, method, credentials, headers, timeout)
    }
    return true
  }

  async mainTargetTimeout(url, method, credentials, headers, timeout) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeout)
    const response = await fetch (url, { method: method, credentials: credentials, headers: headers, signal: controller.signal})
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch((error) =>  {
      this.errorName = error.name
      console.log(error.name)
    })
    clearTimeout(id)
    return response
  }


  nextPageTargetConnected(e) {
    this.loading = false
    console.log(e.dataset.page, e.dataset.more)

    ///*
    if ( e.dataset.page == 0 ) {
      this.nextPage(e)
    } else {
      if (this.inViewPort(e) && e.dataset.more == '1') {
        this.nextPage(e)
      }
    }
    //*/
    console.log(document.querySelectorAll('#visitors_lista ul').length)
    e.addEventListener('click', () =>  {
      this.nextPage(e)

    })
  }


  async nextPage(nextPage) {
    this.loading = true
    nextPage.innerHTML = this.loadingIco

    let url = this.nextPageUrlValue
    let params = `page=${nextPage.dataset.page}&query=${nextPage.dataset.query}`
    let method =  'PATCH'
    let credentials =  'same-origin'
    let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
    let timeout = 8000
    let obj = this
    try {
      const next = await fetch(`${url}?${params}`, { method: method, credentials: credentials, headers: headers})
      .then(response => response.text() )
      .then(html => Turbo.renderStreamMessage(html))
      .catch(function(e) {
        console.log(e)
        nextPage.innerHTML.this.nextPageError
      })
    } catch (error) {
      next = await this.nextPageTimeout(url, params, method, credentials, headers, timeout, nextPag, obj)
    }
    return true
  }

  async nextPageTimeout(url, params, method, credentials, headers, timeout, nextPage) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeout)
    const response = await fetch (`${url}?${params}`, { method: method, credentials: credentials, headers: headers, signal: controller.signal})
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch((error) =>  {
      this.errorName = error.name
      console.log(error.name)
      nextPage.innerHTML = obj.nextPageError
    })
    clearTimeout(id)
    return response
  }


  inViewPort(elm) {
    var elm_top = elm.offsetTop
    var window_height = window.innerHeight
    var scroll_top = window.scrollY
    if (this.hasViewportTarget) {
      elm_top = elm.offsetTop
      window_height = this.viewportTarget.offsetHeight
      scroll_top = this.viewportTarget.scrollTop
    }

    console.log('inViewPort', elm_top, window_height, scroll_top, window_height + scroll_top , (elm_top <= (window_height + scroll_top ) ? 1 : 0 ))

    return  (elm_top <= (window_height + scroll_top ) ? 1 : 0 )
  }

  findFieldTargetConnected(e) {
    e.addEventListener('keyup', (k) => {
      if ( k.key === 'Escape') {
        e.value = ''
        this.filter(e.value)
      } else {
        this.filter(e.value)
      }
    })
  }

  async filter(value) {
    console.log('filter', value)

    let url = this.filterUrlValue
    let params = `query=${value}`
    let method =  'PATCH'
    let credentials =  'same-origin'
    let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
    const find = await fetch(`${url}?${params}`, { method: method, credentials: credentials, headers: headers})

    .then(response => response.text() )
    .then(html => Turbo.renderStreamMessage(html))
    .catch(function(e) { console.log(e)})
    return true
  }

  get loadingIco(){
    return `<div class="page-loading" style="width: 100%; color: #ccc; display: flex; align-items: center; justify-content: center; font-size: 1em;  margin-bottom: 12px;">
      <i class="fas fa-circle-notch fa-spin"></i>
    </div>`
  }

  get nextPageError() {
    return `<div class="component-error" style="width: 100%; height: 100px; color: red; display: flex; align-items: center; justify-content: center; font-size: 1.2em; box-shadow: 0 0 3px #ccc; margin-bottom: 12px;">
      <i class="fas fa-exclamation-triangle">Não foi possivel carrgar a página!</i>
    </div>`
  }
};
