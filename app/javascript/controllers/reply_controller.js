// app/javascript/controllers/reply_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formContainer", "repliesContainer", "repliesLink"];
  static values = { id: Number, articleId: Number };

  connect() {
    
  }

  toggleReplies(event) {
    event.preventDefault();
    console.log("hasRepliesContainerTarget: ", this.hasRepliesContainerTarget);
    if (this.hasRepliesContainerTarget) {
      if (this.repliesContainerTarget.classList.contains('hidden')) {
        this.repliesContainerTarget.classList.remove('hidden');
        this.repliesLinkTarget.textContent = 'Hide Replies';
      } else {
        this.repliesContainerTarget.classList.add('hidden');
        const replyCount = this.repliesContainerTarget.children.length;
        this.repliesLinkTarget.textContent = `View ${replyCount === 1 ? 'Reply' : 'Replies'}`;
      }
    }
  }

  async toggleForm() {
    // If the form is already open, close it.
    if (this.formContainerTarget.hasChildNodes()) {
      this.formContainerTarget.innerHTML = ""
      return
    }

    // Otherwise, fetch and display the form.
    try {
      const response = await fetch(`/articles/${this.articleIdValue}/comments/${this.idValue}/reply_form`)

      if (response.ok) {
        this.formContainerTarget.innerHTML = await response.text()
        
        // Add character counter logic to the newly added form.
        const textarea = this.formContainerTarget.querySelector('.reply-textarea')
        const charCount = this.formContainerTarget.querySelector('.char-count')
        const maxLength = 250
        
        if (textarea && charCount) {
          charCount.textContent = `${maxLength}/${maxLength}`
          textarea.addEventListener('input', () => {
            const remaining = maxLength - textarea.value.length
            charCount.textContent = `${remaining}/${maxLength}`
            charCount.style.color = remaining < 0 ? 'red' : 'inherit'
          })
        }
      } else {
        console.error("Failed to fetch reply form:", response.statusText)
      }
    } catch (error) {
      console.error("An error occurred while fetching the reply form:", error)
    }
  }
}