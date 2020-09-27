module Api
  module V1
    class ExpenseGroupsController < ApiController
      # before_action :set_expense, only: [:show, :edit, :update, :destroy]
      skip_before_action :auth_with_token!, only: [:create, :data, :all, :update, :destroy]

      # GET /expense_groups
      def data
        account = current_user.accounts.first
        expense_groups = ExpenseGroup.where(account_id: account.id).order("name ASC").pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user expense groups",
                 expense_groups: expense_groups,
               }, status: :ok
      end

      def all
        account = current_user.accounts.first
        expense_groups = ExpenseGroup.where(account_id: account.id)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user expense groups",
                 expense_groups: expense_groups,
               }, status: :ok
      end

      def create
        new_group = ExpenseGroup.new()
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
        group = ExpenseGroup.find(Integer(params["params"]["id"]))
        name = params["params"]["name"]
        description = params["params"]["description"]

        group.update(name: name, description: description)

        if group.save
          render json: {
            status: "SUCCESS",
            message: "Expense Group updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      def destroy
        group = ExpenseGroup.destroy(params["id"])

        if group
          render json: {
            status: "SUCCESS",
            message: "Expense Group deleted",
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
