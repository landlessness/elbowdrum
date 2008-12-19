class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :account_membership
      t.string :text
      t.string :type
      t.references :created_by
      t.references :updated_by
      t.date :for
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
