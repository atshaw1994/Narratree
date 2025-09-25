import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { url: String, method: String, confirm: String };

  handleAction(event) {
    event.preventDefault();
    if (!window.confirm(this.confirmValue)) return;
    const isMobile = window.innerWidth < 620;
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = this.urlValue + (isMobile ? '?mobile=1' : '?desktop=1');
    const methodInput = document.createElement('input');
    methodInput.type = 'hidden';
    methodInput.name = '_method';
    methodInput.value = this.methodValue;
    form.appendChild(methodInput);
    const csrf = document.querySelector('meta[name="csrf-token"]');
    if (csrf) {
      const csrfInput = document.createElement('input');
      csrfInput.type = 'hidden';
      csrfInput.name = 'authenticity_token';
      csrfInput.value = csrf.content;
      form.appendChild(csrfInput);
    }
    document.body.appendChild(form);
    form.submit();
  }
}
