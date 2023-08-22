class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :initialize_session
    before_action :load_cart

    def load_cart
        @cart = Product.find(session[:cart])
        render 'carts/cart' if action_name == 'load_cart'
    end

    private

    def initialize_session
        session[:cart] ||= [] #empty cart = empty array
    end

end
