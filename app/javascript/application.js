// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const modal = document.getElementById('login-modal');

function showModal(event) {
event.preventDefault(); 
modal.style.display = 'block';
}

function hideModal() {
modal.style.display = 'none';
}

// Attach event listeners after the DOM has fully loaded
document.addEventListener("DOMContentLoaded", () => {
    // Listener for the Sign Up link to show the modal
    const signupLink = document.querySelector('[data-modal-target="login-modal"]');
    if (signupLink) {
        signupLink.addEventListener('click', showModal);
    }
    
    // Listener for the close button
    const closeBtn = document.querySelector('.close-button');
    if (closeBtn) {
        closeBtn.addEventListener('click', hideModal);
    }

    // Listener for clicks outside the modal
    window.addEventListener('click', function(event) {
        if (event.target == modal) {
            hideModal();
        }
    });

    // You can also add validation logic here.
    const form = document.getElementById('your-form-id'); // Add an ID to your form
    if (form) {
    form.addEventListener('submit', (event) => {
        // Your validation logic goes here.
        // If validation fails, use event.preventDefault() and display an error message.
    });
    }

    // This event listener will handle Turbo page loads
    document.addEventListener("turbo:load", function() {
        // Your Turbo logic
    });
});