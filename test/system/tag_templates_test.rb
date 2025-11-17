require "application_system_test_case"

class TagTemplatesTest < ApplicationSystemTestCase
  setup do
    @tag_template = tag_templates(:one)
  end

  test "visiting the index" do
    visit tag_templates_url
    assert_selector "h1", text: "Tag templates"
  end

  test "should create tag template" do
    visit tag_templates_url
    click_on "New tag template"

    fill_in "Color", with: @tag_template.color
    fill_in "Name", with: @tag_template.name
    fill_in "Store name", with: @tag_template.store_name
    click_on "Create Tag template"

    assert_text "Tag template was successfully created"
    click_on "Back"
  end

  test "should update Tag template" do
    visit tag_template_url(@tag_template)
    click_on "Edit this tag template", match: :first

    fill_in "Color", with: @tag_template.color
    fill_in "Name", with: @tag_template.name
    fill_in "Store name", with: @tag_template.store_name
    click_on "Update Tag template"

    assert_text "Tag template was successfully updated"
    click_on "Back"
  end

  test "should destroy Tag template" do
    visit tag_template_url(@tag_template)
    accept_confirm { click_on "Destroy this tag template", match: :first }

    assert_text "Tag template was successfully destroyed"
  end
end
