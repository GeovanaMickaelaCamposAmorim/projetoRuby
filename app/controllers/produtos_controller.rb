class ProdutosController < ApplicationController
  before_action :set_produto, only: [ :edit, :update, :destroy ]
  before_action :carregar_dependencias, only: [ :index, :new, :edit, :create, :update ]

  def index
    @produtos = Produto.where(contratante_id: current_user.contratante_id)
                       .includes(:tipo, :marca, :tamanho)
                       .order(:pro_nome)
  end

  def new
    @produto = Produto.new
    render layout: false  # SEMPRE sem layout para o modal
  end

  def edit
    render layout: false  # SEMPRE sem layout para o modal
  end

  def create
    @produto = Produto.new(produto_params)
    @produto.contratante_id = current_user.contratante_id
    if @produto.save
      redirect_to produtos_path, notice: "Produto criado com sucesso!"
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  def update
    if @produto.update(produto_params)
      redirect_to produtos_path, notice: "Produto atualizado com sucesso!"
    else
      render :edit, layout: false, status: :unprocessable_entity
    end
  end

  def destroy
    @produto.destroy
    redirect_to produtos_path, notice: "Produto excluído com sucesso!"
  end

  def search
    query = params[:q]

    if query.present?
      produtos = Produto.where("pro_nome ILIKE ? OR pro_codigo ILIKE ?", "%#{query}%", "%#{query}%")
                      .where("pro_quantidade > 0")
                      .where(contratante_id: current_user.contratante_id)
                      .limit(10)
    else
      # Quando vazio, mostra alguns produtos disponíveis
      produtos = Produto.where("pro_quantidade > 0")
                      .where(contratante_id: current_user.contratante_id)
                      .order(:pro_nome)
                      .limit(8)
    end

    render json: produtos
  end

  private

  def set_produto
    @produto = Produto.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def produto_params
    params.require(:produto).permit(
      :pro_nome, :pro_descricao, :pro_codigo, :pro_cor,
      :pro_valor_venda, :pro_valor_custo, :pro_quantidade,
      :pro_status, :pro_status_estoque, :pro_estoque_minimo,
      :tipo_id, :marca_id, :tamanho_id
    )
  end

  def carregar_dependencias
    @tipos = Tipo.where(contratante_id: current_user.contratante_id).order(:tip_nome)
    @marcas = Marca.where(contratante_id: current_user.contratante_id).order(:nome)
    @tamanhos = Tamanho.where(contratante_id: current_user.contratante_id).order(:tam_nome)
  end
end
