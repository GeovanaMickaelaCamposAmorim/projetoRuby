class ProdutosController < ApplicationController
  before_action :set_produto, only: [ :edit, :update, :destroy ]
  before_action :carregar_dependencias, only: [ :index, :new, :edit, :create, :update ]

  def index
    @produtos = Produto.where(contratante_id: current_user.contratante_id)
                       .includes(:tipo, :marca, :tamanho)
                       .order(:pro_nome)

    # Aplicar filtros
    @produtos = @produtos.where("pro_nome ILIKE ? OR pro_descricao ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    @produtos = @produtos.where(tipo_id: params[:tipo_id]) if params[:tipo_id].present?
    @produtos = @produtos.where(marca_id: params[:marca_id]) if params[:marca_id].present?
    
    # Filtro por status de estoque
    if params[:estoque].present?
      case params[:estoque]
      when 'disponivel'
        @produtos = @produtos.where("pro_quantidade > 0")
      when 'esgotado'
        @produtos = @produtos.where("pro_quantidade <= 0")
      when 'baixo_estoque'
        @produtos = @produtos.where("pro_quantidade > 0 AND pro_quantidade <= pro_estoque_minimo")
      end
    end
  end

  def new
    @produto = Produto.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @produto = Produto.new(produto_params)
    @produto.contratante_id = current_user.contratante_id
    
    # Gera o código automaticamente antes de salvar
    if @produto.save
      # Atualiza o código após salvar (para ter o ID)
      @produto.update(pro_codigo: gerar_codigo_produto(@produto))
      
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
      :pro_status, :pro_estoque_minimo,
      :tipo_id, :marca_id, :tamanho_id, :pro_valor_promo
    )
  end

  def carregar_dependencias
    @tipos = Tipo.where(contratante_id: current_user.contratante_id).order(:tip_nome)
    @marcas = Marca.where(contratante_id: current_user.contratante_id).order(:nome)
    @tamanhos = Tamanho.where(contratante_id: current_user.contratante_id).order(:tam_nome)
  end

  def gerar_codigo_produto(produto)
    # Gera o código no formato: SIGLA - MARCA - COR - TAMANHO - ID
    sigla = produto.tipo&.tip_sigla || 'GEN'
    marca = produto.marca&.nome&.upcase&.gsub(/\s+/, '')&.first(4) || 'MARCA'
    cor = produto.pro_cor&.upcase&.first(4) || 'COR'
    tamanho = produto.tamanho&.tam_nome&.upcase || 'TAM'
    id_formatado = produto.id.to_s.rjust(3, '0')
    
    "#{sigla} - #{marca} - #{cor} - #{tamanho} - #{id_formatado}"
  end
end