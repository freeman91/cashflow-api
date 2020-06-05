module Api
  module V1
    class NetworthController < ApiController
      def data
        account = current_user.accounts.first.id
        now = DateTime.now()
        @week = now.cweek()
        @month = cwmonth(@week)
        @year = now.cwyear()

        @debts = Debt.where(account_id: account, cwyear: @year, cwmonth: @month).order(date: :asc)
        @properties = Property.where(account_id: account, cwyear: @year, cwmonth: @month).order(date: :asc)
        @assetTotal = @debts.sum(:amount)
        @propTotal = @properties.sum(:amount)

        @netWorthLast12 = [[@month, @year, (@assetTotal - @propTotal)]]
        cur_month = @month
        cur_year = @year
        (1..11).each { |count|
          cur_month = cur_month - 1 == 0 ? 12 : cur_month - 1
          cur_year = cur_month == 12 ? cur_year - 1 : cur_year
          cur_debts_total = Debt.where(account_id: account, cwyear: cur_year, cwmonth: cur_month).sum(:amount)
          cur_props_total = Property.where(account_id: account, cwyear: cur_year, cwmonth: cur_month).sum(:amount)
          cur_net = cur_props_total - cur_debts_total
          @netWorthLast12.push([cur_month, cur_year, (cur_props_total - cur_debts_total)])
        }

        render json: {
                 status: "SUCCESS",
                 message: "Loaded net worth data",
                 cwdate: {
                   week: @week,
                   month: @month,
                   year: @year,
                 },
                 properties: @properties,
                 debts: @debts,
                 netWorthLast12: @netWorthLast12,
               }, status: :ok
      end
    end
  end
end
