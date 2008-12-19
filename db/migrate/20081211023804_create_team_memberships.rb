class CreateTeamMemberships < ActiveRecord::Migration
  def self.up
    create_table :team_memberships do |t|
      t.references :team
      t.references :person
      t.timestamps
    end
  end

  def self.down
    drop_table :team_memberships
  end
end
