module Api
  module V1
    class PropertySourcesController < ApiController
      skip_before_action :auth_with_token!, only: [:data]

      def data
        account = current_user.accounts.first
        sources = PropertySource.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user property sources",
                 sources: sources,
               }, status: :ok
      end

      def all
        account = current_user.accounts.first
        sources = PropertySource.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user property sources",
                 sources: sources,
               }, status: :ok
      end
    end
  end
end
