class Api::V1::CheckoutController < ApplicationController
    def create
        # client_reference_id - checkout session id 
        # customer - customer id 
        # customer_email - if already has email
        # automatic_tax
        # custom_fields
        items = JSON.parse(checkout_params[:items])
        logger.info 'items items items items items'
        logger.info items
        logger.info 'items items items items items'

        free_shipping = {
            type: 'fixed_amount',
            fixed_amount: {
                amount: 0,
                currency: 'usd',
            },
            display_name: 'Free shipping',
            delivery_estimate: {
                minimum: {
                    unit: 'business_day',
                    value: 5,
                },
                maximum: {
                    unit: 'business_day',
                    value: 7,
                },
            },
        }

        standard_shipping = {
            type: 'fixed_amount',
            fixed_amount: {
                amount: 1000,
                currency: 'usd',
            },
            display_name: 'Standard',
            delivery_estimate: {
                minimum: {
                    unit: 'business_day',
                    value: 1,
                },
                maximum: {
                    unit: 'business_day',
                    value: 2,
                },
            },
        }




        session = Stripe::Checkout::Session.create({
            line_items: JSON.parse(checkout_params[:items]),
            mode: 'payment',    
            success_url: "#{Rails.application.credentials[Rails.env.to_sym][:app_url]}?checkout=1",
            cancel_url:  "#{Rails.application.credentials[Rails.env.to_sym][:app_url]}?checkout=0",
            shipping_address_collection: {
                allowed_countries: ['US']
            },
            shipping_options: [
                {
                    shipping_rate_data: free_shipping
                },
                {
                    shipping_rate_data: standard_shipping
                }
            ],
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