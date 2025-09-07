document.addEventListener('turbo:load', () => {
  const themeToggle = document.getElementById('theme-toggle');
  const body = document.body;
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

  const modes = ['system', 'light', 'dark'];
  let currentModeIndex = 0;

  // Function to set the theme and update the icon
  function setTheme(mode) {
    // Remove old classes and set the new one
    body.classList.remove('light-mode', 'dark-mode', 'system-mode');
    if (mode === 'light') {
      body.classList.add('light-mode');
      themeToggle.innerHTML = '<span class="material-symbols-rounded">brightness_7</span>';
    } else if (mode === 'dark') {
      body.classList.add('dark-mode');
      themeToggle.innerHTML = '<span class="material-symbols-rounded">brightness_4</span>';
    } else if (mode === 'system') {
      body.classList.add('system-mode');
      themeToggle.innerHTML = '<span class="material-symbols-rounded">brightness_auto</span>';
    }
    // Save the new mode
    localStorage.setItem('theme', mode);
  }

  // Function to handle the system preference change
  function handleSystemPreference() {
    if (body.classList.contains('system-mode')) {
      if (prefersDark.matches) {
        body.classList.add('dark-mode');
      } else {
        body.classList.remove('dark-mode');
      }
    }
  }

  // Initial setup on page load
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme) {
    currentModeIndex = modes.indexOf(savedTheme);
  } else {
    // Default to 'system' mode
    currentModeIndex = 0;
  }
  
  setTheme(modes[currentModeIndex]);
  handleSystemPreference();
  
  // Listen for clicks on the toggle button
  themeToggle.addEventListener('click', () => {
    // Cycle to the next mode
    currentModeIndex = (currentModeIndex + 1) % modes.length;
    setTheme(modes[currentModeIndex]);
    handleSystemPreference();
  });

  // Listen for changes to the system's color scheme
  prefersDark.addEventListener('change', handleSystemPreference);
});
