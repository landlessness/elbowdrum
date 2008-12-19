class Item < ActiveRecord::Base
  belongs_to :account_membership
  belongs_to :created_by, :class_name => "AccountMembership"
  belongs_to :updated_by, :class_name => "AccountMembership"
  named_scope :for, lambda { |t| { :conditions => { :for => t } } }
end
