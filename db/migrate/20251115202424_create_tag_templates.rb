class CreateTagTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :tag_templates do |t|
      t.string :name
      t.string :color
      t.string :store_name

      t.timestamps
    end
  end
end
