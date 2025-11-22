class AddLabelConfigToTagTemplates < ActiveRecord::Migration[7.0]
  def change
    add_reference :tag_templates, :label_config, foreign_key: true, null: true
  end
end
