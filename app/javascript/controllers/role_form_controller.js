import { Controller } from "@hotwired/stimulus";

// Shows the approve button when the role dropdown changes
export default class extends Controller {
  static targets = ["button"];

  showCheck() {
    if (this.hasButtonTarget) {
      this.buttonTarget.style.display = "inline-block";
    }
  }
}
