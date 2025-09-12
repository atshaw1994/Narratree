// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    document.addEventListener("click", this.closeDropdownOnClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.closeDropdownOnClickOutside)
  }

  toggle(event) {
    event.preventDefault()
    this.menuTarget.classList.toggle("visible")
  }

  closeDropdownOnClickOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove("visible")
    }
  }
}
