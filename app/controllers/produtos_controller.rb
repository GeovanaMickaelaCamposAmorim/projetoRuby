class ProdutosController < ApplicationController
  before_action :set_produto, only: [:edit, :update, :destroy]
  before_action :carregar_dependencias, only: [:index, :new, :edit, :create, :update]

  def index
    @produtos = Produto.where(contratante_id: current_user.contratante_id)
                       .includes(:tipo, :marca, :tamanho)
    
    # Busca por nome, código ou descrição
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @produtos = @produtos.where("pro_nome ILIKE :search OR pro_codigo ILIKE :search OR pro_descricao ILIKE :search", search: search_term)
    end
    
    # Filtro por tipo
    if params[:tipo_id].present?
      @produtos = @produtos.where(tipo_id: params[:tipo_id])
    end
    
    # Filtro por marca
    if params[:marca_id].present?
      @produtos = @produtos.where(marca_id: params[:marca_id])
    end
    
    # Filtro por status de estoque
    if params[:estoque].present?
      case params[:estoque]
      when 'em_estoque'
        @produtos = @produtos.where("pro_quantidade > 0")
      when 'em_falta'
        @produtos = @produtos.where("pro_quantidade <= 0")
      end
    end
    
    @produtos = @produtos.order(:pro_nome)
  end

  def new
    @produto = Produto.new
  end

  def create
    @produto = Produto.new(produto_params)
    @produto.contratante_id = current_user.contratante_id
    
    if @produto.save
      redirect_to produtos_path, notice: 'Produto criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @produto.update(produto_params)
      redirect_to produtos_path, notice: 'Produto atualizado com sucesso!'
    else
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
                                   :pro_estoque_minimo, :pro_status, :pro_status_estoque,
                                   :pro_nome, :pro_descricao, :pro_codigo)
  end

  def carregar_dependencias
    @tipos = Tipo.where(contratante_id: current_user.contratante_id).order(:tip_nome)
    @marcas = Marca.where(contratante_id: current_user.contratante_id).order(:nome)
    @tamanhos = Tamanho.where(contratante_id: current_user.contratante_id).order(:tam_nome)
  end
end