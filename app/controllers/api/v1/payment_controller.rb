class Api::V1::PaymentController < ApplicationController
    def create
        logger.info "params ---------------------------------"
        logger.info params
        logger.info "params  ---------------------------------"
    end
end

# params
#   id
#   [data]
#       [object]
#           amount_total
#           ??? automatic_tax
#           [custom_fields][0]
#               [dropdown]
#                   value
#           [customer_details]
#               email
#               name
#           ??? invoice
#           ??? invoice_creation
#           payment_status
#           [shipping_details]
#               [address]
#                   city
#                   country
#                   line1
#                   line2
#                   postal_code
#                   state
#               name
#           ??? shipping_options
#           ??? status
#           ??? total_details
#       [/object]
#   [/data]
#   ??? [request]
#   ??? type
#   [stripe]


