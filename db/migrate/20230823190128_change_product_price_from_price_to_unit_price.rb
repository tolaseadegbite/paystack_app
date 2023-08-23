class ChangeProductPriceFromPriceToUnitPrice < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :price, :unit_price
  end
end
