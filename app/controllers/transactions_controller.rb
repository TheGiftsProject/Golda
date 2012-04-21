class TransactionsController < ApplicationController
  def index
    @name = params[:id]
    @txns = user_txns
    @sectors = user_txns.sectors

    @this_month = user_txns.sum_for_month(Time.now)
    @prev_month = user_txns.sum_for_month(Time.now - 1.month)
    @avg_month = user_txns.avg_per_month
  end

  private
  def user_txns
    Transaction.for_user(@name).sector(params.fetch(:sector) { nil })
  end
end
