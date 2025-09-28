// app/javascript/controllers/mobile_menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  toggle() {
    this.sidebarTarget.classList.toggle("sidebar-visible");
    document.body.classList.toggle("sidebar-open");
  }
}
