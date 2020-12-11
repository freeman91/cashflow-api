# frozen_string_literal: true

module Api
  module V1
    class NetworthController < ApiController
      def data
        account = @current_user.accounts.first.id

        week = Integer(params['week'])
        year = Integer(params['year'])
        month = cwmonth(week)

        debts = Debt.where(account_id: account, cwyear: year, cwmonth: month).order(date: :asc)
        properties = Property.where(account_id: account, cwyear: year, cwmonth: month).order(date: :asc)
        debtTotal = debts.sum(:amount)
        propTotal = properties.sum(:amount)

        netWorthLast12 = [[month, year, (propTotal - debtTotal)]]
        cur_month = month
        cur_year = year
        (1..11).each do |_count|
          cur_month = cur_month - 1 == 0 ? 12 : cur_month - 1
          cur_year = cur_month == 12 ? cur_year - 1 : cur_year
          cur_debts_total = Debt.where(account_id: account, cwyear: cur_year, cwmonth: cur_month).sum(:amount)
          cur_props_total = Property.where(account_id: account, cwyear: cur_year, cwmonth: cur_month).sum(:amount)
          cur_net = cur_props_total - cur_debts_total
          netWorthLast12.push([cur_month, cur_year, (cur_props_total - cur_debts_total)])
        end

        render json: {
          status: 'SUCCESS',
          message: 'Loaded net worth data',
          properties: properties,
          debts: debts,
          netWorthLast12: netWorthLast12
        }, status: :ok
      end
    end
  end
end
