import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { userId: Number, following: Boolean, followUrl: String, unfollowUrl: String }
  static targets = ["icon", "button"]

  async toggleFollow(event) {
    event.preventDefault()
    const url = this.followingValue ? this.unfollowUrlValue : this.followUrlValue
    const method = "POST"
    const response = await fetch(url, {
      method,
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
      credentials: "same-origin"
    })
    if (response.ok) {
      this.followingValue = !this.followingValue
      this.updateButton()
    }
  }

  connect() {
    this.updateButton()
  }

  updateButton() {
    if (this.followingValue) {
      this.iconTarget.textContent = "person_remove"
      this.buttonTarget.title = "Unfollow User"
    } else {
      this.iconTarget.textContent = "person_add"
      this.buttonTarget.title = "Follow User"
    }
  }
}
