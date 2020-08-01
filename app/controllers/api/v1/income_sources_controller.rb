module Api
  module V1
    class IncomeSourcesController < ApiController
      # before_action :set_expense, only: [:show, :edit, :update, :destroy]
      skip_before_action :auth_with_token!, only: [:create, :data, :all, :update, :destroy]

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

      def create
        new_source = IncomeSource.new()
        new_source.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        new_source.name = params["params"]["name"]
        new_source.description = params["params"]["description"]

        if new_source.save
          render json: new_source, status: :created
        else
          render_error(new_source.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        source = IncomeSource.find(Integer(params["params"]["id"]))
        name = params["params"]["name"]
        description = params["params"]["description"]

        source.update(name: name, description: description)

        if source.save
          render json: {
            status: "SUCCESS",
            message: "Income Source updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      def destroy
        group = IncomeSource.destroy(params["id"])

        if group
          render json: {
            status: "SUCCESS",
            message: "Income Source deleted",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "Invalid id",
          }, status: 400
        end
      end
    end
  end
end
