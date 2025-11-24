require "application_system_test_case"

class FichaCrediariosTest < ApplicationSystemTestCase
  setup do
    @ficha_crediario = ficha_crediarios(:one)
  end

  test "visiting the index" do
    visit ficha_crediarios_url
    assert_selector "h1", text: "Ficha crediarios"
  end

  test "should create ficha crediario" do
    visit ficha_crediarios_url
    click_on "New ficha crediario"

    fill_in "Cliente", with: @ficha_crediario.cliente_id
    fill_in "Contratante", with: @ficha_crediario.contratante_id
    fill_in "Fic status", with: @ficha_crediario.fic_status
    fill_in "Fic valor total", with: @ficha_crediario.fic_valor_total
    click_on "Create Ficha crediario"

    assert_text "Ficha crediario was successfully created"
    click_on "Back"
  end

  test "should update Ficha crediario" do
    visit ficha_crediario_url(@ficha_crediario)
    click_on "Edit this ficha crediario", match: :first

    fill_in "Cliente", with: @ficha_crediario.cliente_id
    fill_in "Contratante", with: @ficha_crediario.contratante_id
    fill_in "Fic status", with: @ficha_crediario.fic_status
    fill_in "Fic valor total", with: @ficha_crediario.fic_valor_total
    click_on "Update Ficha crediario"

    assert_text "Ficha crediario was successfully updated"
    click_on "Back"
  end

  test "should destroy Ficha crediario" do
    visit ficha_crediario_url(@ficha_crediario)
    accept_confirm { click_on "Destroy this ficha crediario", match: :first }

    assert_text "Ficha crediario was successfully destroyed"
  end
end
