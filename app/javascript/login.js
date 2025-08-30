document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('login-form'); // Use a unique ID for your form
  const emailInput = document.getElementById('user_email'); // Use a unique ID for your email input
  const errorMessage = document.getElementById('email-error'); // Use a unique ID for your error message element

  if (form) {
    form.addEventListener('submit', (event) => {
      // Regular expression to validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      
      if (!emailRegex.test(emailInput.value)) {
        // Prevent the form from submitting
        event.preventDefault(); 
        // Display the custom error message
        errorMessage.textContent = 'Please enter a valid email address, such as user@example.com.';
        errorMessage.style.display = 'block'; // Make the error message visible
      } else {
        // If the email is valid, hide the error message
        errorMessage.style.display = 'none';
      }
    });
  }
});