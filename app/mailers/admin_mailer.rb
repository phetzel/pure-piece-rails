class AdminMailer < ApplicationMailer
    def contact_email
        @email = params[:email]
        @subject = params[:subject]
        @message = params[:message]

        mail(to: Rails.application.credentials[Rails.env.to_sym][:gmail_email], subject: "New Message - #{@subject}")
    end

    def order_email
        @amount = params[:amount]
        @customer_name = params[:customer][:name]
        @customer_email = params[:customer][:email]
        @shipping_name = params[:shipping][:name]
        @shipping_address = params[:shipping][:address]

        mail(to: Rails.application.credentials[Rails.env.to_sym][:gmail_email], subject: "New Order")
    end
end
