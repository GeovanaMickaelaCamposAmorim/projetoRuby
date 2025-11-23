import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("✅ Modal Controller conectado!")
    document.body.classList.add("overflow-hidden")
    
    this.escapeHandler = (event) => {
      if (event.key === 'Escape') this.close()
    }
    document.addEventListener('keydown', this.escapeHandler)
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener('keydown', this.escapeHandler)
  }

  close() {
    console.log("🎯 Fechando modal...")
    const modalFrame = document.querySelector('turbo-frame#modal')
    if (modalFrame) {
      modalFrame.remove()
    }
  }

  closeBackground(event) {
    if (event.target.classList.contains('bg-black/25')) {
      this.close()
    }
  }
}