class MailChimp
  include Hominid

  def self.add_user(user)
    h = Hominid::API.new(MAIL_CHIMP[Rails.env]['api_key'])
    begin
      h.list_subscribe(MAIL_CHIMP[Rails.env]['subscriber_list'], user.email, {'FNAME' => user.profile.first_name, 'LNAME' => user.profile.last_name}, 'html', false, true, true, false)
    rescue
    end
  end

  def self.unsubscribe_user(user)
    h = Hominid::API.new(MAIL_CHIMP[Rails.env]['api_key'])
    begin
      h.list_unsubscribe(MAIL_CHIMP[Rails.env]['subscriber_list'], user.email)
    rescue
      h.list_subscribe(MAIL_CHIMP[Rails.env]['subscriber_list'], user.email, {'FNAME' => user.profile.first_name, 'LNAME' => user.profile.last_name}, 'html', false, true, true, false)
    end

  end

end