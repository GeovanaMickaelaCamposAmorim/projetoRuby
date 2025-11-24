class MarcasController < ApplicationController
  before_action :set_marca, only: [ :show, :edit, :update, :destroy ]

  def index
    @marcas = Marca.where(contratante_id: current_user.contratante_id).order(:nome)
  end

  def new
    @marca = Marca.new
    render layout: false  # ← MESMO dos produtos
  end

  def create
    @marca = Marca.new(marca_params)
    @marca.contratante_id = current_user.contratante_id

    if @marca.save
      redirect_to marcas_path, notice: "Marca criada com sucesso!"
    else
      render :new, layout: false, status: :unprocessable_entity  # ← MESMO dos produtos
    end
  end

  def show
    @produtos = @marca.produtos if @marca.produtos.any?
  end

  def edit
    render layout: false  # ← MESMO dos produtos
  end

  def update
    if @marca.update(marca_params)
      redirect_to marcas_path, notice: "Marca atualizada com sucesso!"
    else
      render :edit, layout: false, status: :unprocessable_entity  # ← MESMO dos produtos
    end
  end

  def destroy
    if @marca.produtos.any?
      redirect_to marcas_path, alert: "Não é possível excluir a marca pois existem produtos vinculados."
    else
      @marca.destroy
      redirect_to marcas_path, notice: "Marca excluída com sucesso!"
    end
  end

  private

  def set_marca
    @marca = Marca.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def marca_params
    params.require(:marca).permit(:nome, :descricao)
  end
end
