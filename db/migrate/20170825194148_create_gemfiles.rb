class CreateGemfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :gemfiles do |t|
      t.integer :ruby_app_id, null: false
      t.text :data, default: nil, length: 4294967295
      t.timestamps
    end

    add_index :gemfiles, :ruby_app_id, unique: true
  end
end
