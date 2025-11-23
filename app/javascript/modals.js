function abrirModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.showModal();
  }
}

function fecharModal(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.close();
  }
}

function imprimirModal(modalId) {
  window.print();
}

// Event Listeners para todos os modais <dialog>
document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('dialog').forEach(modal => {
    modal.addEventListener('cancel', function() {
      this.close();
    });
    
    modal.addEventListener('click', function(event) {
      if (event.target === this) {
        this.close();
      }
    });
  });
});