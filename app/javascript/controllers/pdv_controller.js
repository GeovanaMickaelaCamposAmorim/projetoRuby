import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["buscaInput", "listaItens", "listaVazia", "subtotal", "total", "descontoInput", "finalizarBtn"]

  connect() {
    this.itens = []
    this.atualizarResumo()
  }

  async buscarProdutoEnter(event) {
    if (event.key === 'Enter') {
      event.preventDefault()
      await this.buscarProduto()
    }
  }

  async buscarProduto() {
    const termo = this.buscaInputTarget.value.trim()
    if (!termo) return

    try {
      const response = await fetch(`/pdv/buscar_produto?termo=${encodeURIComponent(termo)}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      
      if (!response.ok) throw new Error(`Erro HTTP: ${response.status}`)

      const produtos = await response.json()
      console.log('Produtos encontrados:', produtos)

      if (produtos && produtos.length > 0) {
        this.adicionarProduto(produtos[0])
        this.buscaInputTarget.value = ''
      } else {
        alert('Produto não encontrado!')
      }
    } catch (error) {
      console.error('Erro ao buscar produto:', error)
      alert('Erro ao buscar produto. Verifique o console.')
    }
  }

  adicionarProduto(produto) {
    console.log('Produto recebido:', produto)
    
    const itemExistente = this.itens.find(item => item.id === produto.id)
    
    if (itemExistente) {
      itemExistente.quantidade += 1
    } else {
      this.itens.push({
        id: produto.id,
        nome: produto.nome,
        codigo: produto.codigo,
        valor: produto.valor_venda,
        quantidade: 1
      })
    }

    this.atualizarListaItens()
    this.atualizarResumo()
  }

  atualizarListaItens() {
    const listaItens = this.listaItensTarget
    const listaVazia = this.listaVaziaTarget

    if (this.itens.length === 0) {
      listaVazia.style.display = 'block'
      listaItens.innerHTML = ''
      listaItens.appendChild(listaVazia)
      return
    }

    listaVazia.style.display = 'none'

    listaItens.innerHTML = this.itens.map(item => `
      <div class="px-6 py-4 flex items-center justify-between border-b border-gray-200">
        <div class="flex-1">
          <p class="font-medium text-gray-900">${this.escapeHtml(item.nome)}</p>
          <p class="text-sm text-gray-500">Código: ${this.escapeHtml(item.codigo)}</p>
          <p class="text-sm font-medium text-gray-900">R$ ${item.valor.toFixed(2)}</p>
        </div>
        <div class="flex items-center gap-3">
          <button 
            data-action="click->pdv#decrementarQuantidade" 
            data-id="${item.id}"
            class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors"
          >-</button>
          <span class="w-8 text-center font-medium">${item.quantidade}</span>
          <button 
            data-action="click->pdv#incrementarQuantidade" 
            data-id="${item.id}"
            class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors"
          >+</button>
          <button 
            data-action="click->pdv#removerItem" 
            data-id="${item.id}"
            class="text-red-600 hover:text-red-800 p-2 transition-colors ml-2"
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

  incrementarQuantidade(e) {
    const id = parseInt(e.currentTarget.dataset.id)
    const item = this.itens.find(i => i.id === id)
    if (item) {
      item.quantidade += 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  decrementarQuantidade(e) {
    const id = parseInt(e.currentTarget.dataset.id)
    const item = this.itens.find(i => i.id === id)
    if (item && item.quantidade > 1) {
      item.quantidade -= 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  removerItem(e) {
    const id = parseInt(e.currentTarget.dataset.id)
    this.itens = this.itens.filter(i => i.id !== id)
    this.atualizarListaItens()
    this.atualizarResumo()
  }

  atualizarResumo() {
    const subtotal = this.itens.reduce((s, i) => s + (i.valor * i.quantidade), 0)
    const desconto = parseFloat(this.descontoInputTarget.value) || 0
    const total = Math.max(0, subtotal - desconto)

    this.subtotalTarget.textContent = `R$ ${subtotal.toFixed(2)}`
    this.totalTarget.textContent = `R$ ${total.toFixed(2)}`
    this.finalizarBtnTarget.disabled = this.itens.length === 0 || total <= 0
  }

  async finalizarVenda() {
    if (this.itens.length === 0) {
      alert('Adicione itens antes de finalizar a venda!')
      return
    }

    const clienteSelect = document.getElementById('cliente_id')
    const formaPagamentoSelect = document.getElementById('forma_pagamento')
    
    const vendaData = {
      itens: this.itens,
      cliente_id: clienteSelect ? clienteSelect.value : null,
      forma_pagamento: formaPagamentoSelect ? formaPagamentoSelect.value : null,
      desconto: parseFloat(this.descontoInputTarget.value) || 0
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
        alert(`Venda finalizada com sucesso! ID: ${result.venda_id}`)
        this.itens = []
        this.atualizarListaItens()
        this.atualizarResumo()
        this.descontoInputTarget.value = '0'
      } else {
        alert('Erro ao finalizar venda: ' + (result.errors || result.error))
      }
    } catch (error) {
      console.error('Erro:', error)
      alert('Erro ao finalizar venda')
    }
  }

  // Helper para evitar XSS
  escapeHtml(unsafe) {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
}