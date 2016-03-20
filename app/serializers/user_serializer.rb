class UserSerializer < ActiveModel::Serializer

  attributes :id,
    :first_name, :last_name,
    :email,
    :sign_in_count,
    :current_sign_in_at, :current_sign_in_ip,
    :confirmed_at, :confirmation_sent_at,
    :unconfirmed_email,
    :time_zone

    has_many :membership_renewals

    def id
      # this is to make looking up the current user in the
      # ember store easy
      'current-user'
    end

    def membership_renewals
      object.renewals
    end
end
