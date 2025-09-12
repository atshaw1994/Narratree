import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    title: String
  }

  share(event) {
    event.preventDefault();
    if (navigator.share) {
      navigator.share({
        text: `View this article on Narratree:\n${this.titleValue}\n${this.urlValue}`
      }).catch((error) => {
        // Optionally handle share errors
        console.error("Share failed:", error);
      });
    } else {
      alert("Sharing is not supported on this device/browser.");
    }
  }
}
