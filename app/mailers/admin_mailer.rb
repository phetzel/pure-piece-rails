class AdminMailer < ApplicationMailer
    def contact_email
        @email = params[:email]
        @subject = params[:subject]
        @message = params[:message]

        mail(to: Rails.application.credentials[Rails.env.to_sym][:gmail_email], subject: "New Message - #{@subject}")
    end

    def order_email
        @order = params[:order]
        mail(to: Rails.application.credentials[Rails.env.to_sym][:gmail_email], subject: "You got a new order!")
    end
end
