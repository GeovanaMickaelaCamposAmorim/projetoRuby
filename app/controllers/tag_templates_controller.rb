class TagTemplatesController < ApplicationController
  def new
    @tag_template = TagTemplate.new
    @produtos = Produto.all.order(:pro_nome)
  end

  def baixar_pdf
    logger.info "🎯 BAIXAR_HTML - INICIANDO"
    puts "✅ HTML - CHEGOU NA ACTION baixar_pdf!"

    begin
      @label_data = prepare_label_data
      @quantity = params[:quantity].to_i || 1

      puts "🔴 [HTML] DADOS PARA ETIQUETA:"
      puts "   product_name: #{@label_data[:product_name]}"
      puts "   brand: #{@label_data[:brand]}"
      puts "   size: #{@label_data[:size]}"
      puts "   color: #{@label_data[:color]}"
      puts "   code: #{@label_data[:code]}"
      puts "   price: #{@label_data[:price]}"
      puts "   quantity: #{@quantity}"

      render "etiqueta", layout: "pdf"

    rescue => e
      logger.error "❌ ERRO HTML: #{e.message}"
      puts "🔴 [HTML] ERRO: #{e.message}"
      puts e.backtrace.join("\n")
      redirect_to gerar_etiqueta_path, alert: "Erro ao gerar etiquetas: #{e.message}"
    end
  end

  def imprimir_layout
    if request.post?
      data = JSON.parse(params[:layout_data])
      @layout_items = data["items"]
      @auto_print = true  # Isso faz auto-print

      # Preparar dados para o template
      @all_etiquetas = []

      @layout_items.each do |item|
        item["quantity"].to_i.times do
          @all_etiquetas << {
            label_color: item["label_color"],
            product_name: item["product_name"],
            brand: item["brand"],
            size: item["size"],
            color: item["color"],
            code: item["code"],
            price: item["price"],
            phone: item["phone"],
            instagram: item["instagram"]
          }
        end
      end

      # Renderiza com auto-print
      render "imprimir_layout", layout: "pdf"
    else
      redirect_to gerar_etiqueta_path, alert: "Método não permitido"
    end
  end

  private

  def prepare_label_data
    data = {
      product_name: params[:product_name] || "Produto",
      brand: params[:brand] || "Marca",
      size: params[:size] || "Tamanho",
      color: params[:color] || "Cor",
      code: params[:code] || "COD-001",
      price: params[:price] || "R$ 0,00",
      phone: params[:phone] || "(75) 91234-5678",
      instagram: params[:instagram] || "@instagram",
      facebook: params[:facebook] || "@facebook",
      label_color: params[:label_color] || "#4E4E4E"
    }

    puts "🎯 DADOS FINAIS:"
    puts data.inspect
    data
  end
end
