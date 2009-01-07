class AddScreenNameToMembership < ActiveRecord::Migration
  def self.up
    change_table :account_memberships do |t|
      t.string :screen_name
    end
  end

  def self.down
    change_table :account_memberships do |t|
      t.remove :screen_name
    end
  end
end
