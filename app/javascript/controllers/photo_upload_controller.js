import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
  this.selectedFiles = []
  // Do not preload already attached images into upload preview
  // Only show previews for files newly selected in this session
  }

  openDialog() {
    this.inputTarget.click()
  }

  filesChanged(event) {
    for (const file of event.target.files) {
      if (!this.selectedFiles.some(f => f.name === file.name && f.size === file.size)) {
        this.selectedFiles.push(file)
      }
    }
    this.updatePreviews()
    this.updateFileInput()
  }

  removePhoto(event) {
    const idx = parseInt(event.currentTarget.dataset.idx)
    this.selectedFiles.splice(idx, 1)
    this.updatePreviews()
    this.updateFileInput()
  }

  updatePreviews() {
    this.previewTarget.innerHTML = ''
    this.selectedFiles.forEach((file, idx) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const previewDiv = document.createElement('div')
        previewDiv.style.position = 'relative'
        previewDiv.style.width = '64px'
        previewDiv.style.height = '64px'
        previewDiv.style.display = 'inline-block'

        const img = document.createElement('img')
        img.src = e.target.result
        img.style.width = '64px'
        img.style.height = '64px'
        img.style.objectFit = 'cover'
        img.style.borderRadius = '4px'
        previewDiv.appendChild(img)

        const removeBtn = document.createElement('button')
        removeBtn.type = 'button'
        removeBtn.innerHTML = '✕'
        removeBtn.setAttribute('data-action', 'click->photo-upload#removePhoto')
        removeBtn.setAttribute('data-idx', idx)
        removeBtn.style.position = 'absolute'
        removeBtn.style.top = '-8px'
        removeBtn.style.right = '-8px'
        removeBtn.style.width = '20px'
        removeBtn.style.height = '20px'
        removeBtn.style.background = 'red'
        removeBtn.style.color = 'white'
        removeBtn.style.border = 'none'
        removeBtn.style.borderRadius = '50%'
        removeBtn.style.fontSize = '14px'
        removeBtn.style.cursor = 'pointer'
        removeBtn.style.display = 'flex'
        removeBtn.style.alignItems = 'center'
        removeBtn.style.justifyContent = 'center'
        previewDiv.appendChild(removeBtn)

        this.previewTarget.appendChild(previewDiv)
      }
      reader.readAsDataURL(file)
    })
  }

  updateFileInput() {
    const dataTransfer = new DataTransfer()
    this.selectedFiles.forEach(file => dataTransfer.items.add(file))
    this.inputTarget.files = dataTransfer.files
  }
}
