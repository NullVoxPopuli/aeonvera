PartyFoul.configure do |config|
  # The collection of exceptions PartyFoul should not be allowed to handle
  # The constants here *must* be represented as strings
  # config.blacklisted_exceptions = ['ActionController::RoutingError']

  # the number of times the exception occurs will still be updated in
  # the first post
  config.comment_limit = 5

  # The OAuth token for the account that is opening the issues on GitHub
  config.oauth_token            = ENV['PARTY_FOUL_GITHUB']

  # The API endpoint for GitHub. Unless you are hosting a private
  # instance of Enterprise GitHub you do not need to include this
  config.api_endpoint           = 'https://api.github.com'

  # The Web URL for GitHub. Unless you are hosting a private
  # instance of Enterprise GitHub you do not need to include this
  config.web_url                = 'https://github.com'

  # The organization or user that owns the target repository
  config.owner                  = 'NullVoxPopuli'

  # The repository for this application
  config.repo                   = 'aeonvera'

  # The branch for your deployed code
  # config.branch               = 'master'

  # Setting your title prefix can help with
  # distinguising the issue between environments
  # config.title_prefix         = Rails.env

  config.additional_labels = Proc.new { |exception, env|
    labels = []

    if env["HTTP_HOST"] =~ /api\//
      lables << 'api'
    else
      labels << 'backend'
    end

    if exception.message =~ /PG::Error/
      labels << 'database'
    end

    labels
  }
end
