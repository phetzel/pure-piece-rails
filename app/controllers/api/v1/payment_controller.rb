class Api::V1::PaymentController < ApplicationController
    def create
        logger.info "params ---------------------------------"
        logger.info params
        logger.info "params  ---------------------------------"

        payment_id = params[:id]
        data = params[:data][:object]

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

