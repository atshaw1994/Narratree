document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.role-dropdown').forEach(function(dropdown) {
    dropdown.addEventListener('change', function(e) {
      var userId = e.target.dataset.userId;
      var accept_btn = document.querySelector('.admin-approve-button[data-user-id="' + userId + '"]');
    var reject_btn = document.querySelector('.admin-reject-button[data-user-id="' + userId + '"]');
      if (accept_btn) accept_btn.style.display = '';
      if (reject_btn) reject_btn.style.display = '';
    });
  });

  // Add cancel button listener
  document.querySelectorAll('.admin-reject-button').forEach(function(cancelBtn) {
    cancelBtn.addEventListener('click', function(e) {
      e.preventDefault();
      var userId = cancelBtn.dataset.userId;
      var form = cancelBtn.closest('.role-form');
      var select = form.querySelector('.role-dropdown');
      // Reset dropdown to its original value
      select.selectedIndex = select.querySelector('option[selected]') ? Array.from(select.options).indexOf(select.querySelector('option[selected]')) : 0;
      // Hide approve and cancel buttons
      var accept_btn = form.querySelector('.admin-approve-button');
      var reject_btn = form.querySelector('.admin-reject-button');
      if (accept_btn) accept_btn.style.display = 'none';
      if (reject_btn) reject_btn.style.display = 'none';
    });
  });

  document.querySelectorAll('.role-form').forEach(function(form) {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      var userId = form.dataset.userId;
      var select = form.querySelector('.role-dropdown');
      var accept_btn = form.querySelector('.admin-approve-button');
      var role = select.value;
      var token = document.querySelector('meta[name="csrf-token"]').content;
      fetch(form.action, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': token,
          'Accept': 'application/json'
        },
        body: JSON.stringify({ role: role })
      })
      .then(function(response) { return response.json(); })
      .then(function(data) {
        if (data.success) {
          accept_btn.style.display = 'none';
          var reject_btn = form.querySelector('.admin-reject-button');
          if (reject_btn) reject_btn.style.display = 'none';
          select.value = data.role;
        } else {
          alert('Failed to update role.');
        }
      });
    });
  });
});
