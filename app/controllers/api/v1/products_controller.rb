class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update]
    def index
        @products = Stripe::Product.list().data

        if params[:active] == "true"
            @products = @products.select { |product| product.active == true }
        end

        @products.map do |product|
            price = Stripe::Price.retrieve(
                product.default_price,
            )

            product.price = price.unit_amount / 100
            product.priceId = price.id
        end
         
        render json: @products, only: 
            [
                :active, 
                :id, 
                :description, 
                :images, 
                :name, 
                :price,
                :priceId
            ]
    end

    def create
        @product = Stripe::Product.create({ 
            active: params[:product][:active],
            name: params[:product][:name],
            default_price_data: {
                currency: 'USD',
                unit_amount_decimal: params[:product][:price] * 100
            },
            description: params[:product][:description],
            # images: [params[:product][:image]]
        })

        # logger.debug "product"
        # logger.debug @product
        # logger.debug "product"


        # @product = Subscription.new(subscription_params)
    end

    def update
        update_field = params[:product][:field]

        # logger.debug "params -----------------------"
        if update_field == "price"
            # create new price
            @price = Stripe::Price.create({
                unit_amount: params[:product][:value] * 100,
                currency: 'usd',
                product: params[:product][:id],
            })

            # update new product price
            @product = Stripe::Product.update(
                params[:id],
                { 
                    "default_price": @price.id
                }
            )

            render json: 
        else
            @product = Stripe::Product.update(
                params[:id],
                { 
                    "#{update_field}": params[:product][:value]
                }
            )
        end
    end


    private

    def product_params
        params.require(:product).permit(
            :name, 
            :price,
            :description, 
            :active, 
            :image, 
            :field, 
            :value
        )
    end
end