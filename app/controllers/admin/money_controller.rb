class Admin::MoneyController < AdminController

  def index
    @account = Stripe::Account.retrieve
    @balance = Stripe::Balance.retrieve
  end

end