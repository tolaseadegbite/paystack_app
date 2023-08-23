class Product < ApplicationRecord
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :unit_price, presence: true, numericality: { greater_than: 0 }

    def to_s
        name
    end

    def total_price
        quantity * unit_price
    end

    def to_builder
        Jbuilder.new do |product|
            product.name
            product.price
        end
    end

    after_create do
        update(code: "#{self.id}_#{rand.to_s[2..10]}")
    end
end
