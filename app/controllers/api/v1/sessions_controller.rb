# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :auth_with_token!, only: [:create]

      def create
        user = login_user
        if user
          render json: user, status: :ok
        else
          render_error(I18n.t('authentication.error', authentication_keys: 'email'), :unprocessable_entity)
        end
      end

      def destroy
        @current_user.regenerate_auth_token
        head :no_content
      end

      private

      def login_user
        params.inspect
        user = User.find_by_email(params[:email])
        user.inspect
        if user&.authenticate(params[:password])
          user.regenerate_auth_token
          user
        end
      end
    end
  end
end
