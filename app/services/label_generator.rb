class LabelGenerator
  def initialize(labels_data, quantity = 1)
    @labels_data = labels_data
    @quantity = quantity
    
    puts "🔴 [LABEL GENERATOR] INICIALIZADO:"
    puts "   Dados: #{@labels_data.inspect}"
    puts "   Quantidade: #{@quantity}"
  end

  def generate_pdf
    puts "🔴 [LABEL GENERATOR] GERANDO PDF..."
    
    begin
      pdf = Prawn::Document.new(
        page_size: "A4",
        margin: [20, 20],
        info: {
          Title: "Etiquetas de Produtos", 
          Author: "Sistema TAGS"
        }
      ) do |pdf|
        puts "🟢 [LABEL GENERATOR] DOCUMENTO PRAWN CRIADO COM SUCESSO"
        
        setup_fonts(pdf)
        puts "🟢 [LABEL GENERATOR] FONTES CONFIGURADAS"
        
        generate_labels(pdf)
        puts "🟢 [LABEL GENERATOR] ETIQUETAS GERADAS"
      end
      
      puts "🟢 [LABEL GENERATOR] PDF FINALIZADO"
      puts "📊 TAMANHO DO PDF: #{pdf.render.bytesize} bytes"
      
      # Verificar se o PDF tem conteúdo
      if pdf.render.bytesize < 1000
        puts "🔴 [LABEL GENERATOR] ALERTA: PDF muito pequeno, possivelmente vazio!"
      end
      
      return pdf
      
    rescue => e
      puts "🔴 [LABEL GENERATOR] ERRO DURANTE GERAÇÃO: #{e.message}"
      puts "BACKTRACE:"
      e.backtrace.first(10).each { |line| puts "   #{line}" }
      raise
    end
  end

  private

  def setup_fonts(pdf)
    puts "🔴 [LABEL GENERATOR] CONFIGURANDO FONTES..."
    pdf.font "Helvetica"
    puts "🟢 [LABEL GENERATOR] FONTE HELVETICA CONFIGURADA"
  end

  def generate_labels(pdf)
    puts "🔴 [LABEL GENERATOR] GERANDO ETIQUETAS..."
    labels_printed = 0
    
    while labels_printed < @quantity
      if labels_printed > 0
        puts "🔴 [LABEL GENERATOR] NOVA PÁGINA"
        pdf.start_new_page 
      end
      
      puts "🔴 [LABEL GENERATOR] GERANDO GRID DA PÁGINA..."
      generate_page_grid(pdf, labels_printed)
      labels_printed += 8
    end
    
    puts "🟢 [LABEL GENERATOR] TOTAL DE ETIQUETAS IMPRESSAS: #{labels_printed}"
  end

  def generate_page_grid(pdf, start_index)
    puts "🔴 [LABEL GENERATOR] GERANDO GRID - START INDEX: #{start_index}"
    
    label_width = 140
    label_height = 190
    margin_x = 25
    margin_y = 30
    
    labels_generated = 0
    
    2.times do |row|
      4.times do |col|
        label_index = start_index + (row * 4) + col
        break if label_index >= @quantity
        
        x = margin_x + (col * (label_width + 10))
        y = pdf.bounds.top - margin_y - (row * (label_height + 10))
        
        puts "🔴 [LABEL GENERATOR] CRIANDO ETIQUETA #{label_index + 1} em (#{row}, #{col})"
        
        pdf.bounding_box([x, y], width: label_width, height: label_height) do
          draw_single_label(pdf, label_index + 1)
        end
        
        labels_generated += 1
      end
    end
    
    puts "🟢 [LABEL GENERATOR] GRID GERADO: #{labels_generated} etiquetas"
  end

  def draw_single_label(pdf, label_number)
    puts "🔴 [LABEL GENERATOR] DESENHANDO ETIQUETA #{label_number}"
    
    label_data = @labels_data
    
    # Borda da etiqueta
    puts "🔴 [LABEL GENERATOR] DESENHANDO BORDA"
    pdf.stroke_bounds
    pdf.line_width 0.5
    
    # ========== PARTE SUPERIOR COLORIDA ==========
    top_height = 48
    label_color = label_data[:label_color] || "#4E4E4E"
    
    puts "🔴 [LABEL GENERATOR] PARTE SUPERIOR - Cor: #{label_color}"
    pdf.fill_color hex_to_rgb(label_color)
    pdf.fill_rectangle([0, pdf.bounds.height], pdf.bounds.width, top_height)
    pdf.fill_color "000000"
    
    # ========== FURINHO DA ETIQUETA ==========
    puts "🔴 [LABEL GENERATOR] DESENHANDO FURINHO"
    pdf.fill_color "FFFFFF"
    pdf.fill_circle([pdf.bounds.width / 2, pdf.bounds.height - 24], 6)
    pdf.stroke_circle([pdf.bounds.width / 2, pdf.bounds.height - 24], 6)
    pdf.fill_color "000000"
    
    # ========== LOGO CENTRAL ==========
    puts "🔴 [LABEL GENERATOR] DESENHANDO LOGO"
    pdf.fill_color "FFFFFF"
    pdf.stroke_color hex_to_rgb(label_color)
    pdf.line_width 2
    pdf.fill_and_stroke_circle([pdf.bounds.width / 2, pdf.bounds.height - 60], 20)
    pdf.stroke_color "000000"
    pdf.line_width 0.5
    pdf.fill_color "000000"
    
    # ========== CONTEÚDO DA ETIQUETA ==========
    content_top = pdf.bounds.height - top_height - 45
    
    puts "🔴 [LABEL GENERATOR] ADICIONANDO CONTEÚDO TEXTUAL"
    pdf.bounding_box([10, content_top], width: pdf.bounds.width - 20, height: 100) do
      # Nome do produto
      puts "🔴 [LABEL GENERATOR] ADICIONANDO NOME: #{label_data[:product_name]}"
      pdf.text label_data[:product_name].to_s, 
               size: 11, 
               style: :bold, 
               align: :center,
               overflow: :shrink_to_fit
      
      pdf.move_down 6
      
      # Marca, Tamanho e Cor
      details_text = "#{label_data[:brand]} - #{label_data[:size]} / #{label_data[:color]}"
      puts "🔴 [LABEL GENERATOR] ADICIONANDO DETALHES: #{details_text}"
      pdf.text details_text, 
               size: 9, 
               align: :center
      
      pdf.move_down 4
      
      # Código
      puts "🔴 [LABEL GENERATOR] ADICIONANDO CÓDIGO: #{label_data[:code]}"
      pdf.text label_data[:code].to_s, 
               size: 8, 
               align: :center,
               color: "666666"
      
      pdf.move_down 8
      
      # Preço
      puts "🔴 [LABEL GENERATOR] ADICIONANDO PREÇO: #{label_data[:price]}"
      pdf.text label_data[:price].to_s, 
               size: 14, 
               style: :bold, 
               align: :center
      
      pdf.move_down 10
      
      # Contatos
      puts "🔴 [LABEL GENERATOR] ADICIONANDO TELEFONE: #{label_data[:phone]}"
      pdf.text label_data[:phone].to_s, 
               size: 8, 
               align: :center,
               style: :bold
      
      pdf.move_down 3
      
      # Redes sociais
      social_text = "#{label_data[:instagram]}  #{label_data[:facebook]}"
      puts "🔴 [LABEL GENERATOR] ADICIONANDO REDES SOCIAIS: #{social_text}"
      pdf.text social_text, 
               size: 8, 
               align: :center
    end
    
    # Número da etiqueta
    puts "🔴 [LABEL GENERATOR] ADICIONANDO NÚMERO: #{label_number}"
    pdf.bounding_box([pdf.bounds.width - 20, 10], width: 15, height: 8) do
      pdf.text label_number.to_s, 
               size: 7, 
               align: :right,
               color: "999999"
    end
    
    puts "🟢 [LABEL GENERATOR] ETIQUETA #{label_number} FINALIZADA"
  end

  def hex_to_rgb(hex_color)
    hex_color = hex_color.gsub('#', '')
    case hex_color.length
    when 3
      r = hex_color[0].to_i(16) * 17
      g = hex_color[1].to_i(16) * 17
      b = hex_color[2].to_i(16) * 17
    when 6
      r = hex_color[0..1].to_i(16)
      g = hex_color[2..3].to_i(16)
      b = hex_color[4..5].to_i(16)
    else
      return [78, 78, 78]
    end
    [r, g, b]
  end
end