import { Controller } from "@hotwired/stimulus"

const ICONS = {
  bold: svg("M8 5h4a3 3 0 0 1 0 6H8zm0 6h5a3 3 0 0 1 0 6H8z"),
  italic: svg("M9 5h8M7 19h8M13 5l-2 14"),
  strike: svg("M5 12h14M9 6a3 3 0 0 1 6 0M15 18a3 3 0 0 1-6 0"),
  link: svg("M10 14l4-4M8 15H7a4 4 0 0 1 0-8h3M16 9h1a4 4 0 0 1 0 8h-3"),
  heading: svg("M6 5v14M18 5v14M6 12h8"),
  quote: svg("M9 8H6v5h3v3l2-2v-3H9zm9 0h-3v5h3v3l2-2v-3h-2z"),
  code: svg("M9 8l-4 4 4 4M15 8l4 4-4 4"),
  bullets: svg("M9 7h10M9 12h10M9 17h10M5 7h.01M5 12h.01M5 17h.01"),
  numbers: svg("M10 7h9M10 12h9M10 17h9M4 7h1v4M4 12h2l-2 2h2M4 16h2l-2 3h2"),
  decrease: svg("M8 8l-3 4 3 4M12 12h7"),
  increase: svg("M16 8l3 4-3 4M5 12h7"),
  undo: svg("M9 8L5 12l4 4M19 12H5"),
  redo: svg("M15 8l4 4-4 4M5 12h14"),
  attach: svg("M8 12.5l5.8-5.8a2.5 2.5 0 0 1 3.5 3.5L10.7 17a4 4 0 1 1-5.7-5.7l6.4-6.4")
}

export default class extends Controller {
  connect() {
    this.decorateToolbar()
  }

  decorateToolbar() {
    const editor = this.element.querySelector("trix-editor")
    if (!editor) return

    const toolbarId = editor.getAttribute("toolbar")
    const toolbar = toolbarId ? document.getElementById(toolbarId) : this.element.querySelector("trix-toolbar")
    if (!toolbar) return

    this.replaceButtonIcon(toolbar, "[data-trix-attribute='bold']", ICONS.bold)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='italic']", ICONS.italic)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='strike']", ICONS.strike)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='href']", ICONS.link)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='heading1']", ICONS.heading)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='quote']", ICONS.quote)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='code']", ICONS.code)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='bullet']", ICONS.bullets)
    this.replaceButtonIcon(toolbar, "[data-trix-attribute='number']", ICONS.numbers)
    this.replaceButtonIcon(toolbar, "[data-trix-action='decreaseNestingLevel']", ICONS.decrease)
    this.replaceButtonIcon(toolbar, "[data-trix-action='increaseNestingLevel']", ICONS.increase)
    this.replaceButtonIcon(toolbar, "[data-trix-action='undo']", ICONS.undo)
    this.replaceButtonIcon(toolbar, "[data-trix-action='redo']", ICONS.redo)
    this.replaceButtonIcon(toolbar, "[data-trix-action='attachFiles']", ICONS.attach)
  }

  replaceButtonIcon(toolbar, selector, iconSvg) {
    const button = toolbar.querySelector(selector)
    if (!button || button.dataset.sarahIconApplied === "true") return

    const label = button.getAttribute("title") || button.getAttribute("aria-label") || button.textContent.trim()
    button.setAttribute("title", label)
    button.setAttribute("aria-label", label)
    button.innerHTML = iconSvg
    button.dataset.sarahIconApplied = "true"
  }
}

function svg(path) {
  return `<svg viewBox="0 0 24 24" aria-hidden="true" class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="${path}"/></svg>`
}
