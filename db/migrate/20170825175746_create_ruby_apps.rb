class CreateRubyApps < ActiveRecord::Migration[5.1]
  def change
    create_table :ruby_apps do |t|
      t.string :name, null: false
      t.string :repo_url, null: false
      t.integer :api_type, null: false, default: 1
      t.text :api_data, length: 65536
      t.datetime :last_check, null: true
      t.timestamps
    end

    add_index :ruby_apps, :name, unique: true
    add_index :ruby_apps, :repo_url, unique: true
    add_index :ruby_apps, :last_check
  end
end
