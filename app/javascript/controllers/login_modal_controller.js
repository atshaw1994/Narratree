import { Controller } from "@hotwired/stimulus"

console.log("Login Modal Controller Loaded");

export default class extends Controller {
  static targets = ["modal"];

  show(event) {
    event.preventDefault();
    console.log("Showing login-modal...");
    this.modalTarget.classList.add("visible");
    // Hide sidebar if open
    const sidebar = document.querySelector('.mobile-sidebar.sidebar-visible');
    if (sidebar) {
      sidebar.classList.remove('sidebar-visible');
    }
  }

  hide() {
    this.modalTarget.classList.remove("visible");
  }
}
