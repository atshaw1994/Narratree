import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  logout(event) {
    event.preventDefault();
    fetch(this.element.href, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/html,application/xhtml+xml"
      },
      credentials: "same-origin"
    })
      .then(response => {
        if (response.redirected) {
          window.location.href = response.url;
        } else {
          window.location.reload();
        }
      });
  }
}
