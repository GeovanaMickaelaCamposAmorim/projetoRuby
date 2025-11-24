class TamanhosController < ApplicationController
  before_action :set_tamanho, only: [ :show, :edit, :update, :destroy ]

  def index
    @tamanhos = Tamanho.where(contratante_id: current_user.contratante_id).order(:tam_nome)
  end

  def new
    @tamanho = Tamanho.new
    render layout: false
  end

  def create
    @tamanho = Tamanho.new(tamanho_params)
    @tamanho.contratante_id = current_user.contratante_id

    if @tamanho.save
      redirect_to tamanhos_path, notice: "Tamanho criado com sucesso!"
    else
        render :new, layout: false, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    render layout: false
  end

  def update
    if @tamanho.update(tamanho_params)
      redirect_to tamanhos_path, notice: "Tamanho atualizado com sucesso!"
    else
      render :edit, layout: false, status: :unprocessable_entity
    end
  end

  def destroy
    if @tamanho.produtos.any?
      redirect_to tamanhos_path, alert: "Não é possível excluir o tamanho pois existem produtos vinculados."
    else
      @tamanho.destroy
      redirect_to tamanhos_path, notice: "Tamanho excluído com sucesso!"
    end
  end

  private

  def set_tamanho
    @tamanho = Tamanho.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def tamanho_params
    params.require(:tamanho).permit(:tam_nome)
  end
end
