class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :email
      t.string :confirmation_code
      t.references :person
      t.datetime :confirmed_at
      t.string :state,                     :null => :no, :default => 'passive'
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
