class MovimentacaoCrediariosController < ApplicationController
  before_action :set_ficha

  def index
    @movs = @ficha.movimentacao_crediarios.order(created_at: :desc)
  end

  def new
    @mov = @ficha.movimentacao_crediarios.new
  end

  def create
    @mov = @ficha.movimentacao_crediarios.new(mov_params)
    @mov.user = current_user  # Preferível ao user_id=

    # Calcular valor líquido (taxa de cartão)
    if @mov.mov_tipo == "pagamento"
      taxa = current_contratante.taxa_cartoes.to_f
      @mov.mov_valor_real = @mov.mov_valor - (@mov.mov_valor * taxa / 100.0)
    else
      @mov.mov_valor_real = @mov.mov_valor
    end

    if @mov.save
      atualizar_ficha(@mov)
      redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id),
                  notice: "Movimentação registrada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def atualizar_ficha(mov)
    case mov.mov_tipo
    when "pagamento"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total - mov.mov_valor_real)
    when "juros"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total + mov.mov_valor)
    when "compra"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total + mov.mov_valor)
    when "devolucao"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total - mov.mov_valor)
    end

    # Atualizar status: concluída se zerado ou negativo
    @ficha.update(
      fic_status: @ficha.fic_valor_total > 0 ? "pendente" : "concluida"
    )
  end

  def set_ficha
    @ficha = FichaCrediario.find(params[:ficha_crediario_id])
  end

  def mov_params
    params.require(:movimentacao_crediario)
          .permit(:mov_tipo, :mov_valor, :mov_observacao)
  end
end
