// app/javascript/controllers/pdv_controller.js
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
      const response = await fetch(`/produtos/buscar?q=${encodeURIComponent(termo)}`)
      if (!response.ok) throw new Error(`Erro HTTP: ${response.status}`)

      const produtos = await response.json()

      if (produtos.length > 0) {
        // Se quiser autocomplete, podemos implementar aqui depois
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
      return
    }

    listaVazia.style.display = 'none'

    listaItens.innerHTML = this.itens.map(item => `
      <div class="px-6 py-4 flex items-center justify-between border-b border-gray-200">
        <div class="flex-1">
          <p class="font-medium text-gray-900">${item.nome}</p>
          <p class="text-sm text-gray-500">Código: ${item.codigo}</p>
          <p class="text-sm font-medium text-gray-900">R$ ${item.valor.toFixed(2)}</p>
        </div>
        <div class="flex items-center gap-3">
          <button data-action="click->pdv#decrementarQuantidade" data-id="${item.id}"
            class="w-8 h-8 border rounded-full flex items-center justify-center">-</button>
          <span class="w-8 text-center">${item.quantidade}</span>
          <button data-action="click->pdv#incrementarQuantidade" data-id="${item.id}"
            class="w-8 h-8 border rounded-full flex items-center justify-center">+</button>
          <button data-action="click->pdv#removerItem" data-id="${item.id}"
            class="text-red-600 hover:text-red-800 p-2">🗑️</button>
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
    const subtotal = this.itens.reduce((s, i) => s + i.valor * i.quantidade, 0)
    const desconto = parseFloat(this.descontoInputTarget.value) || 0
    const total = subtotal - desconto

    this.subtotalTarget.textContent = `R$ ${subtotal.toFixed(2)}`
    this.totalTarget.textContent = `R$ ${total.toFixed(2)}`
    this.finalizarBtnTarget.disabled = this.itens.length === 0 || total <= 0
  }

  finalizarVenda() {
    alert('Venda finalizada com sucesso!')
    this.itens = []
    this.atualizarListaItens()
    this.atualizarResumo()
    this.descontoInputTarget.value = '0'
  }
}
