class AddCurrentAccountToPeople < ActiveRecord::Migration
  def self.up
    change_table "people" do |t|
      t.references :current_account
    end
  end

  def self.down
  end
end
