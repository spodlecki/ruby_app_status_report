class AddRubyVersionToRubyApp < ActiveRecord::Migration[5.1]
  def change
    add_column :ruby_apps, :ruby_version, :string, default: nil
  end
end
