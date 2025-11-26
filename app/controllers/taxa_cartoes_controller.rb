class TaxaCartoesController < ApplicationController
  before_action :set_taxa_cartao, only: [:edit, :update, :destroy]

  def index
    @taxa_cartoes = TaxaCartao.where(contratante_id: current_user.contratante_id).order(:txc_tipo)

    render :index
  end

  def new
    @taxa_cartao = TaxaCartao.new
    render layout: false
  end

  def create
    @taxa_cartao = TaxaCartao.new(taxa_cartao_params)
    @taxa_cartao.contratante_id = current_user.contratante_id

    respond_to do |format|
      if @taxa_cartao.save
        format.html { redirect_to taxa_cartoes_path, notice: "Taxa de cartão criada com sucesso!" }
        format.json { render json: { success: true, redirect_url: taxa_cartoes_path } }
      else
        format.html { render :new, layout: false, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @taxa_cartao.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    respond_to do |format|
      if @taxa_cartao.update(taxa_cartao_params)
        format.html { redirect_to taxa_cartoes_path, notice: "Taxa de cartão atualizada com sucesso!" }
        format.json { render json: { success: true, redirect_url: taxa_cartoes_path } }
      else
        format.html { render :edit, layout: false, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @taxa_cartao.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @taxa_cartao.destroy
    redirect_to taxa_cartoes_path, notice: "Taxa de cartão excluída com sucesso!"
  end

  private

  def set_taxa_cartao
    @taxa_cartao = TaxaCartao.do_contratante(current_user.contratante_id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to taxa_cartoes_path, alert: "Taxa de cartão não encontrada."
  end

  def taxa_cartao_params
    params.require(:taxa_cartao).permit(:txc_tipo, :txc_descricao, :txc_porcentagem)
  end
end