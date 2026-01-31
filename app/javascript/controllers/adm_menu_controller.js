import { Controller } from "@hotwired/stimulus"

export default class AdmMenu extends Controller {

  static values = {}
  static targets = ["tabTitle", "tabData", "codemirrorCSS", "selectInTabTitle"]

  initialize() {
    this.cssEditor = false
    this.token = document.querySelector('meta[name="csrf-token"]').content

    console.log('AdmMenu')
  }

  tabTitleTargetConnected(e) {
    e.addEventListener('click', () => {
      if ( !e.classList.contains('selected')) {
        this.tabTitleTargets.forEach((k) => {
          k.classList.remove('selected')
        })
        e.classList.add('selected')

        this.tabDataTargets.forEach((k) => {
          if (e.dataset.target == k.id) {
            k.style.display = 'block'
          } else {
            k.style.display = 'none'
          }
        })
      }
    })
  }

  selectInTabTitleTargetConnected(e) {
    console.log('menu select')
    e.addEventListener('click', () => {
      if ( !e.classList.contains('selected')) {
        this.tabTitleTargets.forEach((k) => {
          k.classList.remove('selected')
        })
        e.classList.add('selected')

        this.tabDataTargets.forEach((k) => {
          if (e.dataset.target == k.id) {
            k.style.display = 'block'
          } else {
            k.style.display = 'none'
          }
        })
      }
    })
    e.addEventListener('change', (k) => {
      this.tabSelect(e)
    })
  }

  async tabSelect(e) {
    e.parentNode.querySelector('svg').style.display = 'block'
    let url = `${e.dataset.url}?option=${e.value}`
    let method = 'PATCH'
    let credentials = 'same-origin'
    let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
    let timeout = 8000

    try {
      const link = await fetch(url, { method: method, credentials: credentials, headers: headers, signal: AbortSignal.timeout(timeout)  } )
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch((error) => {
        alert(`Não foi possivel atenter a solicitaçao!/n[${error.name}]!`)
      })
    } catch (error) {
      const response = await this.tabSelectWithTimeout(url, method, credentials, headers, timeout)
    }
    e.parentNode.querySelector('svg').style.display = 'none'
  }

  async tabSelectWithTimeout(url, method, credentials, headers, timeout) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeout)
    const response = await fetch (url, { method: method, credentials: credentials, headers: headers, signal: controller.signal})
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch((error) =>  {
      alert(`Não foi possivel atenter a solicitaçao!/n[${error.name}]!`)
    })
    clearTimeout(id)
    return response
  }

  ///*
  codemirrorCSSTargetConnected(e) {
    e.addEventListener('click', () => {
      if ( !this.cssEditor ) {
        let editorId = e.dataset.editorId
        CodeMirror.fromTextArea(document.getElementById('app-styles'), {mode: "css", lineNumbers: true });

        this.cssEditor = true;
      }
    })
  }
  //*/

}
