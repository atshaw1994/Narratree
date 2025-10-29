import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define a static array of theme modes
  static get modes() {
    const now = new Date();
    const month = now.getMonth();
    let modes = ['system', 'light', 'dark'];
    if (month === 8 || month === 10) {
      modes.push('fall');
    }
    else if (month === 9) {
      modes.push('spooky');
    }
    else if (month === 11) {
      if (now.getDay() < 26) {
        modes.push('santa');
      }
      else {
        modes.push('newyears'); // After Christmas, push newyears mode
      }
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
    // Remove any class ending with '-mode' from body
    this.body.classList.forEach(cls => {
      if (cls.endsWith('-mode')) this.body.classList.remove(cls);
    });
    switch(mode) {
      case 'light':
        icon.textContent = 'brightness_7';
        break;
      case 'dark':
        icon.textContent = 'brightness_4';
        this.body.classList.add('dark-mode');
        break;
      case 'system':
        icon.textContent = 'brightness_auto';
        this.handleSystemPreference();
        break;
      case 'fall':
        icon.textContent = 'temp_preferences_eco';
        this.body.classList.add('fall-mode');
        break;
      case 'spooky':
        icon.textContent = 'skull';
        this.body.classList.add('spooky-mode');
        break;
      case 'santa':
        icon.textContent = 'mode_cool';
        this.body.classList.add('santa-mode');
        break;
      case 'newyears':
        icon.textContent = 'celebration';
        this.body.classList.add('newyears-mode');
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