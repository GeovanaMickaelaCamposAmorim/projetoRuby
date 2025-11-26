class Contratante < ApplicationRecord
  # Relações
  has_one :loja, dependent: :destroy
  has_many :gastos, dependent: :destroy
  has_many :taxa_cartoes, dependent: :destroy
  has_one_attached :logo

  # Validações obrigatórias
  validates :cnt_nome_loja,
            :cnt_cnpj,
            :cnt_cep,
            :cnt_telefone,
            :cnt_endereco,
            :cnt_nome_responsavel,
            :cnt_email_responsavel,
            :cnt_senha_responsavel,
            :cnt_telefone_responsavel, presence: true

  validates :cnt_email_responsavel, format: { with: URI::MailTo::EMAIL_REGEXP, message: "deve ser um email válido" }
  validates :cnt_cnpj, format: { with: /\A\d{14}\z/, message: "deve conter 14 dígitos" }

  alias_attribute :nome_loja, :cnt_nome_loja
  alias_attribute :responsavel, :cnt_nome_responsavel
end
