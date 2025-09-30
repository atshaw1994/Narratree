import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hamburger"
export default class extends Controller {
  static targets = ["icon"]

  animate() {
    this.iconTarget.classList.remove("animate-hamburger")
    // Force reflow to restart animation
    void this.iconTarget.offsetWidth
    this.iconTarget.classList.add("animate-hamburger")
  }
}
