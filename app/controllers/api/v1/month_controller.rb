# frozen_string_literal: true

module Api
  module V1
    class MonthController < ApiController
      def pie_chart
        startDate = params["startDate"]
        endDate = params["endDate"]
        groupSums = {}

        expenses = Expense.where(account_id: current_user.accounts.first.id, date: startDate..endDate)
        groups = expenses.pluck("group").uniq

        groups.each { |group| groupSums[group] = expenses.where(group: group).sum(:amount) }

        render json: {
          status: "SUCCESS",
          message: "Loaded chart data",
          groupSums: groupSums,
        }, status: :ok
      end
    end
  end
end
