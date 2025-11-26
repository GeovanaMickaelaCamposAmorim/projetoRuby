class EstoqueMovimentacaosController < ApplicationController
  before_action :set_estoque_movimentacao, only: %i[ show edit update destroy ]

  # GET /estoque_movimentacaos or /estoque_movimentacaos.json
  def index
    @estoque_movimentacaos = EstoqueMovimentacao.all
  end

  # GET /estoque_movimentacaos/1 or /estoque_movimentacaos/1.json
  def show
  end

  # GET /estoque_movimentacaos/new
  def new
    @estoque_movimentacao = EstoqueMovimentacao.new
  end

  # GET /estoque_movimentacaos/1/edit
  def edit
  end

  # POST /estoque_movimentacaos or /estoque_movimentacaos.json
  def create
    @estoque_movimentacao = EstoqueMovimentacao.new(estoque_movimentacao_params)

    respond_to do |format|
      if @estoque_movimentacao.save
        format.html { redirect_to @estoque_movimentacao, notice: "Estoque movimentacao was successfully created." }
        format.json { render :show, status: :created, location: @estoque_movimentacao }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @estoque_movimentacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estoque_movimentacaos/1 or /estoque_movimentacaos/1.json
  def update
    respond_to do |format|
      if @estoque_movimentacao.update(estoque_movimentacao_params)
        format.html { redirect_to @estoque_movimentacao, notice: "Estoque movimentacao was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @estoque_movimentacao }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @estoque_movimentacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estoque_movimentacaos/1 or /estoque_movimentacaos/1.json
  def destroy
    @estoque_movimentacao.destroy!

    respond_to do |format|
      format.html { redirect_to estoque_movimentacaos_path, notice: "Estoque movimentacao was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estoque_movimentacao
      @estoque_movimentacao = EstoqueMovimentacao.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def estoque_movimentacao_params
      params.expect(estoque_movimentacao: [ :emv_data, :emv_tipo, :emv_quantidade, :emv_valor_total, :produto_id ])
    end
end
