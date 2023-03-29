class Api::V1::CheckoutController < ApplicationController
    def create
        # client_reference_id - checkout session id 
        # customer - customer id 
        # customer_email - if already has email
        # automatic_tax
        # custom_fields
        items = JSON.parse(checkout_params[:items])

        item_shipping = 0
        items.each do |item| 
            amount = Stripe::Price.retrieve(item["price"])["unit_amount"]
            item_shipping += amount * item["quantity"]
        end

        shipping_label = item_shipping > 20000 ? "Free Shipping"
        shipping_amount = item_shipping > 0 ? 5000

        session = Stripe::Checkout::Session.create({
            line_items: items,
            mode: 'payment',    
            success_url: "#{Rails.application.credentials[Rails.env.to_sym][:app_url]}?checkout=1",
            cancel_url:  "#{Rails.application.credentials[Rails.env.to_sym][:app_url]}?checkout=0",
            shipping_address_collection: {
                allowed_countries: ['US']
            },
            shipping_options: [
                {
                    shipping_rate_data: {
                        type: 'fixed_amount',
                        fixed_amount: {
                            amount: shipping_amount,
                            currency: 'usd',
                        },
                        display_name: shipping_label,
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
                        tax_behavior: 'exclusive',   
                    }
                }
            ],
            automatic_tax: {
                enabled: true
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