class Admin::User < ActiveRecord::Base

  self.table_name = "admin_users"

  def self.find_or_create_from_auth_hash(auth_hash)
    info = auth_hash['info']

    user = where(provider: auth_hash["provider"], uid: auth_hash["uid"])

    if user.empty?
      user = self.create!(
        name: info["name"],
        email: info["email"],
        provider: auth_hash["provider"],
        uid: auth_hash["uid"]
      )
    end

    user
  end

end
