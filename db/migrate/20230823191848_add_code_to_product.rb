class AddCodeToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :code, :string, unique: true
  end
end
