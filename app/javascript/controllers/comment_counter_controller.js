import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "count"]

  connect() {
    this.update()
  }

  update() {
    const maxLength = this.textareaTarget.getAttribute("maxlength")
    const currentLength = this.textareaTarget.value.length
    this.countTarget.textContent = `${maxLength - currentLength} / ${maxLength}`
  }
}
