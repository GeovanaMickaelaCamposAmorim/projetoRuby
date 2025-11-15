# Criação do Contratante (mantém sem formatação)
contratante = Contratante.create!(
  cnt_nome_loja: "Minha Loja Exemplo",
  cnt_cnpj: "33683848000108",  # 14 dígitos sem formatação
  cnt_cep: "12345000",
  cnt_telefone: "11999999999",
  cnt_endereco: "Rua Exemplo, 123, São Paulo - SP",
  cnt_nome_responsavel: "Geovana Amorim",
  cnt_email_responsavel: "geovana@loja.com",
  cnt_senha_responsavel: "senha123",
  cnt_telefone_responsavel: "11999999999"
)

puts "✅ Contratante criado: #{contratante.cnt_nome_loja}"

# Criação da Loja (usa CNPJ formatado)
loja = Loja.create!(
  loj_nome: "Minha Loja Exemplo",
  loj_cnpj: "33.683.848/0001-08",  # COM formatação: XX.XXX.XXX/XXXX-XX
  loj_telefone: "11999999999",
  loj_cep: "12345000",
  loj_endereco: "Rua Exemplo, 123, São Paulo - SP",
  loj_cor_fundo: "#ffffff",
  loj_cor_fonte: "#000000",
  contratante: contratante
)

puts "✅ Loja criada: #{loja.loj_nome}"

# Se quiser adicionar logo (ActiveStorage), descomente e ajuste o caminho
# loja.loja_logo.attach(
#   io: File.open("path/para/tags_logo.png"),
#   filename: "tags_logo.png",
#   content_type: "image/png"
# )

# Criação do Usuário Admin
admin = User.create!(
  usu_nome: "Admin",
  usu_email: "admin3@tags.com",
  password: "senha123",
  password_confirmation: "senha123",
  usu_telefone: "11999999999",
  usu_tipo: "admin",
  usu_status: "ativo",
  contratante: contratante
)

puts "✅ Usuário Admin criado: #{admin.usu_email}"
puts "💡 Use email: admin@tags.com | senha: senha123 para login"
