class CheckoutController < ApplicationController
    
    def create
        product = Product.find(params[:id])

        @paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY],Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])

        @payment = PaystackTransactions.new(@paystack)
        @result = @payment.initializeTransaction(
            :name => product.name,
            :reference => "#{product.id}__#{rand.to_s[2..10]}",
            :amount => product.price * 100,
            :email => current_user.email,
            callback_url: root_url + "",
            channels: ["card"]
            )
        auth_url = @result['data']['authorization_url']
        respond_to do |format|
            format.html { redirect_to auth_url, allow_other_host: true }
        end
    end
end