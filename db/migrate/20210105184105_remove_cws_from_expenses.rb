class RemoveCwsFromExpenses < ActiveRecord::Migration[5.2]
  def change
    remove_column :expenses, :bill, :boolean
    remove_column :expenses, :cwday, :integer
    remove_column :expenses, :cweek, :integer
    remove_column :expenses, :cwmonth, :integer
    remove_column :expenses, :cwyear, :integer

    remove_column :incomes, :cwday, :integer
    remove_column :incomes, :cweek, :integer
    remove_column :incomes, :cwmonth, :integer
    remove_column :incomes, :cwyear, :integer

    remove_column :work_hours, :cwday, :integer
    remove_column :work_hours, :cweek, :integer
    remove_column :work_hours, :cwmonth, :integer
    remove_column :work_hours, :cwyear, :integer

    remove_column :debts, :cwmonth, :integer
    remove_column :debts, :cwyear, :integer

    remove_column :properties, :cwmonth, :integer
    remove_column :properties, :cwyear, :integer
  end
end
