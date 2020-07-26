module Api
  module V1
    class DebtGroupsController < ApiController
      skip_before_action :auth_with_token!, only: [:all]

      def all
        account = current_user.accounts.first
        groups = DebtGroup.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded user debt groups",
                 groups: groups,
               }, status: :ok
      end
    end
  end
end
