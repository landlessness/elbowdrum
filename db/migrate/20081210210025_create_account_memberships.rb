class CreateAccountMemberships < ActiveRecord::Migration
  def self.up
    create_table :account_memberships do |t|
      t.references :account
      t.references :person
      t.boolean :administrator, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :account_memberships
  end
end
