class Api::V1::CheckoutController < ApplicationController
    def create
        # client_reference_id - checkout session id 
        # customer - customer id 
        # customer_email - if already has email
        # automatic_tax
        # custom_fields

        session = Stripe::Checkout::Session.create({
            line_items: JSON.parse(checkout_params[:items]),
            mode: 'payment',
            success_url: 'http://localhost:3000?checkout=1',
            cancel_url: 'http://localhost:3000?checkout=0',
            shipping_address_collection: {
                allowed_countries: ['US']
            },
            custom_fields: [
                {
                    key: 'subscribe',
                    label: { 
                        custom: 'Subscribe to Mailing List?',
                        type: 'custom'
                    },
                    type: 'dropdown',
                    dropdown: {
                        options: [
                            { label: "Yes", value: true },
                            { label: "No", value: false },
                        ]
                    }
                }
            ]
          })
        
          render json: { redirect_url: session.url }, status: :ok
    end

    private
    def checkout_params
        params.require(:checkout).permit(:items)
    end
end