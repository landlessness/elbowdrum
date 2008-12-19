module ItemsHelper

  def element_id(account_membership, time_frame, item_type, element_type)
    "#{time_frame}_#{item_type.to_s.underscore}_#{element_type}_#{account_membership.id}"
  end

  def auto_link_membership(txt)
    if match = txt.match(/(\s+|^)@([a-z0-9_]{1,255})/i)
      login = match[2]
      if person = @account.people.find_by_login(login)
        account_membership = @account.account_memberships.for_person(person).first
        class_name = 'person_' + person.id.to_s
        linked_login = link_to login, [@account, account_membership], :class => class_name, :onmouseover => "startHover('.#{class_name}')", :onmouseout => "stopHover('.#{class_name}')"
        txt.gsub! login, linked_login
      end
    end
    txt
  end

end
