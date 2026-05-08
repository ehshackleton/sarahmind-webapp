import { Controller } from "@hotwired/stimulus"

// Revela el bloque al entrar en viewport; respeta prefers-reduced-motion.
export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.element.classList.add("sarah-reveal-visible")
      return
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("sarah-reveal-visible")
            this.observer.unobserve(entry.target)
          }
        })
      },
      { rootMargin: "0px 0px -6% 0px", threshold: 0.06 }
    )
    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
  }
}
