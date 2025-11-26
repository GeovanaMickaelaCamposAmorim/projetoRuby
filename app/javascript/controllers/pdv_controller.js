import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('🚀 PDV Controller CONECTADO!')
    this.itens = []
    
    // Inicialização com timeout para garantir que o DOM está pronto
    setTimeout(() => {
      this.inicializar()
      window.pdvController = this
    }, 100)
  }

  inicializar() {
    console.log('🔧 Inicializando PDV...')
    
    this.buscaInput = document.getElementById('busca-produto')
    this.sugestoesContainer = document.getElementById('sugestoes-produtos')
    this.listaItens = document.getElementById('lista-itens')
    this.listaVazia = document.getElementById('lista-vazia')
    this.subtotalElement = document.getElementById('subtotal')
    this.totalElement = document.getElementById('total')
    this.descontoInput = document.getElementById('desconto-input')
    this.finalizarBtn = document.getElementById('finalizar-btn')

    console.log('✅ Elementos encontrados:', {
      buscaInput: !!this.buscaInput,
      sugestoesContainer: !!this.sugestoesContainer,
      listaItens: !!this.listaItens,
      descontoInput: !!this.descontoInput,
      finalizarBtn: !!this.finalizarBtn
    })

    // Configurar event listeners manuais como fallback
    this.configurarEventListenersManuais()
    
    // Mostra produtos disponíveis inicialmente
    this.mostrarSugestoesIniciais()
  }

  configurarEventListenersManuais() {
    // Event listener para busca (fallback)
    if (this.buscaInput) {
      this.buscaInput.addEventListener('input', (e) => this.buscarProdutos(e))
      this.buscaInput.addEventListener('focus', () => this.mostrarProdutosDisponiveis())
    }

    // Event listener para desconto (fallback)
    if (this.descontoInput) {
      this.descontoInput.addEventListener('input', () => this.atualizarResumo())
    }

    // Event listener para fechar sugestões ao clicar fora
    document.addEventListener('click', (e) => {
      if (this.sugestoesContainer && 
          !this.buscaInput?.contains(e.target) && 
          !this.sugestoesContainer.contains(e.target)) {
        this.sugestoesContainer.classList.add('hidden')
      }
    })
  }

  // Mostra todos os produtos inicialmente
  mostrarSugestoesIniciais() {
    if (this.sugestoesContainer) {
      console.log('📦 Mostrando produtos iniciais')
      this.sugestoesContainer.classList.remove('hidden')
    }
  }

  // Busca em tempo real - filtro local
  buscarProdutos(event) {
    const query = event.target.value.trim().toLowerCase()
    console.log('🔍 Buscando:', query)
    
    if (!this.sugestoesContainer) return

    const produtos = this.sugestoesContainer.querySelectorAll('[data-action="click->pdv#adicionarProduto"]')
    const mensagemVazia = this.sugestoesContainer.querySelector('.text-center')
    
    let encontrouAlgum = false

    produtos.forEach(produto => {
      const nome = produto.getAttribute('data-pdv-nome-param') || ''
      const codigo = produto.getAttribute('data-pdv-codigo-param') || ''
      
      if (query === '' || nome.toLowerCase().includes(query) || codigo.toLowerCase().includes(query)) {
        produto.style.display = 'flex'
        encontrouAlgum = true
      } else {
        produto.style.display = 'none'
      }
    })

    // Mostra/oculta mensagem de vazio
    if (mensagemVazia) {
      mensagemVazia.style.display = encontrouAlgum ? 'none' : 'block'
    }

    this.sugestoesContainer.classList.remove('hidden')
  }

  // Mostra produtos quando clica no campo
  mostrarProdutosDisponiveis() {
    console.log('🎯 Mostrando produtos disponíveis')
    if (this.sugestoesContainer) {
      this.sugestoesContainer.classList.remove('hidden')
    }
  }

  // Adiciona produto via Stimulus action
  adicionarProduto(event) {
    const element = event.currentTarget
    const id = parseInt(element.getAttribute('data-pdv-id-param'))
    const nome = element.getAttribute('data-pdv-nome-param')
    const preco = parseFloat(element.getAttribute('data-pdv-preco-param'))
    const codigo = element.getAttribute('data-pdv-codigo-param')

    console.log('🛒 Adicionando produto:', { id, nome, preco, codigo })

    const itemExistente = this.itens.find(i => i.id === id)
    
    if (itemExistente) {
      itemExistente.quantidade += 1
    } else {
      this.itens.push({
        id: id,
        nome: nome,
        codigo: codigo,
        valor: preco,
        quantidade: 1
      })
    }
    
    this.atualizarListaItens()
    this.atualizarResumo()
    
    // Limpa a busca e esconde sugestões
    if (this.buscaInput) this.buscaInput.value = ''
    if (this.sugestoesContainer) this.sugestoesContainer.classList.add('hidden')
  }

  atualizarListaItens() {
    if (!this.listaItens || !this.listaVazia) return

    if (this.itens.length === 0) {
      this.listaVazia.style.display = 'block'
      this.listaItens.innerHTML = ''
      this.listaItens.appendChild(this.listaVazia)
      return
    }

    this.listaVazia.style.display = 'none'

    this.listaItens.innerHTML = this.itens.map(item => `
      <div class="px-6 py-4 flex items-center justify-between border-b border-gray-200" data-item-id="${item.id}">
        <div class="flex-1">
          <p class="font-medium text-gray-900">${this.escapeHtml(item.nome)}</p>
          <p class="text-sm text-gray-500">Código: ${this.escapeHtml(item.codigo)}</p>
          <p class="text-sm font-medium text-gray-900">R$ ${item.valor.toFixed(2)}</p>
        </div>
        <div class="flex items-center gap-3">
          <button 
            data-action="click->pdv#decrementarQuantidade"
            data-pdv-id-param="${item.id}"
            class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
          >-</button>
          <span class="w-8 text-center font-medium">${item.quantidade}</span>
          <button 
            data-action="click->pdv#incrementarQuantidade"
            data-pdv-id-param="${item.id}"
            class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
          >+</button>
          <button 
            data-action="click->pdv#removerItem"
            data-pdv-id-param="${item.id}"
            class="text-red-600 hover:text-red-800 p-2 transition-colors ml-2 cursor-pointer"
            title="Remover item"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
            </svg>
          </button>
        </div>
      </div>
    `).join('')
  }

  incrementarQuantidade(event) {
    const id = parseInt(event.currentTarget.getAttribute('data-pdv-id-param'))
    const item = this.itens.find(i => i.id === id)
    if (item) {
      item.quantidade += 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  decrementarQuantidade(event) {
    const id = parseInt(event.currentTarget.getAttribute('data-pdv-id-param'))
    const item = this.itens.find(i => i.id === id)
    if (item && item.quantidade > 1) {
      item.quantidade -= 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  removerItem(event) {
    const id = parseInt(event.currentTarget.getAttribute('data-pdv-id-param'))
    this.itens = this.itens.filter(i => i.id !== id)
    this.atualizarListaItens()
    this.atualizarResumo()
  }

  atualizarResumo() {
    const subtotal = this.itens.reduce((s, i) => s + (i.valor * i.quantidade), 0)
    const desconto = this.descontoInput ? parseFloat(this.descontoInput.value) || 0 : 0
    const total = Math.max(0, subtotal - desconto)

    if (this.subtotalElement) {
      this.subtotalElement.textContent = `R$ ${subtotal.toFixed(2)}`
    }
    if (this.totalElement) {
      this.totalElement.textContent = `R$ ${total.toFixed(2)}`
    }
    if (this.finalizarBtn) {
      this.finalizarBtn.disabled = this.itens.length === 0 || total <= 0
    }
  }

  async finalizarVenda() {
    if (this.itens.length === 0) {
      this.mostrarModalErro('Adicione itens antes de finalizar a venda!')
      return
    }

    const finalizarBtn = document.getElementById("finalizar-btn")
    finalizarBtn.disabled = true
    finalizarBtn.innerHTML = "Processando..."

    const clienteSelect = document.getElementById('cliente_id')
    const formaPagamentoSelect = document.getElementById('forma_pagamento')
    
    const vendaData = {
      itens: this.itens,
      cliente_id: clienteSelect ? clienteSelect.value : null,
      forma_pagamento: formaPagamentoSelect ? formaPagamentoSelect.value : null,
      desconto: this.descontoInput ? parseFloat(this.descontoInput.value) || 0 : 0
    }

    try {
      const response = await fetch('/pdv/finalizar_venda', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify(vendaData)
      })

      const result = await response.json()

      if (result.success) {
        this.mostrarModalSucesso(result)
        this.limparCarrinho()
      } else {
        this.mostrarModalErro(result.errors || result.error)
      }
    } catch (error) {
      console.error('Erro:', error)
      this.mostrarModalErro('Erro ao finalizar venda: ' + error.message)
    } finally {
      finalizarBtn.disabled = false
      finalizarBtn.innerHTML = "Finalizar Venda"
    }
  }

  limparCarrinho() {
    this.itens = []
    this.atualizarListaItens()
    this.atualizarResumo()
    if (this.descontoInput) {
      this.descontoInput.value = '0'
    }
  }

  // MODAIS (mantidos iguais)
  mostrarModalSucesso(dadosVenda) {
    const modalHTML = `
      <div class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-auto transform transition-all duration-300 scale-95 opacity-0 animate-in">
          <div class="p-6 text-center">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100 mb-4">
              <svg class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">Venda Concluída!</h3>
            <div class="text-left bg-gray-50 rounded-lg p-4 mb-4">
              <div class="space-y-2 text-sm text-gray-600">
                <div class="flex justify-between"><span>Nº da Venda:</span><span class="font-semibold">#${dadosVenda.venda_id}</span></div>
                <div class="flex justify-between"><span>Data/Hora:</span><span>${dadosVenda.data}</span></div>
                <div class="flex justify-between"><span>Cliente:</span><span>${this.escapeHtml(dadosVenda.cliente)}</span></div>
                <div class="flex justify-between"><span>Forma de Pagamento:</span><span>${this.escapeHtml(dadosVenda.forma_pagamento)}</span></div>
                <div class="flex justify-between border-t border-gray-200 pt-2 mt-2">
                  <span class="font-semibold">Total:</span>
                  <span class="font-semibold text-green-600">R$ ${typeof dadosVenda.total === 'number' ? dadosVenda.total.toFixed(2) : parseFloat(dadosVenda.total || 0).toFixed(2)}</span>
                </div>
              </div>
            </div>
            <p class="text-gray-600 mb-6">A venda foi registrada com sucesso no sistema.</p>
            <button onclick="window.pdvController.fecharModalSucesso()" 
                    class="w-full bg-tags-rosa text-white py-3 px-4 rounded-lg hover:bg-tags-rosa-dark transition-colors duration-200 font-medium">
              Fechar
            </button>
          </div>
        </div>
      </div>`
    
    document.body.insertAdjacentHTML('beforeend', modalHTML)
    
    setTimeout(() => {
      const modal = document.querySelector('.fixed.inset-0.bg-black\\/50')
      if (modal) {
        modal.querySelector('.transform').classList.remove('scale-95', 'opacity-0')
        modal.querySelector('.transform').classList.add('scale-100', 'opacity-100')
      }
    }, 50)
  }

  mostrarModalErro(erros) {
    const mensagem = Array.isArray(erros) ? erros.join(', ') : erros
    const modalHTML = `
      <div class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-auto">
          <div class="p-6 text-center">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-100 mb-4">
              <svg class="h-8 w-8 text-red-600" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
              </svg>
            </div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">Erro na Venda</h3>
            <p class="text-gray-600 mb-6">${this.escapeHtml(mensagem)}</p>
            <button onclick="window.pdvController.fecharModalErro()" 
                    class="w-full bg-red-600 text-white py-2.5 px-4 rounded-lg hover:bg-red-700 transition-colors duration-200 font-medium">
              Tentar Novamente
            </button>
          </div>
        </div>
      </div>`
    
    document.body.insertAdjacentHTML('beforeend', modalHTML)
  }

  fecharModalSucesso() {
    const modal = document.querySelector('.fixed.inset-0.bg-black\\/50')
    if (modal) modal.remove()
  }

  fecharModalErro() {
    const modal = document.querySelector('.fixed.inset-0.bg-black\\/50')
    if (modal) modal.remove()
  }

  escapeHtml(unsafe) {
    if (!unsafe) return ''
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
}