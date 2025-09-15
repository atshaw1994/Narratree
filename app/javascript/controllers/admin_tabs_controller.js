import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "tabBtn", "tabContent", "searchInput",
    // User table arrows
    "userIdArrow", "usernameArrow", "firstNameArrow", "lastNameArrow", "createdAtArrow", "updatedAtArrow", "encryptedPasswordArrow", "roleArrow",
    // Article table arrows
    "articleIdArrow", "titleArrow", "authorArrow", "createdAtArrow", "updatedAtArrow", "commentsArrow", "photosArrow", "likesArrow"
  ]
  sortState = { users: {}, articles: {} }
  sort(event) {
    const th = event.currentTarget
    const column = th.dataset.adminTabsColumn
    const tab = this.isTabActive("users-tab") ? "users" : "articles"
    const tabId = tab === "users" ? "users-tab" : "articles-tab"
    const table = this.tabContentTargets.find(content => content.id === tabId).querySelector("table")
    const tbody = table.querySelector("tbody")
    const rows = Array.from(tbody.querySelectorAll("tr"))
    // Find column index
    const ths = Array.from(table.querySelectorAll("thead th"))
    const colIdx = ths.indexOf(th)
    // Toggle sort direction
    const currentDir = this.sortState[tab][column] || "asc"
    const newDir = currentDir === "asc" ? "desc" : "asc"
    this.sortState[tab][column] = newDir
    // Sort rows
    rows.sort((a, b) => {
      let aText = a.querySelectorAll("td")[colIdx]?.innerText.trim() || ""
      let bText = b.querySelectorAll("td")[colIdx]?.innerText.trim() || ""
      // Try to parse as number if possible
      const aNum = parseFloat(aText.replace(/[^\d.\-]/g, ""))
      const bNum = parseFloat(bText.replace(/[^\d.\-]/g, ""))
      if (!isNaN(aNum) && !isNaN(bNum)) {
        return newDir === "asc" ? aNum - bNum : bNum - aNum
      }
      // Otherwise compare as string
      return newDir === "asc" ? aText.localeCompare(bText) : bText.localeCompare(aText)
    })
    // Re-append sorted rows
    rows.forEach(row => tbody.appendChild(row))

    // Arrow logic
    this.updateSortArrows(tab, column, newDir)
  }

  updateSortArrows(tab, column, dir) {
    // Map column to arrow target name
    const userArrows = {
      "user-id": this.userIdArrowTarget,
      "username": this.usernameArrowTarget,
      "first-name": this.firstNameArrowTarget,
      "last-name": this.lastNameArrowTarget,
      "created-at": this.createdAtArrowTarget,
      "updated-at": this.updatedAtArrowTarget,
      "encrypted-password": this.encryptedPasswordArrowTarget,
      "role": this.roleArrowTarget
    }
    const articleArrows = {
      "article-id": this.articleIdArrowTarget,
      "title": this.titleArrowTarget,
      "author": this.authorArrowTarget,
      "created-at": this.createdAtArrowTarget,
      "updated-at": this.updatedAtArrowTarget,
      "comments": this.commentsArrowTarget,
      "photos": this.photosArrowTarget,
      "likes": this.likesArrowTarget
    }
    // Clear all arrows first
    Object.values(userArrows).forEach(el => { if (el) el.textContent = "" })
    Object.values(articleArrows).forEach(el => { if (el) el.textContent = "" })
    // Set arrow for sorted column
    if (tab === "users" && userArrows[column]) {
      userArrows[column].textContent = dir === "asc" ? " ▲" : " ▼"
    }
    if (tab === "articles" && articleArrows[column]) {
      articleArrows[column].textContent = dir === "asc" ? " ▲" : " ▼"
    }
  }

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
    this.searchInputTarget.value = ""
    this.filterTables("")
  }

  search() {
    const query = this.searchInputTarget.value.trim().toLowerCase()
    this.filterTables(query)
  }

  filterTables(query) {
    // Check for 'id N' pattern
    const idMatch = query.match(/^id\s*(\d+)$/)
    // Users table
    const usersTab = this.tabContentTargets.find(content => content.id === "users-tab")
    if (usersTab && this.isTabActive("users-tab")) {
      usersTab.querySelectorAll("tbody tr").forEach(row => {
        if (idMatch) {
          // User id is in the second column (after picture)
          const idCell = row.querySelectorAll("td")[1]
          const id = idCell ? idCell.textContent.trim() : ""
          row.style.display = (id === idMatch[1]) ? "" : "none"
        } else {
          const text = row.innerText.toLowerCase()
          row.style.display = (!query || text.includes(query)) ? "" : "none"
        }
      })
    }
    // Articles table
    const articlesTab = this.tabContentTargets.find(content => content.id === "articles-tab")
    if (articlesTab && this.isTabActive("articles-tab")) {
      articlesTab.querySelectorAll("tbody tr").forEach(row => {
        if (idMatch) {
          // Article id is in the first column
          const idCell = row.querySelectorAll("td")[0]
          const id = idCell ? idCell.textContent.trim() : ""
          row.style.display = (id === idMatch[1]) ? "" : "none"
        } else {
          const text = row.innerText.toLowerCase()
          row.style.display = (!query || text.includes(query)) ? "" : "none"
        }
      })
    }
  }

  isTabActive(tabId) {
    const tab = this.tabContentTargets.find(content => content.id === tabId)
    return tab && tab.style.display !== "none"
  }
}
