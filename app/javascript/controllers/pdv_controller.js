import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('🚀 PDV Controller conectado')
    this.itens = []
    
    // Inicializa depois de um pequeno delay para garantir que o DOM está pronto
    setTimeout(() => {
      this.inicializarBuscaProdutos()
      this.atualizarResumo()
      window.pdvController = this
    }, 100)
  }

  inicializarBuscaProdutos() {
    console.log('🔧 Inicializando busca...')
    
    this.buscaInput = document.getElementById('busca-produto')
    this.sugestoesContainer = document.getElementById('sugestoes-produtos')
    this.listaItens = document.getElementById('lista-itens')
    this.listaVazia = document.getElementById('lista-vazia')
    this.subtotalElement = document.getElementById('subtotal')
    this.totalElement = document.getElementById('total')
    this.descontoInput = document.getElementById('desconto-input')
    this.finalizarBtn = document.getElementById('finalizar-btn')

    console.log('📝 Elementos carregados:', {
      buscaInput: !!this.buscaInput,
      sugestoesContainer: !!this.sugestoesContainer,
      listaItens: !!this.listaItens,
      listaVazia: !!this.listaVazia,
      subtotalElement: !!this.subtotalElement,
      totalElement: !!this.totalElement,
      descontoInput: !!this.descontoInput,
      finalizarBtn: !!this.finalizarBtn
    })

    if (this.buscaInput && this.sugestoesContainer) {
      this.buscaInput.addEventListener('input', this.buscarProdutos.bind(this))
      this.buscaInput.addEventListener('focus', this.mostrarProdutosDisponiveis.bind(this))
      
      document.addEventListener('click', (e) => {
        if (!this.buscaInput.contains(e.target) && !this.sugestoesContainer.contains(e.target)) {
          this.sugestoesContainer.classList.add('hidden')
        }
      })
    }

    if (this.descontoInput) {
      this.descontoInput.addEventListener('input', this.atualizarResumo.bind(this))
    }
  }

  async buscarProdutos(event) {
    const query = event.target.value.trim()
    console.log('🔍 Buscando:', query)
    
    if (query.length >= 2) {
      await this.executarBusca(query)
    } else {
      if (this.sugestoesContainer) {
        this.sugestoesContainer.classList.add('hidden')
      }
    }
  }

  async mostrarProdutosDisponiveis() {
    if (this.buscaInput && this.buscaInput.value.trim() === '') {
      await this.executarBusca('')
    }
  }

  async executarBusca(query) {
    try {
      console.log('🎯 Executando busca:', query)
      const url = `/produtos/search?q=${encodeURIComponent(query)}`
      console.log('📡 URL:', url)
      
      const response = await fetch(url)
      console.log('📊 Status:', response.status)
      
      if (!response.ok) throw new Error('Erro na busca')
      
      const produtos = await response.json()
      console.log('📦 Produtos encontrados:', produtos)
      this.exibirSugestoes(produtos)
    } catch (error) {
      console.error('💥 Erro na busca:', error)
      if (this.sugestoesContainer) {
        this.sugestoesContainer.innerHTML = '<div class="px-4 py-3 text-center text-gray-500">Erro na busca</div>'
        this.sugestoesContainer.classList.remove('hidden')
      }
    }
  }

  exibirSugestoes(produtos) {
    console.log('🎨 Exibindo sugestões:', produtos)
    
    if (!this.sugestoesContainer) {
      console.error('❌ sugestoesContainer não encontrado')
      return
    }
    
    if (produtos.length === 0) {
      this.sugestoesContainer.innerHTML = '<div class="px-4 py-3 text-center text-gray-500">Nenhum produto encontrado</div>'
    } else {
      this.sugestoesContainer.innerHTML = produtos.map(produto => `
        <div class="px-4 py-3 hover:bg-gray-100 cursor-pointer border-b border-gray-100 flex justify-between items-center"
             onclick="window.pdvController.adicionarProdutoPorEvento(${produto.id}, '${produto.pro_nome.replace(/'/g, "\\'")}', ${produto.pro_valor_venda}, '${produto.pro_codigo}')">
          <div>
            <div class="font-medium text-gray-900">${produto.pro_nome}</div>
            <div class="text-sm text-gray-500">Cód: ${produto.pro_codigo} | Estoque: ${produto.pro_quantidade}</div>
          </div>
          <div class="text-right">
            <div class="font-semibold text-tags-rosa">R$ ${parseFloat(produto.pro_valor_venda).toFixed(2)}</div>
            <div class="text-xs text-gray-400">Clique para adicionar</div>
          </div>
        </div>
      `).join('')
    }
    
    this.sugestoesContainer.classList.remove('hidden')
  }

  adicionarProdutoPorEvento(id, nome, preco, codigo) {
    console.log('🛒 Adicionando produto:', { id, nome, preco, codigo })
    this.adicionarProduto({ 
      id: parseInt(id), 
      nome: nome, 
      preco: parseFloat(preco),
      codigo: codigo
    })
    
    if (this.buscaInput) {
      this.buscaInput.value = ''
    }
    if (this.sugestoesContainer) {
      this.sugestoesContainer.classList.add('hidden')
    }
  }

  adicionarProduto(produtoData) {
    const itemExistente = this.itens.find(i => i.id === produtoData.id)
    
    if (itemExistente) {
      itemExistente.quantidade += 1
    } else {
      this.itens.push({
        id: produtoData.id,
        nome: produtoData.nome,
        codigo: produtoData.codigo,
        valor: produtoData.preco,
        quantidade: 1
      })
    }
    
    this.atualizarListaItens()
    this.atualizarResumo()
  }

  atualizarListaItens() {
  if (!this.listaItens || !this.listaVazia) {
    console.error('❌ Elementos da lista não encontrados')
    return
  }

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
          onclick="window.pdvController.decrementarQuantidade(${item.id})"
          class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
        >-</button>
        <span class="w-8 text-center font-medium">${item.quantidade}</span>
        <button 
          onclick="window.pdvController.incrementarQuantidade(${item.id})"
          class="w-8 h-8 border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
        >+</button>
        <button 
          onclick="window.pdvController.removerItem(${item.id})"
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
  incrementarQuantidade(id) {
    console.log('➕ Incrementando produto ID:', id)
    const item = this.itens.find(i => i.id === id)
    if (item) {
      item.quantidade += 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  decrementarQuantidade(id) {
    console.log('➖ Decrementando produto ID:', id)
    const item = this.itens.find(i => i.id === id)
    if (item && item.quantidade > 1) {
      item.quantidade -= 1
      this.atualizarListaItens()
      this.atualizarResumo()
    }
  }

  removerItem(id) {
    console.log('🗑️ Removendo produto ID:', id)
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
      alert('Adicione itens antes de finalizar a venda!')
      return
    }

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
        alert(`Venda finalizada com sucesso! ID: ${result.venda_id}`)
        this.itens = []
        this.atualizarListaItens()
        this.atualizarResumo()
        if (this.descontoInput) {
          this.descontoInput.value = '0'
        }
      } else {
        alert('Erro ao finalizar venda: ' + (result.errors || result.error))
      }
    } catch (error) {
      console.error('Erro:', error)
      alert('Erro ao finalizar venda')
    }
  }

  escapeHtml(unsafe) {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
}