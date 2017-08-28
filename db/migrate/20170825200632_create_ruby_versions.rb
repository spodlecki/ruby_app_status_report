class CreateRubyVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :ruby_versions do |t|
      t.string :version, null: false
      t.date :released, null: true
      t.string :notes_url, null: true
      t.timestamps
    end

    add_index :ruby_versions, :version, unique: true
  end
end
