require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :people

  def test_should_create_person
    assert_difference 'Person.count' do
      person = create_person
      assert !person.new_record?, "#{person.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    person = create_person
    person.reload
    assert_not_nil person.activation_code
  end

  def test_should_create_and_start_in_pending_state
    person = create_person
    person.reload
    assert person.pending?
  end


  def test_should_require_login
    assert_no_difference 'Person.count' do
      u = create_person(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Person.count' do
      u = create_person(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Person.count' do
      u = create_person(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Person.count' do
      u = create_person(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    people(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal people(:quentin), Person.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    people(:quentin).update_attributes(:login => 'quentin2')
    assert_equal people(:quentin), Person.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_person
    assert_equal people(:quentin), Person.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    people(:quentin).remember_me
    assert_not_nil people(:quentin).remember_token
    assert_not_nil people(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    people(:quentin).remember_me
    assert_not_nil people(:quentin).remember_token
    people(:quentin).forget_me
    assert_nil people(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    people(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil people(:quentin).remember_token
    assert_not_nil people(:quentin).remember_token_expires_at
    assert people(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    people(:quentin).remember_me_until time
    assert_not_nil people(:quentin).remember_token
    assert_not_nil people(:quentin).remember_token_expires_at
    assert_equal people(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    people(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil people(:quentin).remember_token
    assert_not_nil people(:quentin).remember_token_expires_at
    assert people(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_person
    person = create_person(:password => nil, :password_confirmation => nil)
    assert person.passive?
    person.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    person.register!
    assert person.pending?
  end

  def test_should_suspend_person
    people(:quentin).suspend!
    assert people(:quentin).suspended?
  end

  def test_suspended_person_should_not_authenticate
    people(:quentin).suspend!
    assert_not_equal people(:quentin), Person.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_person_to_active_state
    people(:quentin).suspend!
    assert people(:quentin).suspended?
    people(:quentin).unsuspend!
    assert people(:quentin).active?
  end

  def test_should_unsuspend_person_with_nil_activation_code_and_activated_at_to_passive_state
    people(:quentin).suspend!
    Person.update_all :activation_code => nil, :activated_at => nil
    assert people(:quentin).suspended?
    people(:quentin).reload.unsuspend!
    assert people(:quentin).passive?
  end

  def test_should_unsuspend_person_with_activation_code_and_nil_activated_at_to_pending_state
    people(:quentin).suspend!
    Person.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert people(:quentin).suspended?
    people(:quentin).reload.unsuspend!
    assert people(:quentin).pending?
  end

  def test_should_delete_person
    assert_nil people(:quentin).deleted_at
    people(:quentin).delete!
    assert_not_nil people(:quentin).deleted_at
    assert people(:quentin).deleted?
  end

protected
  def create_person(options = {})
    record = Person.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
