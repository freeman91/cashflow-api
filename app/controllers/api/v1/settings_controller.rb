module Api
  module V1
    class SettingsController < ApiController
      def data
        account = current_user.accounts.first.id
        @expense_groups = ExpenseGroup.where(account_id: account)
        @income_sources = IncomeSource.where(account_id: account)
        @debt_groups = DebtGroup.where(account_id: account)
        @property_sources = PropertySource.where(account_id: account)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded settings data",
                 expense_groups: @expense_groups,
                 income_sources: @income_sources,
                 debt_groups: @debt_groups,
                 property_sources: @property_sources,
               }, status: :ok
      end
    end
  end
end
