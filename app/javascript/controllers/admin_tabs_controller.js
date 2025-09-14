import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tabBtn", "tabContent"]

  connect() {
    this.showTab("users")
  }

  switch(event) {
    const tab = event.currentTarget.dataset.tab
    this.showTab(tab)
    this.tabBtnTargets.forEach(btn => btn.classList.remove("active"))
    event.currentTarget.classList.add("active")
  }

  showTab(tab) {
    this.tabContentTargets.forEach(content => {
      content.style.display = content.id === `${tab}-tab` ? "block" : "none"
    })
  }
}
