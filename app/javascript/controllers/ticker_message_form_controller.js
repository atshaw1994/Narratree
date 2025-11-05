import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  connect() {
    this.toggleButton()
  }

  inputChanged() {
    this.toggleButton()
  }

  toggleButton() {
    const hasText = this.inputTarget.value.trim().length > 0
    this.buttonTarget.disabled = !hasText
  }
}
