class Api::V1::CheckoutController < ApplicationController
    def create
        session = Stripe::Checkout::Session.create({
            line_items: JSON.parse(checkout_params[:items]),
            mode: 'payment',
            success_url: 'http://localhost:3000?success=true',
            cancel_url: 'http://localhost:3000',
            shipping_address_collection: {
                allowed_countries: ['US']
            }
          })
        
          render json: { redirect_url: session.url }, status: :ok
    end

    private
    def checkout_params
        params.require(:checkout).permit(:items)
    end
end