def page!
  save_and_open_page
end

def login(user = @user = create(:user))
  user.confirm!
  sign_in user
end

def confirmed_user(user = @user = create(:user))
  user.confirm!
  user
end

def current_user
  controller.current_user
end


def create_event
  event = create(:event)
  # opening pricing tier
  pricing_tier = create(:opening_tier)
  event.opening_tier = pricing_tier
  pricing_tier.event = event
  pricing_tier.save

  # must have at least one package
  package = create(:package)
  package.event = event
  package.save

  Date.stub(:today).and_return((event.pricing_tiers.first.date + 5.days).to_date)
  event
end


def event_path(path, params = {})
  ["hosted_events/#{path}", { hosted_event_id: @event.id.to_s }.merge(params)]
end

# this should be defined in the hosts file
def test_event_domain
  "//testevent.#{root_test_domain}"
end

def root_test_domain
  APPLICATION_CONFIG[:domain][Rails.env]
end