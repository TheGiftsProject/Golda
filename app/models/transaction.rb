class Transaction < ActiveRecord::Base
  attr_accessible :amount, :date, :sector, :supplier_name

  def self.sectors_for_user(user)
    find(:all, :conditions => [ "user_id = ?",  user ], :select => "distinct sector").map(&:sector)
  end

  def self.for_user(user)
    where(:user_id => user)
  end

  def self.for_user_and_sector(user, sector)
    where(:user_id => user, :sector => sector)
  end
end
