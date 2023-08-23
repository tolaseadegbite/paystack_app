class ChangeUnitPriceTypeToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :unit_price, :decimal, precision: 8, scale: 2
  end
end
