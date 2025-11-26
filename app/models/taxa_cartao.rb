class TaxaCartao < ApplicationRecord

   self.table_name = 'taxa_cartoes'  

  belongs_to :contratante
  
  
  # Tipos de pagamento permitidos
  TIPOS_PAGAMENTO = {
    pix: 'pix',
    debito: 'debito', 
    credito: 'credito',
    crediario: 'crediario'
  }.freeze

  # Validações
  validates :txc_tipo, presence: true, inclusion: { in: TIPOS_PAGAMENTO.values }
  validates :txc_porcentagem, numericality: { greater_than_or_equal_to: 0 }
  validates :contratante_id, presence: true



  def tipo_formatado
    case txc_tipo
    when 'pix' then 'PIX'
    when 'debito' then 'Débito'
    when 'credito' then 'Crédito'
    when 'crediario' then 'Crediário'
    else txc_tipo
    end
  end

  def porcentagem_formatada
    "#{txc_porcentagem}%"
  end
  
  def self.por_tipo(tipo)
    where(txc_tipo: tipo)
  end
end

class TaxaCartoesController < ApplicationController
  before_action :set_taxa_cartao, only: [:edit, :update, :destroy]

  def index
    @taxa_cartoes = TaxaCartao.where(contratante_id: current_user.contratante_id)
                              .order(:txc_tipo)
    render :index
      
  end

  def new
    @taxa_cartao = TaxaCartao.new
    render layout: false
  end

  def create
    @taxa_cartao = TaxaCartao.new(taxa_cartao_params)
    @taxa_cartao.contratante_id = current_user.contratante_id

    if @taxa_cartao.save
      redirect_to taxa_cartoes_path, notice: "Taxa de cartão criada com sucesso!"
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  def edit
    render layout: false
  end

  def update
    if @taxa_cartao.update(taxa_cartao_params)
      redirect_to taxa_cartoes_path, notice: "Taxa de cartão atualizada com sucesso!"
    else
      render :edit, layout: false, status: :unprocessable_entity
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

  def set_contratante_id
    @contratante_id = current_user.contratante_id
  end

  def taxa_cartao_params
    params.require(:taxa_cartao).permit(:txc_tipo, :txc_descricao, :txc_porcentagem)
  end
end