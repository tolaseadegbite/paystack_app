class Product < ApplicationRecord
    validates :name, :price, presence: true

    def to_s
        name
    end

    def to_builder
        Jbuilder.new do |product|
            product.name
            product.price
        end
    end
end
