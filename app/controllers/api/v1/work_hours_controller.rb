module Api
  module V1
    class WorkHoursController < ApiController
      skip_before_action :auth_with_token!, only: [:create, :destroy, :update]

      # POST /workHours
      def create
        workHour = WorkHour.new()
        date = params["params"]["date"]
        workHour.account_id = Account.where(user_id: User.where(auth_token: params["headers"]["Authorization"]).first.id).first.id
        workHour.amount = params["params"]["amount"]
        workHour.source = params["params"]["source"]
        workHour.cwday = Date.parse(date).cwday
        workHour.cweek = Date.parse(date).cweek
        workHour.cwmonth = cwmonth(Date.parse(date).cweek)
        workHour.cwyear = Date.parse(date).cwyear
        workHour.date = date[0..9]

        if workHour.save
          render json: workHour, status: :created
        else
          render_error(workHour.errors.full_messages[0], :unprocessable_entity)
        end
      end

      # PATCH/PUT /workHours/
      def update
        date = params["params"]["date"]
        p = params["params"]["id"]
        workHour = WorkHour.find(Integer(params["params"]["id"]))
        amount = Float(params["params"]["amount"])
        source = params["params"]["source"]
        cwday = Date.parse(date).cwday
        cweek = Date.parse(date).cweek
        cwmonth = cwmonth(Date.parse(date).cweek)
        cwyear = Date.parse(date).cwyear
        date = date[0..9]

        workHour.update(amount: amount, source: source, cwday: cwday, cweek: cweek, cwmonth: cwmonth, cwyear: cwyear, date: date)

        if workHour.save
          render json: {
            status: "SUCCESS",
            message: "workHour updated",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "update error",
          }, status: :unprocessible_entity
        end
      end

      # DELETE /workHours/1
      # DELETE /workHours/1.json
      def destroy
        workHour = WorkHour.destroy(params["id"])

        if workHour
          render json: {
            status: "SUCCESS",
            message: "WorkHour deleted",
          }, status: :ok
        else
          render json: {
            status: "ERROR",
            message: "Invalid id",
          }, status: 400
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_workHour
        @workHour = WorkHour.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def workHour_params
        params.require(:workHour).permit(:account_id, :amount, :source, :cwday, :cweek, :cwmonth, :cwyear, :date)
      end
    end
  end
end
