class Api::V1::PaymentController < ApplicationController
    def create
        # payload = request.body.read
        # endpoint_secret = "#{Rails.application.credentials[Rails.env.to_sym][:stripe_endpoint]}"
        # sig_header = request.env['HTTP_STRIPE_SIGNATURE']

        # event = Stripe::Webhook.construct_event(
        #     payload, sig_header, endpoint_secret
        # )
      
        # logger.info 'event -----------------------'
        # logger.info event
        # logger.info 'event -----------------------'

        event_id = params[:id]
        data = params[:data][:object]

        checkout_session_id = data[:id]
        line_items = Stripe::Checkout::Session.list_line_items(checkout_session_id)

        logger.info 'line_items +++++++++++++++++++++++'
        logger.info line_items
        logger.info 'line_items +++++++++++++++++++++++'
        payment_status = data[:payment_status]
        is_subscribing = data[:custom_fields][0][:dropdown][:value]

        amount = data[:amount_total]
        customer = data[:customer_details]
        shipping = data[:shipping_details]


        AdminMailer.with(
            amount: amount,
            customer: customer,
            shipping: shipping,
        ).order_email.deliver_now

        render status: :ok
    end
end

# params
#   id
#   [data]
#       [object]
#           ! amount_total
#           ??? automatic_tax
#           ! [custom_fields][0] 
#               ! [dropdown]
#                   ! value
#           ! [customer_details]
#               ! email
#               ! name
#           ??? invoice
#           ??? invoice_creation
#           ! payment_status
#           ! [shipping_details]
#               ! [address]
#                   ! city
#                   ! country
#                   ! line1
#                   ! line2
#                   ! postal_code
#                   ! state
#               ! name
#           ??? shipping_options
#           ??? status
#           ??? total_details
#       [/object]
#   [/data]
#   ??? [request]
#   ??? type
#   [stripe]


