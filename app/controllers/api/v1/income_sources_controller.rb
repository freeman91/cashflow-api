module Api
  module V1
    class IncomeSourcesController < ApiController
      # before_action :set_expense, only: [:show, :edit, :update, :destroy]
      skip_before_action :auth_with_token!, only: [:create, :data, :all]

      # GET /income_sources
      def data
        account = current_user.accounts.first
        income_sources = IncomeSource.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user income sources",
                 income_sources: income_sources,
               }, status: :ok
      end

      def all
        account = current_user.accounts.first
        income_sources = IncomeSource.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user income sources",
                 income_sources: income_sources,
               }, status: :ok
      end
    end
  end
end
