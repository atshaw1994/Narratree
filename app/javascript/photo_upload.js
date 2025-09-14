// Handles custom photo upload UI for articles
// Assumes material-symbols-rounded is loaded

document.addEventListener('DOMContentLoaded', function() {
  const uploadBtn = document.getElementById('photo-upload-btn');
  const fileInput = document.getElementById('photo-upload-input');
  const previewContainer = document.getElementById('photo-preview-container');

  // Store selected files in memory
  let selectedFiles = [];

  // Open file dialog when button is clicked
  uploadBtn.addEventListener('click', function() {
    fileInput.click();
  });

  // Handle file selection
  fileInput.addEventListener('change', function(e) {
    for (const file of e.target.files) {
      // Prevent duplicates
      if (!selectedFiles.some(f => f.name === file.name && f.size === file.size)) {
        selectedFiles.push(file);
      }
    }
    updatePreviews();
    updateFileInput();
  });

  // Remove photo by index
  function removePhoto(idx) {
    selectedFiles.splice(idx, 1);
    updatePreviews();
    updateFileInput();
  }

  // Update preview UI
  function updatePreviews() {
    previewContainer.innerHTML = '';
    selectedFiles.forEach((file, idx) => {
      const reader = new FileReader();
      reader.onload = function(e) {
        const previewDiv = document.createElement('div');
        previewDiv.style.position = 'relative';
        previewDiv.style.width = '32px';
        previewDiv.style.height = '32px';
        previewDiv.style.display = 'inline-block';

        const img = document.createElement('img');
        img.src = e.target.result;
        img.style.width = '32px';
        img.style.height = '32px';
        img.style.objectFit = 'cover';
        img.style.borderRadius = '4px';
        previewDiv.appendChild(img);

        // Remove button
        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.innerHTML = '✕';
        removeBtn.style.position = 'absolute';
        removeBtn.style.top = '-8px';
        removeBtn.style.right = '-8px';
        removeBtn.style.width = '20px';
        removeBtn.style.height = '20px';
        removeBtn.style.background = 'red';
        removeBtn.style.color = 'white';
        removeBtn.style.border = 'none';
        removeBtn.style.borderRadius = '50%';
        removeBtn.style.fontSize = '14px';
        removeBtn.style.cursor = 'pointer';
        removeBtn.style.display = 'flex';
        removeBtn.style.alignItems = 'center';
        removeBtn.style.justifyContent = 'center';
        removeBtn.addEventListener('click', function() {
          removePhoto(idx);
        });
        previewDiv.appendChild(removeBtn);

        previewContainer.appendChild(previewDiv);
      };
      reader.readAsDataURL(file);
    });
  }

  // Update the file input's files property
  function updateFileInput() {
    // Create a new DataTransfer to set files
    const dataTransfer = new DataTransfer();
    selectedFiles.forEach(file => dataTransfer.items.add(file));
    fileInput.files = dataTransfer.files;
  }
});
