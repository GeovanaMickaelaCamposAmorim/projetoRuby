class MovimentacaoCrediariosController < ApplicationController
  before_action :set_movimentacao_crediario, only: %i[ show edit update destroy ]

  # GET /movimentacao_crediarios or /movimentacao_crediarios.json
  def index
    @movimentacao_crediarios = MovimentacaoCrediario.all
  end

  # GET /movimentacao_crediarios/1 or /movimentacao_crediarios/1.json
  def show
  end

  # GET /movimentacao_crediarios/new
  def new
    @movimentacao_crediario = MovimentacaoCrediario.new
  end

  # GET /movimentacao_crediarios/1/edit
  def edit
  end

  # POST /movimentacao_crediarios or /movimentacao_crediarios.json
  def create
    @movimentacao_crediario = MovimentacaoCrediario.new(movimentacao_crediario_params)

    respond_to do |format|
      if @movimentacao_crediario.save
        format.html { redirect_to @movimentacao_crediario, notice: "Movimentacao crediario was successfully created." }
        format.json { render :show, status: :created, location: @movimentacao_crediario }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movimentacao_crediario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movimentacao_crediarios/1 or /movimentacao_crediarios/1.json
  def update
    respond_to do |format|
      if @movimentacao_crediario.update(movimentacao_crediario_params)
        format.html { redirect_to @movimentacao_crediario, notice: "Movimentacao crediario was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @movimentacao_crediario }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movimentacao_crediario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movimentacao_crediarios/1 or /movimentacao_crediarios/1.json
  def destroy
    @movimentacao_crediario.destroy!

    respond_to do |format|
      format.html { redirect_to movimentacao_crediarios_path, notice: "Movimentacao crediario was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimentacao_crediario
      @movimentacao_crediario = MovimentacaoCrediario.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movimentacao_crediario_params
      params.expect(movimentacao_crediario: [ :ficha_crediario_id, :mov_tipo, :mov_valor, :mov_observacao ])
    end
end
