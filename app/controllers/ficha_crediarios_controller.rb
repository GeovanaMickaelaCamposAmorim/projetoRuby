class FichaCrediariosController < ApplicationController
  before_action :set_ficha_crediario, only: [ :show, :edit, :update, :destroy ]

  def index
    # Filtros
    @ficha_crediarios = FichaCrediario.where(contratante_id: current_user.contratante_id).includes(:cliente)

    if params[:search].present?
      @ficha_crediarios = @ficha_crediarios.joins(:cliente).where("clientes.nome ILIKE ?", "%#{params[:search]}%")
    end

    if params[:status].present?
      @ficha_crediarios = @ficha_crediarios.where(fic_status: params[:status])
    end

    if params[:contratante_id].present?
      @ficha_crediarios = @ficha_crediarios.where(contratante_id: params[:contratante_id])
    end

    @ficha_crediarios = @ficha_crediarios.order(created_at: :desc)

    # Estatísticas para os cards
    @total_fichas = FichaCrediario.count
    @clientes_pendentes = FichaCrediario.where(fic_status: "pendente").count
    @valor_total_pagar = FichaCrediario.where(fic_status: "pendente").sum(:fic_valor_total)

    # Para o filtro de contratantes
    @contratantes = Contratante.all
  end

  def show
    @movimentacoes = @ficha_crediario.movimentacao_crediarios.order(created_at: :desc)
    @movimentacao = MovimentacaoCrediario.new(ficha_crediario: @ficha_crediario)
  end

  def new
  @ficha_crediario = FichaCrediario.new
  render partial: "form", locals: { ficha_crediario: @ficha_crediario }
  end

  def create
    @ficha_crediario = FichaCrediario.new(ficha_crediario_params)

    if @ficha_crediario.save
      redirect_to ficha_crediarios_path, notice: "Ficha criada com sucesso."
    else
      render :new
    end
  end

  def edit
  render partial: "form", locals: { ficha_crediario: @ficha_crediario }
  end

  def update
    if @ficha_crediario.update(ficha_crediario_params)
      redirect_to ficha_crediarios_path, notice: "Ficha atualizada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @ficha_crediario.destroy
    redirect_to ficha_crediarios_path, notice: "Ficha excluída com sucesso."
  end

  private

  def set_ficha_crediario
    @ficha_crediario = FichaCrediario.find(params[:id])
  end

  def ficha_crediario_params
    params.require(:ficha_crediario).permit(:cliente_id, :contratante_id, :fic_valor_total, :fic_status)
  end
end