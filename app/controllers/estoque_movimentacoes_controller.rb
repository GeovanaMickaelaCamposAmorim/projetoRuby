class EstoqueMovimentacoesController < ApplicationController
  before_action :set_movimentacao, only: [ :edit, :update, :destroy ]
  before_action :carregar_dados_form, only: [ :new, :edit ]

  def index
    @estoque_movimentacoes = EstoqueMovimentacao.all.order(emv_data: :desc)
    @usuarios = User.all
  end

  def new
    @movimentacao = EstoqueMovimentacao.new
    render layout: false
  end

  def create
    @movimentacao = EstoqueMovimentacao.new(estoque_movimentacao_params)
    @movimentacao.user_id ||= current_user.id
    @movimentacao.emv_data ||= Time.current

    if @movimentacao.save
      render js: "window.location.reload();" # ou redirect_to para tela completa
    else
      render :new, layout: false
    end
  end

  def edit
    render layout: false
  end

  def update
    if @movimentacao.update(estoque_movimentacao_params)
      render js: "window.location.reload();"
    else
      render :edit, layout: false
    end
  end

  def destroy
    @movimentacao.destroy
    redirect_to estoque_movimentacoes_path, notice: "Movimentação excluída."
  end

  private

  def set_movimentacao
    @movimentacao = EstoqueMovimentacao.find(params[:id])
  end

  def carregar_dados_form
    @produtos = Produto.all
    @clientes = Cliente.all
  end

  def estoque_movimentacao_params
    params.require(:estoque_movimentacao).permit(:produto_id, :quantidade, :emv_tipo, :valor_unitario, :valor_total, :cliente_id)
  end
end
