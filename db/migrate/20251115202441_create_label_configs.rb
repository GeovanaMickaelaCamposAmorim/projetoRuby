class CreateLabelConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :label_configs do |t|
      t.string :name
      t.string :color, default: "#4E4E4E"
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
