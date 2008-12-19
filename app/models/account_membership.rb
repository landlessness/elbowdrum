class AccountMembership < ActiveRecord::Base
  belongs_to :person
  belongs_to :account
  has_many :deeds, :order => '`for`'
  has_many :blockers, :order => '`for`'
  has_many :daily_promises, :order => '`for`'
  has_many :sprint_promises, :order => '`for`'
  has_many :items, :order => '`for`'
  named_scope :for_person, lambda {|person| {:conditions => ['person_id = ?', person.id]}}
end
