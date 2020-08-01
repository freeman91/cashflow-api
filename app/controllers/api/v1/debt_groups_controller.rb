module Api
  module V1
    class DebtGroupsController < ApiController
      skip_before_action :auth_with_token!, only: [:create, :data, :all, :update, :destroy]

      def data
        account = current_user.accounts.first
        groups = DebtGroup.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user debt groups",
                 groups: groups,
               }, status: :ok
      end

      def all
        account = current_user.accounts.first
        groups = DebtGroup.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user debt groups",
                 groups: groups,
               }, status: :ok
      end

      def create
        new_group = DebtGroup.new()
        new_group.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        new_group.name = params["params"]["name"]
        new_group.description = params["params"]["description"]

        if new_group.save
          render json: new_group, status: :created
        else
          render_error(new_group.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        group = DebtGroup.find(Integer(params["params"]["id"]))
        name = params["params"]["name"]
        description = params["params"]["description"]

        group.update(name: name, description: description)

        if group.save
          render json: {
            status: "SUCCESS",
            message: "Debt Group updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      def destroy
        group = DebtGroup.destroy(params["id"])

        if group
          render json: {
            status: "SUCCESS",
            message: "Debt Group deleted",
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
