import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["edit", "overlay", "fileInput"]

  showOverlay() {
    this.overlayTarget.style.opacity = 1;
  }

  hideOverlay() {
    this.overlayTarget.style.opacity = 0;
  }

  triggerFileInput() {
    this.fileInputTarget.click();
  }
}
