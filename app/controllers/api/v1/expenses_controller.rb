module Api
  module V1
    class ExpensesController < ApiController

      # before_action :set_expense, only: [:show, :edit, :update, :destroy]

      # GET /expenses/new_expense
      def new_expense
        account = Account.first
        # account = current_user.accounts.first

        expense = Expense.new
        expense.account_id = account.id
        expense.bill = false

        expense_groups = ExpenseGroup.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded new expense template",
                 expense: expense,
                 expense_groups: expense_groups,
               }, status: :ok
      end

      # GET /expenses/new_bill
      def new_bill
        account = Account.first
        # account = current_user.accounts.first

        bill = Expense.new
        bill.account_id = account.id
        bill.bill = true

        expense_groups = ExpenseGroup.where(account_id: account.id).pluck(:name)

        render json: {
                 status: "SUCCESS",
                 message: "Loaded new bill template",
                 expense: bill,
                 expense_groups: expense_groups,
               }, status: :ok
      end

      # GET /expenses/1/edit
      # def edit
      #     @account = current_user.accounts.first
      #     @expense_groups = ExpenseGroup.where(account_id: @account.id).pluck(:name)
      #     @card_title = "Edit Expense"
      # end

      # POST /expenses
      # POST /expenses.json
      def create
        expense = Expense.new()
        expense.account_id = params["account_id"]
        expense.amount = params["amount"]
        expense.group = params["group"]
        expense.vendor = params["vendor"]
        expense.cwday = params["cwday"]
        expense.cweek = params["cweek"]
        expense.cwmonth = params["cwmonth"]
        expense.cwyear = params["cwyear"]
        expense.date = params["date"]
        expense.bill = false

        if expense.save
          render json: expense, status: :created
        else
          render_error(expense.errors.full_messages[0], :unprocessable_entity)
        end
      end

      # PATCH/PUT /expenses/1
      # PATCH/PUT /expenses/1.json
      def update
        respond_to do |format|
          if @expense.update(expense_params)
            @expense.cwday = Date.parse(@expense.date.to_s).cwday
            @expense.cweek = Date.parse(@expense.date.to_s).cweek
            @expense.cwmonth = cwmonth(@expense.cweek)
            @expense.cwyear = Date.parse(@expense.date.to_s).cwyear

            if @expense.save
              if @expense.bill
                format.html { redirect_to pages_month_path, notice: "Bill was successfully changed." }
              else
                format.html { redirect_to pages_console_path, notice: "Expense was successfully changed." }
              end
            else
              format.html { render :edit }
            end
          else
            format.html { render :edit }
          end
        end
      end

      # DELETE /expenses/1
      # DELETE /expenses/1.json
      def destroy
        @expense.destroy
        respond_to do |format|
          if @expense.bill
            format.html { redirect_to pages_month_path, notice: "Bill was successfully deleted." }
          else
            format.html { redirect_to pages_console_path, notice: "Expense was successfully deleted." }
          end
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_expense
        @expense = Expense.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def expense_params
        params.require(:expense).permit(:account_id, :amount, :group, :vendor, :description, :cwday, :cweek, :cwmonth, :cwyear, :date)
      end
    end
  end
end
