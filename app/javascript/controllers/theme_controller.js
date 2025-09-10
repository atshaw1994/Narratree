import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define a static array of theme modes
  static modes = ['system', 'light', 'dark'];
  
  connect() {
    this.body = document.body;
    this.prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    this.currentModeIndex = 0;

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
      this.currentModeIndex = this.constructor.modes.indexOf(savedTheme);
    } else {
      this.currentModeIndex = 0;
    }

    this.setTheme(this.constructor.modes[this.currentModeIndex]);
    this.handleSystemPreference();
    
    // Listen for changes to the system's color scheme
    this.prefersDark.addEventListener('change', this.handleSystemPreference.bind(this));
  }

  toggle() {
    // Cycle to the next mode
    this.currentModeIndex = (this.currentModeIndex + 1) % this.constructor.modes.length;
    this.setTheme(this.constructor.modes[this.currentModeIndex]);
    this.handleSystemPreference();
  }

  setTheme(mode) {
    // Remove old classes and set the new one
    this.body.classList.remove('light-mode', 'dark-mode', 'system-mode');
    this.body.classList.add(`${mode}-mode`);

    // Update the icon
    const icon = this.element.querySelector('.material-symbols-rounded');
    switch(mode) {
      case 'light':
        icon.textContent = 'brightness_7';
        break;
      case 'dark':
        icon.textContent = 'brightness_4';
        break;
      case 'system':
        icon.textContent = 'brightness_auto';
        break;
    }
    
    // Save the new mode
    localStorage.setItem('theme', mode);
  }

  handleSystemPreference() {
    if (this.body.classList.contains('system-mode')) {
      if (this.prefersDark.matches) {
        this.body.classList.add('dark-mode');
      } else {
        this.body.classList.remove('dark-mode');
      }
    }
  }
}