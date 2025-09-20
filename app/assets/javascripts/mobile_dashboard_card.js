document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.mobile-dashboard-card').forEach(function(card) {
    card.addEventListener('click', function(e) {
      // Prevent navigation if a link or button inside the card was clicked
      if (e.target.closest('a, button, input, select, textarea')) return;
      var url = card.getAttribute('data-user-url');
      if (url) {
        window.location.href = url;
      }
    });
  });
});
