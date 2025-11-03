class Contratante < ApplicationRecord
  # Relações
  has_one :loja, dependent: :destroy       # Quando o contratante for deletado, a loja também é deletada
  has_many :users, dependent: :destroy     # Todos os usuários ligados ao contratante
  has_many :marcas, dependent: :destroy
  has_many :gastos, dependent: :destroy

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

  # Validação de email
  validates :cnt_email_responsavel, format: { with: URI::MailTo::EMAIL_REGEXP, message: "deve ser um email válido" }

  # Sugestão: validação de CNPJ (simples, apenas dígitos)
  validates :cnt_cnpj, format: { with: /\A\d{14}\z/, message: "deve conter 14 dígitos" }

  # Alias para facilitar acesso
  alias_attribute :nome_loja, :cnt_nome_loja
  alias_attribute :responsavel, :cnt_nome_responsavel
end
