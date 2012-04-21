class Transaction < ActiveRecord::Base
  attr_accessible :amount, :date, :sector, :supplier_name, :address

  def self.sectors_for_user(user)
    find(:all, :conditions => [ "user_id = ?",  user ], :select => "distinct sector").map(&:sector)
  end

  def self.for_user(user)
    where(:user_id => user)
  end

  def self.for_user_and_sector(user, sector)
    where(:user_id => user, :sector => sector)
  end

  def self.sum_for_month(user, sector, month_date)
    # FIXME
    if sector
      conds = ["user_id = ? and sector = ? and YEAR(date) = YEAR(?) and MONTH(date) = MONTH(?)", user, sector, month_date, month_date]
    else
      conds = ["user_id = ? and YEAR(date) = YEAR(?) and MONTH(date) = MONTH(?)", user, month_date, month_date]
    end

    sum(:amount, :conditions => conds)
  end

  def self.avg_per_month(user, sector)
    0
  end
end
