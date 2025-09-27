# Allow Devise login via email or username using the :login virtual attribute
module DeviseLoginWithEmailOrUsername
  extend ActiveSupport::Concern

  included do
    attr_writer :login

    def login
      @login || self[:login] || email || username
    end
  end

  class_methods do
    # Override Devise's find_for_database_authentication
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if (login = conditions.delete(:login))
        user = where(conditions).where([
          "lower(username) = :value OR lower(email) = :value",
          { value: login.downcase }
        ]).first
        user
      else
        user = where(conditions).first
        user
      end
    end
  end
end
