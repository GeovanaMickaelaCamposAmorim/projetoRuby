module ApplicationHelper
  def movimentacao_badge_class(tipo)
  case tipo
  when "reabastecimento", "devolucao"
    "bg-green-100 text-green-800"
  when "retirada", "venda", "crediario"
    "bg-red-100 text-red-800"
  else
    "bg-gray-100 text-gray-800"
  end
  end
end
