// app/javascript/controllers/action_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("✅ Action Controller conectado!")
  }

  // Abrir modal de confirmação
  confirm(event) {
    event.preventDefault()
    console.log("🎯 Modal confirm acionado!")
    
    const button = event.currentTarget
    const url = button.dataset.url
    const message = button.dataset.message || "Tem certeza que deseja excluir este item?"

    // Cria o modal dinamicamente
    const modalHTML = `
      <div id="dynamic-modal" class="fixed inset-0 z-50 overflow-y-auto">
        <div class="fixed inset-0 bg-gray-600 bg-opacity-75 transition-opacity" onclick="this.closest('#dynamic-modal').remove(); document.body.classList.remove('overflow-hidden')"></div>
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <div class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
              <div class="sm:flex sm:items-start">
                <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                  <svg class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                  </svg>
                </div>
                <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                  <h3 class="text-base font-semibold leading-6 text-gray-900">Confirmar Exclusão</h3>
                  <div class="mt-2">
                    <p class="text-sm text-gray-500">${message}</p>
                  </div>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
              <form action="${url}" method="post" data-turbo="false">
                <input type="hidden" name="_method" value="delete">
                <input type="hidden" name="authenticity_token" value="${this.getCSRFToken()}">
                <button type="submit" class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-red-500 sm:ml-3 sm:w-auto">
                  Sim, Excluir
                </button>
              </form>
              <button type="button" onclick="this.closest('#dynamic-modal').remove(); document.body.classList.remove('overflow-hidden')" class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto">
                Cancelar
              </button>
            </div>
          </div>
        </div>
      </div>
    `

    // Remove modal anterior se existir
    const existingModal = document.getElementById('dynamic-modal')
    if (existingModal) {
      existingModal.remove()
    }

    // Adiciona o novo modal
    document.body.insertAdjacentHTML('beforeend', modalHTML)
    document.body.classList.add('overflow-hidden')
  }

  getCSRFToken() {
    return document.querySelector('[name="csrf-token"]').content
  }
}