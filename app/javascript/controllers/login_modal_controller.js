import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"];
  // Listen for AJAX login errors and display them in the modal
  connect() {
    document.addEventListener("ajax:error", (event) => {
      if (event.target.closest("#login-modal")) {
        const [data, status, xhr] = event.detail;
        let errorMsg = "Invalid email or password.";
        if (data && data.errors) {
          errorMsg = data.errors.join("<br>");
        }
        const errorDiv = document.getElementById("login-modal-errors");
        if (errorDiv) errorDiv.innerHTML = errorMsg;
      }
    });
    document.addEventListener("ajax:success", (event) => {
      if (event.target.closest("#login-modal")) {
        // On successful login, reload page or hide modal
        window.location.reload();
      }
    });
  }

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
