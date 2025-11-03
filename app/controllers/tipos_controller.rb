class TiposController < ApplicationController
  before_action :set_tipo, only: [:show, :edit, :update, :destroy]

  def index
    @tipos = Tipo.where(contratante_id: current_user.contratante_id).order(:tip_nome)
  end

  def new
    @tipo = Tipo.new
  end

  def create
    @tipo = Tipo.new(tipo_params)
    @tipo.contratante_id = current_user.contratante_id # Define o contratante do usuário logado

    if @tipo.save
      redirect_to tipos_path, notice: 'Tipo criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @tipo.update(tipo_params)
      redirect_to tipos_path, notice: 'Tipo atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @tipo.produtos.any?
      redirect_to tipos_path, alert: 'Não é possível excluir o tipo pois existem produtos vinculados.'
    else
      @tipo.destroy
      redirect_to tipos_path, notice: 'Tipo excluído com sucesso!'
    end
  end

  private

  def set_tipo
    @tipo = Tipo.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def tipo_params
    params.require(:tipo).permit(:tip_nome, :tip_sigla)
  end
end