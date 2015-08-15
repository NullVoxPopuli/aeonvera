class UserSerializer < ActiveModel::Serializer

  attributes :id,
    :first_name, :last_name,
    :email,
    :sign_in_count,
    :current_sign_in_at, :current_sign_in_ip,
    :confirmed_at, :confirmation_sent_at,
    :unconfirmed_email,
    :time_zone

    def id
      # they don't need to know their ID
      0
    end
end
