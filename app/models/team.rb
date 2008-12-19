class Team < ActiveRecord::Base
  belongs_to :account
  has_many :team_memberships
  has_many :people, :through => :team_memberships
end
