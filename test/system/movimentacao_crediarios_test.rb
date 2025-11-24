require "application_system_test_case"

class MovimentacaoCrediariosTest < ApplicationSystemTestCase
  setup do
    @movimentacao_crediario = movimentacao_crediarios(:one)
  end

  test "visiting the index" do
    visit movimentacao_crediarios_url
    assert_selector "h1", text: "Movimentacao crediarios"
  end

  test "should create movimentacao crediario" do
    visit movimentacao_crediarios_url
    click_on "New movimentacao crediario"

    fill_in "Ficha crediario", with: @movimentacao_crediario.ficha_crediario_id
    fill_in "Mov observacao", with: @movimentacao_crediario.mov_observacao
    fill_in "Mov tipo", with: @movimentacao_crediario.mov_tipo
    fill_in "Mov valor", with: @movimentacao_crediario.mov_valor
    click_on "Create Movimentacao crediario"

    assert_text "Movimentacao crediario was successfully created"
    click_on "Back"
  end

  test "should update Movimentacao crediario" do
    visit movimentacao_crediario_url(@movimentacao_crediario)
    click_on "Edit this movimentacao crediario", match: :first

    fill_in "Ficha crediario", with: @movimentacao_crediario.ficha_crediario_id
    fill_in "Mov observacao", with: @movimentacao_crediario.mov_observacao
    fill_in "Mov tipo", with: @movimentacao_crediario.mov_tipo
    fill_in "Mov valor", with: @movimentacao_crediario.mov_valor
    click_on "Update Movimentacao crediario"

    assert_text "Movimentacao crediario was successfully updated"
    click_on "Back"
  end

  test "should destroy Movimentacao crediario" do
    visit movimentacao_crediario_url(@movimentacao_crediario)
    accept_confirm { click_on "Destroy this movimentacao crediario", match: :first }

    assert_text "Movimentacao crediario was successfully destroyed"
  end
end
