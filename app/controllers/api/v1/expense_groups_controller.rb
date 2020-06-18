module Api
  module V1
    class ExpenseGroupsController < ApiController
      # before_action :set_expense, only: [:show, :edit, :update, :destroy]
      skip_before_action :auth_with_token!, only: [:create]

      # GET /expense_groups
      def data
        account = current_user.accounts.first
        expense_groups = ExpenseGroup.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user expense groups",
                 expense_groups: expense_groups,
               }, status: :ok
      end
    end
  end
end
