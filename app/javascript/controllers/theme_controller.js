import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define a static array of theme modes
  static get modes() {
    const now = new Date();
    const year = now.getFullYear();
    let modes = ['system', 'light', 'dark'];
    const start = new Date(year, 9, 1); // months are 0-indexed
    const end = new Date(year, 10, 1);
    if (now >= start && now < end) {
      modes.push('spooky');
    }
    return modes;
  }
  
  connect() {
    this.body = document.body;
    this.prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    this.currentModeIndex = 0;
    
    // Check for mobile and set a default theme
    this.isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    // If on a mobile device, default to 'system' mode
    if (this.isMobile) {
      this.currentModeIndex = this.constructor.modes.indexOf('system');
    } else {
      const savedTheme = localStorage.getItem('theme');
      if (savedTheme && this.constructor.modes.includes(savedTheme)) {
        this.currentModeIndex = this.constructor.modes.indexOf(savedTheme);
      }
    }

    // Set the initial theme based on the index
    this.setTheme(this.constructor.modes[this.currentModeIndex]);

    // Listen for changes to the system's color scheme
    this.prefersDark.addEventListener('change', this.handleSystemPreference.bind(this));
  }

  toggle() {
    // Cycle to the next mode
    this.currentModeIndex = (this.currentModeIndex + 1) % this.constructor.modes.length;
    this.setTheme(this.constructor.modes[this.currentModeIndex]);
  }

  setTheme(mode) {
    // Update the icon and set the desired theme
    const icon = this.element.querySelector('.material-symbols-rounded');
    switch(mode) {
      case 'light':
        icon.textContent = 'brightness_7';
        this.body.classList.remove('dark-mode', 'spooky-mode');
        break;
      case 'dark':
        icon.textContent = 'brightness_4';
        this.body.classList.add('dark-mode');
        this.body.classList.remove('spooky-mode');
        break;
      case 'spooky':
        icon.textContent = 'skull';
        this.body.classList.add('spooky-mode');
        this.body.classList.remove('dark-mode');
        break;
      case 'system':
        icon.textContent = 'brightness_auto';
        this.handleSystemPreference();
        this.body.classList.remove('spooky-mode');
        break;
    }
    // Save the new mode
    localStorage.setItem('theme', mode);
  }

  handleSystemPreference() {
    if (this.prefersDark.matches) {
      this.body.classList.add('dark-mode');
    } else {
      this.body.classList.remove('dark-mode');
    }
  }
}