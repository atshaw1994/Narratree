import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "textarea", "form", "userIdInput"]
  static values = { userId: Number }

  open(event) {
    event.preventDefault();
    const userId = event.currentTarget.dataset.warningModalUserIdValue;
    this.userIdInputTarget.value = userId;
    this.textareaTarget.value = "";
    this.modalTarget.style.display = "flex";
    this.textareaTarget.focus();
  }

  close(event) {
    if (event) event.preventDefault();
    this.modalTarget.style.display = "none";
  }

  submit(event) {
    if (!this.textareaTarget.value.trim()) {
      event.preventDefault();
      this.textareaTarget.focus();
      return;
    }
    // Modal closes on submit, form posts as normal
    this.close();
  }
}
