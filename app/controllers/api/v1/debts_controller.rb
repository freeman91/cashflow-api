# frozen_string_literal: true

module Api
  module V1
    class DebtsController < ApiController
      skip_before_action :auth_with_token!, only: %i[create destroy update month]

      def create
        debt = Debt.new
        date = params['params']['date']
        debt.account_id = Account.where(user_id: User.where(auth_token: params['headers']['Authorization']).first.id).first.id
        debt.amount = params['params']['amount']
        debt.group = params['params']['group']
        debt.description = params['params']['description']
        debt.cwmonth = cwmonth(Date.parse(date).cweek)
        debt.cwyear = Date.parse(date).cwyear
        debt.date = date[0..9]

        if debt.save
          render json: debt, status: :created
        else
          render_error(debt.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        debt = Debt.find(Integer(params['params']['id']))
        date = params['params']['date']
        amount = Float(params['params']['amount'])
        group = params['params']['group']
        description = params['params']['description']
        cwmonth = cwmonth(Date.parse(date).cweek)
        cwyear = Date.parse(date).cwyear
        date = date[0..9]

        debt.update(amount: amount, group: group, description: description, cwmonth: cwmonth, cwyear: cwyear, date: date)

        if debt.save
          render json: {
            status: 'Accepted',
            message: 'debt updated'
          }, status: :accepted
        else
          render json: {
            status: 'ERROR',
            message: 'update error'
          }, status: :unprocessible_entity
        end
      end

      def destroy
        debt = Debt.destroy(params['id'])

        if debt
          render json: {
            status: 'Accepted',
            message: 'Debt record deleted'
          }, status: :accepted
        else
          render json: {
            status: 'ERROR',
            message: 'Invalid id'
          }, status: 400
        end
      end

      def month
        account = Account.where(user_id: User.where(auth_token: params['headers']['Authorization']).first.id).first
        year = params['params']['year']
        month = params['params']['month']

        debts = Debt.where(account_id: account.id, cwyear: year, cwmonth: month)

        render json: {
          status: 'SUCCESS',
          message: 'Debts Loaded',
          debts: debts
        }, status: :ok
      end
    end
  end
end
