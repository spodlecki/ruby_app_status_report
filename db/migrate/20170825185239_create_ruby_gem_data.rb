class CreateRubyGemData < ActiveRecord::Migration[5.1]
  def change
    create_table :ruby_gem_data do |t|
      t.string :name, null: false
      t.text :versions, length: 65536
      t.boolean :skip, default: false
      t.timestamps
    end

    add_index :ruby_gem_data, :name, unique: true
    add_index :ruby_gem_data, :updated_at
  end
end
