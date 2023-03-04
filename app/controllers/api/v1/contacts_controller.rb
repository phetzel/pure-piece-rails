class Api::V1::ContactsController < ApplicationController
    # send an email to the admin from a user
    def create
        AdminMailer.with(
            email: contact_params[:email],
            subject: contact_params[:subject],
            message: contact_params[:message]
        ).contact_email.deliver_now

        render status: :ok
    end

    private
    def contact_params
        params.require(:contact).permit(:email, :subject, :message)
    end
end