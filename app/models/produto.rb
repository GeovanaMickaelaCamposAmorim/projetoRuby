class Produto < ApplicationRecord
  belongs_to :tipo
  belongs_to :marca
  belongs_to :tamanho
  belongs_to :contratante
  has_many :venda_itens
  has_many :estoque_movimentacoes

  validates :pro_valor_venda, :pro_quantidade, :tipo_id, :marca_id, 
            :tamanho_id, :contratante_id, presence: true
  validates :pro_valor_venda, numericality: { greater_than: 0 }
   validates :pro_quantidade, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :pro_estoque_minimo, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pro_valor_promo, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :atualizar_status_estoque_automaticamente
  after_create :gerar_codigo_automatico

  def valor_atual
    pro_valor_promo.present? && pro_valor_promo > 0 ? pro_valor_promo : pro_valor_venda
  end

  def em_promocao?
    pro_valor_promo.present? && pro_valor_promo > 0
  end
  
 def gerar_codigo_automatico
    return if pro_codigo.present? # Não regera se já existe
    
    sigla = tipo&.tip_sigla || 'GEN'
    marca_nome = marca&.nome || 'MARCA'
    marca_abrev = marca_nome.gsub(/\s+/, '').upcase.first(4)
    cor_abrev = pro_cor.present? ? pro_cor.upcase.first(4) : 'COR'
    tamanho_abrev = tamanho&.tam_nome&.upcase || 'TAM'
    id_formatado = id.to_s.rjust(3, '0')
    
    novo_codigo = "#{sigla} - #{marca_abrev} - #{cor_abrev} - #{tamanho_abrev} - #{id_formatado}"
    
    update_column(:pro_codigo, novo_codigo)
  end


  def status_estoque_automatico
    return 'esgotado' if pro_quantidade.to_i <= 0
    return 'baixo_estoque' if pro_quantidade.to_i <= pro_estoque_minimo.to_i
    'disponivel'
  end

  def disponivel?
    status_estoque_automatico == 'disponivel'
  end

  def baixo_estoque?
    status_estoque_automatico == 'baixo_estoque'
  end

  def esgotado?
    status_estoque_automatico == 'esgotado'
  end

  # Método para obter a classe CSS baseada no status
  def classe_status_estoque
    case status_estoque_automatico
    when 'disponivel' then 'bg-green-100 text-green-800'
    when 'baixo_estoque' then 'bg-yellow-100 text-yellow-800'
    when 'esgotado' then 'bg-red-100 text-red-800'
    else 'bg-gray-100 text-gray-800'
    end
  end

  # Método para obter o texto do status
  def texto_status_estoque
    case status_estoque_automatico
    when 'disponivel' then 'Disponível'
    when 'baixo_estoque' then 'Baixo Estoque'
    when 'esgotado' then 'Esgotado'
    else 'Indefinido'
    end
  end

  private

  def atualizar_status_estoque_automaticamente
    # Atualiza automaticamente o status baseado na quantidade
    self.pro_status_estoque = status_estoque_automatico
  end
end