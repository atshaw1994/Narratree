import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.cardTargets.forEach(card => {
      card.addEventListener("click", (e) => {
        // Prevent navigation if a link, button, or .user-actions/.mobile-dashboard-article-actions is clicked
        if (
          e.target.closest('.user-actions, .mobile-dashboard-article-actions') ||
          e.target.closest('a, button, input, select, textarea')
        ) {
          return;
        }
        const url = card.getAttribute('data-url');
        if (url) {
          window.location = url;
        }
      });
    });
  }
}
