import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  lastUserSearchToken = null;
  static targets = ["input", "articlesContainer", "noArticles"]

  connect() {
    this.articles = this.articlesContainerTarget.querySelectorAll(".article-card-list-item");
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase();
  let hasArticleResults = false;
  let hasUserResults = false;

    // Remove previously added user cards
    const prevUserCards = this.articlesContainerTarget.querySelectorAll('.user-card-list-item');
    prevUserCards.forEach(card => card.remove());

    // Filter articles
    this.articles.forEach(article => {
      const title = article.dataset.title;
      if (title.includes(query)) {
        article.style.display = "";
        hasArticleResults = true;
      } else {
        article.style.display = "none";
      }
    });

    // Search for users matching the query
    if (query.length > 0) {
      const userSearchToken = Symbol();
      this.lastUserSearchToken = userSearchToken;
      fetch(`/users/search?query=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(users => {
          // Only process if this is the latest search
          if (this.lastUserSearchToken !== userSearchToken) return;
          const renderedUsernames = new Set();
          users.forEach(user => {
            if (renderedUsernames.has(user.username)) return;
            renderedUsernames.add(user.username);

            const card = document.createElement('a');
            card.className = 'user-card-list-item';
            card.style.display = 'flex';
            card.style.alignItems = 'center';
            card.style.gap = '10px';
            card.style.padding = '10px';
            card.style.textDecoration = 'none';
            card.style.color = 'inherit';
            card.href = `/users/${user.username}`;
            // Add margin-top to the first user card for separation
            if (!hasUserResults) {
              card.style.marginTop = '16px';
            }

            // Profile picture or Material Symbol icon
            if (user.profile_picture_url) {
              const img = document.createElement('img');
              img.src = user.profile_picture_url;
              img.alt = `${user.username} profile picture`;
              img.style.width = '40px';
              img.style.height = '40px';
              img.style.borderRadius = '50%';
              card.appendChild(img);
            } else {
              const icon = document.createElement('span');
              icon.className = 'material-symbols-rounded';
              icon.textContent = 'account_circle';
              icon.style.fontSize = '40px';
              icon.style.color = '#888';
              card.appendChild(icon);
            }

            // User info
            const info = document.createElement('div');
            info.innerHTML = `<strong>${user.first_name} ${user.last_name}</strong><br>@${user.username}`;
            card.appendChild(info);

            this.articlesContainerTarget.appendChild(card);
            hasUserResults = true;
          });
          this.noArticlesTarget.style.display = (hasArticleResults || hasUserResults) ? "none" : "";
        })
        .catch(() => {
          if (this.lastUserSearchToken !== userSearchToken) return;
          this.noArticlesTarget.style.display = (hasArticleResults || hasUserResults) ? "none" : "";
        });
    } else {
      this.noArticlesTarget.style.display = hasArticleResults ? "none" : "";
    }
  }
}