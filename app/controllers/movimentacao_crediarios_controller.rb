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

    if @mov.save
      @ficha.atualizar_status!
      respond_to do |format|
        format.html { redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id), notice: "Movimentação registrada!" }
        format.js { head :ok }
      end
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  def update
    if @mov.update(mov_params)
      @ficha.atualizar_status!
      respond_to do |format|
        format.html { redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id), notice: "Movimentação atualizada." }
        format.js { head :ok }  # <-- garante que JS Ajax funcione
      end
    else
      render :edit, layout: false, status: :unprocessable_entity
    end
  end

  def destroy
    @mov.destroy
    @ficha.atualizar_status!
    respond_to do |format|
      format.html { redirect_to movimentacao_crediarios_path(ficha_crediario_id: @ficha.id), notice: "Movimentação excluída." }
      format.js { head :ok }
      format.json { head :no_content }
    end
  end

  private

  def set_ficha
    @ficha = FichaCrediario.find(params[:ficha_crediario_id] || @mov&.ficha_crediario_id)
  end

  def set_mov
    @mov = @ficha.movimentacao_crediarios.find(params[:id])
  end

  def mov_params
    params.require(:movimentacao_crediario).permit(:mov_tipo, :mov_valor, :mov_observacao)
  end
end
