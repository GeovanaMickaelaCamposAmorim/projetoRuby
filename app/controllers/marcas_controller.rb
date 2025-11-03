class MarcasController < ApplicationController
  before_action :set_marca, only: [:show, :edit, :update, :destroy]

  def index
    @marcas = Marca.where(contratante_id: current_user.contratante_id).order(:mar_nome)
  end

  def new
    @marca = Marca.new
  end

  def create
    @marca = Marca.new(marca_params)
    @marca.contratante_id = current_user.contratante_id # Define o contratante do usuário logado

    if @marca.save
      redirect_to marcas_path, notice: 'Marca criada com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @marca.update(marca_params)
      redirect_to marcas_path, notice: 'Marca atualizada com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @marca.produtos.any?
      redirect_to marcas_path, alert: 'Não é possível excluir a marca pois existem produtos vinculados.'
    else
      @marca.destroy
      redirect_to marcas_path, notice: 'Marca excluída com sucesso!'
    end
  end

  private

  def set_marca
    @marca = Marca.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def marca_params
    params.require(:marca).permit(:mar_nome, :mar_sigla)
  end
end