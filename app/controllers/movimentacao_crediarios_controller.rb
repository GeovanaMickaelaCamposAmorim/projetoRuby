class MovimentacaoCrediariosController < ApplicationController
  before_action :set_ficha
  before_action :set_mov, only: [ :edit, :update, :destroy ]

  def index
    @movs = @ficha.movimentacao_crediarios.order(created_at: :desc)
  end

  def new
    @mov = @ficha.movimentacao_crediarios.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @mov = @ficha.movimentacao_crediarios.new(mov_params)
    @mov.user = current_user
    calcular_valor_real(@mov)

    if @mov.save
      atualizar_ficha(@mov)
      respond_to do |format|
        format.html { redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id), notice: "Movimentação registrada!" }
        format.js { head :ok }
      end
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  def update
    @mov.assign_attributes(mov_params)
    calcular_valor_real(@mov)
    if @mov.save
      atualizar_ficha(@mov)
      redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id), notice: "Movimentação atualizada!"
    else
      render :edit, layout: false, status: :unprocessable_entity
    end
  end

  def destroy
  case @mov.mov_tipo
  when "pagamento"
    @ficha.update(fic_valor_total: @ficha.fic_valor_total + @mov.mov_valor_real)
  when "juros", "compra"
    @ficha.update(fic_valor_total: @ficha.fic_valor_total - @mov.mov_valor)
  when "devolucao"
    @ficha.update(fic_valor_total: @ficha.fic_valor_total + @mov.mov_valor)
  end

  @ficha.update(fic_status: @ficha.fic_valor_total > 0 ? "pendente" : "concluida")

  @mov.destroy

  respond_to do |format|
    format.html { redirect_to ficha_crediario_movimentacao_crediarios_path(@ficha), notice: "Movimentação excluída." }
    format.js
    format.json { head :no_content }
  end
  end





  private

  def set_ficha
    @ficha = FichaCrediario.find(params[:ficha_crediario_id])
  end

  def set_mov
    @mov = @ficha.movimentacao_crediarios.find(params[:id])
  end

  def mov_params
    params.require(:movimentacao_crediario).permit(:mov_tipo, :mov_valor, :mov_observacao)
  end

  def calcular_valor_real(mov)
    if mov.mov_tipo == "pagamento"
      taxa = current_contratante.taxa_cartoes.to_f
      mov.mov_valor_real = mov.mov_valor - (mov.mov_valor * taxa / 100.0)
    else
      mov.mov_valor_real = mov.mov_valor
    end
  end

  def atualizar_ficha(mov)
    case mov.mov_tipo
    when "pagamento"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total - mov.mov_valor_real)
    when "juros", "compra"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total + mov.mov_valor)
    when "devolucao"
      @ficha.update(fic_valor_total: @ficha.fic_valor_total - mov.mov_valor)
    end

    @ficha.update(fic_status: @ficha.fic_valor_total > 0 ? "pendente" : "concluida")
  end
end
