class ProdutosController < ApplicationController
  before_action :set_produto, only: [:show, :edit, :update, :destroy]

  def index
    @produtos = Produto.where(contratante_id: current_user.contratante_id)
                       .includes(:tipo, :marca, :tamanho)
  end

  def new
    @produto = Produto.new
    carregar_dependencias
  end

  def create
    @produto = Produto.new(produto_params)
    @produto.contratante_id = current_user.contratante_id
    
    if @produto.save
      redirect_to produtos_path, notice: 'Produto criado com sucesso!'
    else
      carregar_dependencias
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    carregar_dependencias
  end

  def update
    if @produto.update(produto_params)
      redirect_to produtos_path, notice: 'Produto atualizado com sucesso!'
    else
      carregar_dependencias
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @produto.destroy
    redirect_to produtos_path, notice: 'Produto excluído com sucesso!'
  end

  private

  def set_produto
    @produto = Produto.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def produto_params
    params.require(:produto).permit(:tipo_id, :marca_id, :tamanho_id, :pro_cor, 
                                   :pro_valor_venda, :pro_valor_custo, :pro_quantidade,
                                   :pro_estoque_minimo, :pro_status, :pro_status_estoque)
  end

  def carregar_dependencias
    @tipos = Tipo.where(contratante_id: current_user.contratante_id)
    @marcas = Marca.where(contratante_id: current_user.contratante_id)
    @tamanhos = Tamanho.where(contratante_id: current_user.contratante_id)
  end
end