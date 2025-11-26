require "application_system_test_case"

class EstoqueMovimentacaosTest < ApplicationSystemTestCase
  setup do
    @estoque_movimentacao = estoque_movimentacaos(:one)
  end

  test "visiting the index" do
    visit estoque_movimentacaos_url
    assert_selector "h1", text: "Estoque movimentacaos"
  end

  test "should create estoque movimentacao" do
    visit estoque_movimentacaos_url
    click_on "New estoque movimentacao"

    fill_in "Emv data", with: @estoque_movimentacao.emv_data
    fill_in "Emv quantidade", with: @estoque_movimentacao.emv_quantidade
    fill_in "Emv tipo", with: @estoque_movimentacao.emv_tipo
    fill_in "Emv valor total", with: @estoque_movimentacao.emv_valor_total
    fill_in "Produto", with: @estoque_movimentacao.produto_id
    click_on "Create Estoque movimentacao"

    assert_text "Estoque movimentacao was successfully created"
    click_on "Back"
  end

  test "should update Estoque movimentacao" do
    visit estoque_movimentacao_url(@estoque_movimentacao)
    click_on "Edit this estoque movimentacao", match: :first

    fill_in "Emv data", with: @estoque_movimentacao.emv_data
    fill_in "Emv quantidade", with: @estoque_movimentacao.emv_quantidade
    fill_in "Emv tipo", with: @estoque_movimentacao.emv_tipo
    fill_in "Emv valor total", with: @estoque_movimentacao.emv_valor_total
    fill_in "Produto", with: @estoque_movimentacao.produto_id
    click_on "Update Estoque movimentacao"

    assert_text "Estoque movimentacao was successfully updated"
    click_on "Back"
  end

  test "should destroy Estoque movimentacao" do
    visit estoque_movimentacao_url(@estoque_movimentacao)
    accept_confirm { click_on "Destroy this estoque movimentacao", match: :first }

    assert_text "Estoque movimentacao was successfully destroyed"
  end
end
