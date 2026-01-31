//import Tiny from 'tinymce'

import { Controller } from "@hotwired/stimulus"

/*
import tinymce from "tinymce"
import Prism from "@prismjs/prism"

import "/prismjs/components/prism-ruby"
import "/prismjs/components/prism-javascript"
import "/prismjs/plugins/toolbar/prism-toolbar"
import "/prismjs/plugins/copy-to-clipboard/prism-copy-to-clipboard"
*/

export default class TinyEditor extends Controller {

  static values = { editorId: String, galleryUrl: String, formMsgId: String, checkerUrl: String, editorHeight: String, mode: String }

  static targets = ["editor", "spellCheck","correction", "observations", "applyCorrection", "correctionContent", "textArea"]

  initialize() {
    console.log('tiny')

    this.token = document.querySelector('meta[name="csrf-token"]').content

    this.loadingPanel = document.querySelector('.tiny-loading')

    this.editor = false;

  }

  respondToVisibility(element, callback) {
    //console.log('visibility:', element.dataset.tinyEditorIdValue)
    var options = {
      root: document.documentElement,
    };

    var observer = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        callback(entry.intersectionRatio > 0);
      });
    }, options);

    observer.observe(element);
  }


  connect() {

    console.log('tiny-connect', this, this.editorIdValue)

    if (!this.hasEditorHeightValue) {
      this.editorHeightValue = '600'
    }

    //inicializa o tinyEditor caso o container esteja visível e o editor ainda não tenha sido carregado
    ///*
    this.respondToVisibility(this.element, visible => {

      const state = this.element.checkVisibility()
      //console.log(this.element.dataset.tinyEditorIdValue, state)
      if ( state ) {
        if (!this.editor) {
          this.textAreaConnect()
          this.initializeEditor(this)
          this.editor = true
        }
      }
    })
    //*/
    //this.initializeEditor(this)
  }



  textAreaConnect() {
    /*
    this.ident = document.createElement('p')
    this.ident.id = `loading-${this.editorIdValue}`
    this.ident.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>&nbsp<span class="fa5-text">Carregando editor - ${this.editorIdValue}</span>`
    this.loadingPanel.appendChild(this.ident)

    this.loadingPanel.style.display = 'block'
    */
  }

  textAreaInitialized() {
    try {
      this.loadingPanel.removeChild(this.ident)
      this.loadingPanel.style.display = 'none'
    } catch (error)  {
      console.log ( this.ident)
      alert('textAreaInitialized')
    }
  }

  click() {
    //console.log('tinymce click')
  }

  disconect() {
    ///('disconected')
    tinymce.remove(`#${this.editorIdValue}`)
  }

  initializeEditor(elm) {
    //console.log('initializeEditor', `#${elm.editorIdValue}` )

    //tinymce.remove(`#${elm.editorIdValue}`)

    let editorId = `textarea#${elm.editorIdValue}.tinymce`
    //console.log(editorId)

    let toolBar = ["formatselect | bold italic underline strikethrough | alignleft  aligncenter alignjustify alignright | forecolor backcolor |  numlist bullist table | indent outdent" ]

    if (this.modeValue == 'discurssiva') {
      toolBar = ["formatselect | bold italic underline strikethrough | alignleft  aligncenter alignjustify alignright | forecolor backcolor |  numlist bullist"]
    }

    TinyMCERails.configuration.default = {
      //selector: "textarea.tinymce",
      selector: editorId,
      cache_suffix: "?v=6.6.0",
      browser_spellcheck: true,
      menubar: false,
      paste_merge_formats: true,
      toolbar: toolBar, //["formatselect | bold italic underline strikethrough | alignleft  aligncenter alignjustify alignright | forecolor backcolor |  numlist bullist | galleryButton embedYoutube embedGoogleDocs link | code | iaCheck"],
      table_toolbar: 'tableprops tabledelete | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol',
      plugins: "link,importcss,lists, codesample,code,wordcount,image, noneditable, table, autosave",
      content_css: ["/assets/tiny.css"],
      height: elm.editorHeightValue,
      language: 'pt_BR',
      content_style: 'body { background-color: transparent !important; }',

      //noneditable_leave_contenteditable: true,
      noneditable_class: 'tiny-component',
      noneditable_noneditable_class: 'tiny-component',
      //editable_class: 'e-pm',
      //extended_valid_elements: ["svg[xmlns|viewBox|width|height|focusable]", "path[d]", "audio[src]", "pre[class]", "code[class]"],
      valid_elements: '*[*]',
      relative_urls: false,
       /*
      codesample_languages: [
        { text: 'HTML/XML', value: 'markup' },
        { text: 'JavaScript', value: 'javascript' },
        { text: 'CSS', value: 'css' },
        { text: 'PHP', value: 'php' },
        { text: 'Ruby', value: 'ruby' },
        { text: 'Python', value: 'python' },
        { text: 'Java', value: 'java' },
        { text: 'C', value: 'c' },
        { text: 'C#', value: 'csharp' },
        { text: 'C++', value: 'cpp' }
      ],
      codesample_global_prismjs: true,
      //*/

    };

    TinyMCERails.initialize('default', {})

    /*
    TinyMCERails.initialize('default', {
      setup: function(editor) {
        editor.ui.registry.addButton('galleryButton', {
          icon: 'gallery',
          tooltip: 'Galeria',
          onAction: (_) => showGallery(editor)
          //editor.insertContent(`<spam>Botão Clicado<spam>`)
        })

        editor.on('change', (e) => {
          let k = elm.element.querySelector(elm.formMsgIdValue)
          if (k != null ) {
            k.innerHTML = ''
          }

          let form = elm.element.closest('form')
          if (form != null ) {
            form.dispatchEvent(new Event('change'))
          }
        })

        editor.on('init', (e) => {
          //console.log('****** init')
          elm.textAreaInitialized()
        })
        editor.on('SetContent', (e) => {
          var codes = editor.getBody().querySelectorAll('pre[class^="language-"]');
          codes.forEach(function(pre) {
            pre.classList.add('highlight');
          })
        })

        function showGallery(e) {
          let url = elm.galleryUrlValue
          let editor_id = elm.editorIdValue
          let method = 'PATCH'
          let credentials = 'same-origin'
          let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': elm.token }

          fetch(`${url}?editor_id=${editor_id}`, { method: 'PATCH', credentials: credentials, headers: headers})
          .then(response => response.text())
          .then(html => Turbo.renderStreamMessage(html))
          .catch((error) => {
            alert(`Não foi possivel atenter a solicitaçao!`)
          })
        }

        editor.ui.registry.addIcon('ico_youtube', youtubeSVG())
        editor.ui.registry.addButton('embedYoutube', {
          icon: 'ico_youtube',
          tooltip: 'Incorporar vídeo do YouTube',
          onAction: () => youtubeDialog()
        })

        function youtubeDialog() {

          let currentNode = tinymce.activeEditor.selection.getNode()
          let ytUrl = (currentNode.hasAttribute('data-yt-url') ? currentNode.dataset.ytUrl : '')

          const youtubeConfig = {
            title: 'Vídeo do Youtube',
            body: { type: 'panel',
              items: [{type: 'input', name: 'ytUrl', label: 'URL do vídeo'}]},
            buttons: [{type: 'cancel',name: 'closeButton',text: 'Cancelar'}, {type: 'submit',name: 'submitButton',text: 'Incorporar', buttonType: 'primary'}],
            initialData: {ytUrl: ytUrl},
            onSubmit: (api) => {
              const data = api.getData()
              const url = data.ytUrl.split('/').slice(-1)[0]
              //console.log(url)
              let embedCode = `<div class="tiny-component mceNonEditable yt-iframe" data-yt-url="${data.ytUrl}"><iframe  width="1024" height="576" src="https://www.youtube.com/embed/${url}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen style="max-width: 100%;"></iframe><div class="yt-mask"></div></div>`
              tinymce.activeEditor.execCommand('mceInsertContent', false, embedCode)
              api.close()
            }
          }

          editor.windowManager.open(youtubeConfig)
        }

        editor.ui.registry.addIcon('ico_docs', fileSVG(24, 24))
        editor.ui.registry.addButton('embedGoogleDocs', {
          icon: 'ico_docs',
          tooltip: 'Incorporar documento do Google',
          onAction: () => googleDocsDialog()
        })
        function googleDocsDialog() {

          let currentNode = tinymce.activeEditor.selection.getNode()
          let gdUrl = (currentNode.hasAttribute('data-gd-url') ? currentNode.dataset.gdUrl : '')

          const googleDocsDialogConfig = {
            title: 'Documento do Google',
            body: { type: 'panel',
              items: [{type: 'input', name: 'gDocUrl', label: 'Url do documento'}]},
            buttons: [{type: 'cancel', name: 'closeButton', text: 'Cancelar'}, {type: 'submit', name: 'submitButton', text: 'Incorporar', buttonType: 'primary'}],
            initialData: {gDocUrl: gdUrl},
            onSubmit: (api) => {
              const data = api.getData()
              const url = data.gDocUrl
              let contentContainer = gDocPreview(data.gDocUrl)
              let embedCode = `<div class="tiny-component gd-frame" data-gd-url="${data.gDocUrl}" data-controller="attachments", data-attachments-target="gd" data-attachments-type-value="gd">${gDocPreview(data.gDocUrl)}</div>`
              tinymce.activeEditor.execCommand('mceInsertContent', false, embedCode)
              api.close()
            }
          }
          editor.windowManager.open(googleDocsDialogConfig)
        }

        editor.ui.registry.addButton('iaCheck',{
          icon: 'spell-check',
          tooltip: 'Corretor de texto',
          onAction: (_) => showCorretor(editor)
        })
        function showCorretor(e) {
          //console.log("url:", elm.checkerUrlValue)
          if (elm.spellCheckTarget.classList.contains('show')) {
            elm.spellCheckTarget.classList.remove('show')
            elm.editorTarget.classList.add('show')
          } else {
            elm.spellCheckTarget.classList.add('show')
            elm.editorTarget.classList.remove('show')
            elm.spellChecker(editor.getContent())
          }
        }
      }

    });

  */
  }
  //*/

  /*
  async spellChecker(content) {

    this.correctionContentTarget.innerHTML = this.loadingPanel(0)
    //if(this.correctionContentTarget.innerHTML.length == 0) {

      let url = this.checkerUrlValue
      let method = 'POST'
      let formData = new FormData()
      formData.append('checker[text]', content)
      let credentials = 'same-origin'
      let headers = { Accept: "text/vnd.turbo-stream.html", 'X-CSRF-Token': this.token }
      let timeout = 36000
      const result = await fetch(url, { body: formData, method: method, credentials: credentials, headers: headers, signal: AbortSignal.timeout(timeout)  } )
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
      .catch((error) => {
        alert(`Não foi possivel atenter a solicitaçao!`)
      })

  }
  */

  /*
  loadingPanel() {
    return `<div class="loading-panel"><i class="fa-solid fa-spinner fa-spin"></i><p>Aplicando IA de revisão do texto</></div>`
  }

  applyCorrectionTargetConnected(e) {
    e.addEventListener('click', () => {
      tinymce.activeEditor.setContent(e.dataset.content)
      this.correctionContentTarget.innerHTML = ''
    })
  }

  reloadTargetConnected(e) {
    e.addEventListener('click', () => {
      this.spellChecker(tinymce.activeEditor.getContent())
    })
  }
  */
}

/*
function youtubeSVG() {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512" width=24 height=24><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M549.7 124.1c-6.3-23.7-24.8-42.3-48.3-48.6C458.8 64 288 64 288 64S117.2 64 74.6 75.5c-23.5 6.3-42 24.9-48.3 48.6-11.4 42.9-11.4 132.3-11.4 132.3s0 89.4 11.4 132.3c6.3 23.7 24.8 41.5 48.3 47.8C117.2 448 288 448 288 448s170.8 0 213.4-11.5c23.5-6.3 42-24.2 48.3-47.8 11.4-42.9 11.4-132.3 11.4-132.3s0-89.4-11.4-132.3zm-317.5 213.5V175.2l142.7 81.2-142.7 81.2z"/></svg>`
}

function fileSVG(w, h) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" width=${w} height=${h}><!--!Font Awesome Free 6.6.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM112 256l160 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-160 0c-8.8 0-16-7.2-16-16s7.2-16 16-16zm0 64l160 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-160 0c-8.8 0-16-7.2-16-16s7.2-16 16-16zm0 64l160 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-160 0c-8.8 0-16-7.2-16-16s7.2-16 16-16z"/></svg>`
}

function gDocPreview(url) {
  return `
    <div class="gDocPreview">
      <div class="gDocIco"><img src="/file-text.png"></div>
      <div class="gDocUrl">${url}</div>
    </div>`
}
*/;
