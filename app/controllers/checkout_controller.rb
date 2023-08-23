class CheckoutController < ApplicationController
    
    def create
        total_price = @cart.sum(&:price)
        cart_items = @cart.pluck(:name)
        reference = "#{@cart.pluck(:id).join().to_i}_#{rand.to_s[2..10]}"
        callback_url = checkout_success_url
        cancel_url = checkout_failure_url

        @paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY],Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])

        @payment = PaystackTransactions.new(@paystack)

        @result = @payment.initializeTransaction(
            :reference => reference,
            :amount => total_price * 100,
            :email => current_user.email,
            callback_url: callback_url,
            channels: ["card"],
            metadata: {
                cancel_action: cancel_url,
                payment_medium: "Website",
                custom_fields: [
                    {
                        "display_name": "Cart Items",
                        "variable_name": "Cart Items",
                        "value": cart_items
                    }
                ]
            }
        )
        auth_url = @result['data']['authorization_url']
        respond_to do |format|
            format.html { redirect_to auth_url, allow_other_host: true }
        end
    end

    def success
        session[:cart] = [] # empty array cart = empty array
        
        paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY], Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])

        transaction_reference = params[:reference]

        result = PaystackTransactions.verify(paystack, transaction_reference)

        result['data']['metadata']['custom_fields'].each do |field|
            field['value'].each do |name|
                product = Product.find_by(name: name)
                product.increment!(:sales_count)
            end
        end
    end
end