import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.articles = document.querySelectorAll(".article-card-list-item");
  }

  filter(event) {
    const query = event.target.value.toLowerCase();
    this.articles.forEach(article => {
      const title = article.dataset.title;
      if (title.includes(query)) {
        article.style.display = ""; // Show the article
      } else {
        article.style.display = "none"; // Hide the article
      }
    });
  }
}