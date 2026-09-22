class DashboardController < ApplicationController
  def index
    @available_phones = Phone.available
    @available_count = @available_phones.count
    @inventory_cost = @available_phones.sum("purchase_price + repair_cost")
    @inventory_sale_value = @available_phones.sum(:sale_price)
    @expected_profit = @inventory_sale_value - @inventory_cost

    @month_sales = Sale.this_month
    @month_sales_count = @month_sales.count
    @month_sales_total = @month_sales.sum(:sale_price)
    @month_profit = @month_sales.to_a.sum(&:profit)

    active_credits = Credit.active.includes(:sale)
    @total_receivable = active_credits.to_a.sum(&:pending_balance)
    @receivable_by_entity = active_credits.group_by(&:entity).transform_values { |c| c.sum(&:pending_balance) }
    @overdue_credits_count = active_credits.count(&:overdue?)

    @icloud_pending_count = Phone.available.where(icloud_unlocked: false).where.not(icloud_account: [ nil, "" ]).count

    @has_demo_data = Phone.demo_data.exists? || Sale.demo_data.exists?
  end
end
