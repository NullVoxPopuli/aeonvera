class AddAuthenticationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string

    User.all.each{ |user|
      if user.respond_to?(:authentication_token)
        user.save
      end
    }
  end
end
