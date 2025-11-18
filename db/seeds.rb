puts "🌱 Iniciando seeds..."
puts "=" * 50

begin
  # ==========================================
  # 1. CONTRATANTE
  # ==========================================
  puts "📋 Criando Contratante..."
  
  contratante = Contratante.find_or_create_by!(cnt_cnpj: "33683848000108") do |cnt|
    cnt.cnt_nome_loja = "Minha Loja Exemplo"
    cnt.cnt_cnpj = "33683848000108"  # 14 dígitos sem formatação
    cnt.cnt_cep = "12345000"
    cnt.cnt_telefone = "11999999999"
    cnt.cnt_endereco = "Rua Exemplo, 123, São Paulo - SP"
    cnt.cnt_nome_responsavel = "Geovana Amorim"
    cnt.cnt_email_responsavel = "geovana@loja.com"
    cnt.cnt_senha_responsavel = "senha123"
    cnt.cnt_telefone_responsavel = "11999999999"
  end
  
  puts "✅ Contratante: #{contratante.cnt_nome_loja}"

  # ==========================================
  # 2. LOJA
  # ==========================================
  puts "📋 Criando Loja..."
  
  loja = Loja.find_or_create_by!(loj_cnpj: "33.683.848/0001-08") do |lj|
    lj.loj_nome = "Minha Loja Exemplo"
    lj.loj_cnpj = "33.683.848/0001-08"  # COM formatação
    lj.loj_telefone = "11999999999"
    lj.loj_cep = "12345000"
    lj.loj_endereco = "Rua Exemplo, 123, São Paulo - SP"
    lj.loj_cor_fundo = "#ffffff"
    lj.loj_cor_fonte = "#000000"
    lj.contratante = contratante
  end
  
  puts "✅ Loja: #{loja.loj_nome}"

  # ==========================================
  # 3. USUÁRIOS - ORDEM: VENDEDOR / ADMIN / MASTER
  # ==========================================
  puts "📋 Criando Usuários..."
  
  usuarios_data = [
    # VENDEDOR - @loja.com
    {
      tipo: "vendedor",
      email: "vendedor@loja.com", 
      nome: "Vendedor Exemplo",
      telefone: "(75) 97777-7777"
    },
    # ADMIN - @loja.com  
    {
      tipo: "admin", 
      email: "admin@loja.com",
      nome: "Administrador",
      telefone: "(75) 96666-6666"
    },
    # MASTER - @tags.com
    {
      tipo: "master",
      email: "master@tags.com",
      nome: "Master System",
      telefone: "(75) 95555-5555"
    }
  ]

  usuarios_data.each do |user_data|
    user = User.find_or_create_by!(usu_email: user_data[:email]) do |u|
      u.usu_nome = user_data[:nome]
      u.password = "senha123"
      u.usu_telefone = user_data[:telefone]
      u.usu_tipo = user_data[:tipo]
      u.usu_status = "ativo"
      u.contratante = contratante
    end
    puts "✅ Usuário #{user_data[:tipo].upcase}: #{user.usu_email}"
  end

  puts "💡 Credenciais de login:"
  puts "   Vendedor: vendedor@loja.com / senha123"
  puts "   Admin: admin@loja.com / senha123" 
  puts "   Master: master@tags.com / senha123"

  # ==========================================
  # 4. CONFIGURAÇÕES DE ETIQUETAS
  # ==========================================
  puts "📋 Configurando Etiquetas..."
  
  # LabelConfig
  label_config = LabelConfig.find_or_create_by!(name: "Configuração Padrão") do |config|
    config.color = "#4E4E4E"
    config.is_default = true
  end
  puts "✅ LabelConfig: #{label_config.name}"

  # TagTemplate  
  tag_template = TagTemplate.find_or_create_by!(name: "Etiqueta Exemplo") do |template|
    template.color = "#4E4E4E"
    template.store_name = "Minha Loja"
  end
  puts "✅ TagTemplate: #{tag_template.name}"

  # ==========================================
  # 5. CONFIGURAÇÕES DO SISTEMA
  # ==========================================
  puts "📋 Configurando Sistema..."
  
  # Configuracoes (se existir o model)
  if defined?(Configuracao)
    configuracao = Configuracao.find_or_create_by!(id: 1) do |config|
      config.nome_loja = "Minha Loja Exemplo"
      config.cor_fundo_menu = "#181818"
      config.cor_fonte_menu = "#f9fafb"
    end
    puts "✅ Configurações do sistema criadas"
  end

  puts "=" * 50
  puts "🎉 Seeds concluídos com sucesso!"
  puts ""
  puts "📊 Resumo:"
  puts "   • 1 Contratante"
  puts "   • 1 Loja" 
  puts "   • 3 Usuários (vendedor, admin, master)"
  puts "   • Configurações de etiquetas"
  puts ""
  puts "🚀 Sistema pronto para uso!"

rescue => e
  puts "❌ ERRO durante seeds: #{e.message}"
  puts e.backtrace.first(5).join("\n")
end