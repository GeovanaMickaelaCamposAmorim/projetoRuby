// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = []

//   connect() {
//     console.log("Label controller connected!")
//     this.initializeEventListeners()
//     this.loadProducts()
//   }

//   initializeEventListeners() {
//     // Atualizar cor da etiqueta
//     const colorInput = document.getElementById('label-color')
//     if (colorInput) {
//       colorInput.addEventListener('input', (e) => {
//         this.updateLabelColor(e.target.value)
//       })
//     }

//     // Selecionar produto
//     const productSelect = document.getElementById('product-select')
//     if (productSelect) {
//       productSelect.addEventListener('change', (e) => {
//         this.updateProductDetails(e.target.value)
//       })
//     }

//     // Botão cancelar
//     const cancelButton = document.getElementById('cancel-button')
//     if (cancelButton) {
//       cancelButton.addEventListener('click', () => {
//         this.clearForm()
//       })
//     }

//     // Botão gerar etiquetas
//     const generateButton = document.getElementById('generate-button')
//     if (generateButton) {
//       generateButton.addEventListener('click', () => {
//         this.generateLabels()
//       })
//     }

//     // Modal buttons
//     const modalCancel = document.getElementById('modal-cancel')
//     if (modalCancel) {
//       modalCancel.addEventListener('click', () => {
//         this.closeModal()
//       })
//     }

//     const modalSave = document.getElementById('modal-save')
//     if (modalSave) {
//       modalSave.addEventListener('click', () => {
//         this.savePDF()
//       })
//     }

//     const modalPrint = document.getElementById('modal-print')
//     if (modalPrint) {
//       modalPrint.addEventListener('click', () => {
//         this.printLabels()
//       })
//     }
//   }

//   updateLabelColor(color) {
//     // Encontrar elementos pela classe ou outros atributos
//     const topSections = document.querySelectorAll('[data-label-top]')
//     const logoBorders = document.querySelectorAll('[data-logo-border]')
    
//     topSections.forEach(section => {
//       section.style.backgroundColor = color
//       section.style.borderColor = color
//     })
    
//     logoBorders.forEach(border => {
//       border.style.borderColor = color
//     })
//   }

//   loadProducts() {
//     // Produtos de exemplo
//     const products = [
//       { id: 1, name: 'Blusa Cropped - P / Azul', size: 'P', color: 'Azul', code: '123456', price: 'R$ 79,90' },
//       { id: 2, name: 'Calça Jeans - M / Preto', size: 'M', color: 'Preto', code: '123457', price: 'R$ 129,90' },
//       { id: 3, name: 'Vestido - G / Vermelho', size: 'G', color: 'Vermelho', code: '123458', price: 'R$ 159,90' }
//     ]

//     const select = document.getElementById('product-select')
//     if (select && select.options.length <= 1) {
//       products.forEach(product => {
//         const option = new Option(product.name, product.id)
//         select.add(option)
//       })
//     }
//   }

//   updateProductDetails(productId) {
//     const detailsDiv = document.getElementById('product-details')
//     const products = {
//       1: { size: 'P', color: 'Azul', code: '123456', price: 'R$ 79,90', name: 'Blusa Cropped - P / Azul' },
//       2: { size: 'M', color: 'Preto', code: '123457', price: 'R$ 129,90', name: 'Calça Jeans - M / Preto' },
//       3: { size: 'G', color: 'Vermelho', code: '123458', price: 'R$ 159,90', name: 'Vestido - G / Vermelho' }
//     }

//     if (productId && products[productId]) {
//       const product = products[productId]
      
//       // Atualizar detalhes do produto
//       const sizeElement = document.getElementById('product-size')
//       const colorElement = document.getElementById('product-color')
//       const codeElement = document.getElementById('product-code')
//       const priceElement = document.getElementById('product-price')
      
//       if (sizeElement) sizeElement.textContent = product.size
//       if (colorElement) colorElement.textContent = product.color
//       if (codeElement) codeElement.textContent = product.code
//       if (priceElement) priceElement.textContent = product.price
      
//       // Atualizar preview
//       const namePreview = document.getElementById('preview-product-name')
//       const codePreview = document.getElementById('preview-product-code')
//       const pricePreview = document.getElementById('preview-product-price')
      
//       if (namePreview) namePreview.textContent = product.name
//       if (codePreview) codePreview.textContent = `Código: ${product.code}`
//       if (pricePreview) pricePreview.textContent = `Preço: ${product.price}`
      
//       if (detailsDiv) detailsDiv.classList.remove('hidden')
//     } else {
//       if (detailsDiv) detailsDiv.classList.add('hidden')
//     }
//   }

//   clearForm() {
//     const form = document.getElementById('label-form')
//     if (form) {
//       form.reset()
//     }
    
//     const detailsDiv = document.getElementById('product-details')
//     if (detailsDiv) {
//       detailsDiv.classList.add('hidden')
//     }
    
//     this.updateLabelColor('#4E4E4E')
    
//     // Resetar preview
//     const namePreview = document.getElementById('preview-product-name')
//     const codePreview = document.getElementById('preview-product-code')
//     const pricePreview = document.getElementById('preview-product-price')
    
//     if (namePreview) namePreview.textContent = 'Blusa Cropped - P / Azul'
//     if (codePreview) codePreview.textContent = 'Código: 123456'
//     if (pricePreview) pricePreview.textContent = 'Preço: R$ 79,90'
//   }

//   generateLabels() {
//     // Mostrar modal de preview
//     const modal = document.getElementById('pdf-modal')
//     if (modal) {
//       modal.classList.remove('hidden')
//       this.generatePDFPreview()
//     }
//   }

//   closeModal() {
//     const modal = document.getElementById('pdf-modal')
//     if (modal) {
//       modal.classList.add('hidden')
//     }
//   }

//   generatePDFPreview() {
//     const preview = document.getElementById('pdf-preview')
//     if (preview) {
//       preview.innerHTML = `
//         <div class="text-center p-4">
//           <p class="text-gray-600 mb-4">Folha ofício com etiquetas organizadas</p>
//           <div class="grid grid-cols-3 gap-4 mx-auto max-w-md">
//             ${Array(6).fill().map(() => `
//               <div class="border border-gray-300 p-2 bg-white rounded text-xs">
//                 <div class="font-bold">Etiqueta</div>
//                 <div>Preview</div>
//               </div>
//             `).join('')}
//           </div>
//           <p class="text-sm text-gray-500 mt-4">PDF pronto para salvar ou imprimir</p>
//         </div>
//       `
//     }
//   }

//   savePDF() {
//     alert('Funcionalidade de salvar PDF será implementada')
//     this.closeModal()
//   }

//   printLabels() {
//     window.print()
//     this.closeModal()
//   }
// }