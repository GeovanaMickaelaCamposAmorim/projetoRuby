# app/controllers/produtos_controller.rb
class ProdutosController < ApplicationController
  before_action :set_produto, only: [:edit, :update, :destroy]
  before_action :carregar_dependencias, only: [:index, :new, :edit, :create, :update]

  def index
    @produtos = Produto.where(contratante_id: current_user.contratante_id)
                       .includes(:tipo, :marca, :tamanho)
                       .order(:pro_nome)

    if params[:search].present?
      termo = "%#{params[:search]}%"
      @produtos = @produtos.where("pro_nome ILIKE :termo OR pro_codigo ILIKE :termo OR pro_descricao ILIKE :termo", termo: termo)
    end
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

  def edit; end

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

  # ✅ MÉTODO DE BUSCA USADO PELO PDV
  def buscar
    termo = params[:q].to_s.strip
    produtos = Produto.where(contratante_id: current_user.contratante_id)
                      .where("pro_nome ILIKE :termo OR pro_codigo ILIKE :termo", termo: "%#{termo}%")
                      .limit(10)

    render json: produtos.map { |p|
      {
        id: p.id,
        nome: p.pro_nome,
        codigo: p.pro_codigo,
        valor_venda: p.pro_valor_venda,
        estoque: p.pro_quantidade
      }
    }
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