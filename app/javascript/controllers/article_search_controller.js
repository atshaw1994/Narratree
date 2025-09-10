import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "articlesContainer", "noArticles"]

  connect() {
    this.articles = this.articlesContainerTarget.querySelectorAll(".article-card-list-item");
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase();
    let hasResults = false;

    this.articles.forEach(article => {
      const title = article.dataset.title;
      if (title.includes(query)) {
        article.style.display = ""; // Show the article
        hasResults = true;
      } else {
        article.style.display = "none"; // Hide the article
      }
    });

    if (hasResults) {
      this.noArticlesTarget.style.display = "none";
    } else {
      this.noArticlesTarget.style.display = "";
    }
  }
}