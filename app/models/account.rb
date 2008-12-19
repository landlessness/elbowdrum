class Account < ActiveRecord::Base
  has_many :account_memberships
  has_many :people, :through => :account_memberships
  has_many :teams
end
