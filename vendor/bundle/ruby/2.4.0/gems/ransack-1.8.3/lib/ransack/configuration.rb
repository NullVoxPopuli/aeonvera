require 'ransack/constants'
require 'ransack/predicate'

module Ransack
  module Configuration

    mattr_accessor :predicates, :options
    self.predicates = {}
    self.options = {
      :search_key => :q,
      :ignore_unknown_conditions => true,
      :hide_sort_order_indicators => false,
      :up_arrow => '&#9660;'.freeze,
      :down_arrow => '&#9650;'.freeze,
      :sanitize_scope_args => true
    }

    def configure
      yield self
    end

    def add_predicate(name, opts = {})
      name = name.to_s
      opts[:name] = name
      compounds = opts.delete(:compounds)
      compounds = true if compounds.nil?
      compounds = false if opts[:wants_array]

      self.predicates[name] = Predicate.new(opts)

      Constants::SUFFIXES.each do |suffix|
        compound_name = name + suffix
        self.predicates[compound_name] = Predicate.new(
          opts.merge(
            :name => compound_name,
            :arel_predicate => arel_predicate_with_suffix(
              opts[:arel_predicate], suffix
              ),
            :compound => true
          )
        )
      end if compounds
    end

    # The default `search_key` name is `:q`. The default key may be overridden
    # in an initializer file like `config/initializers/ransack.rb` as follows:
    #
    # Ransack.configure do |config|
    #   # Name the search_key `:query` instead of the default `:q`
    #   config.search_key = :query
    # end
    #
    # Sometimes there are situations when the default search parameter name
    # cannot be used, for instance if there were two searches on one page.
    # Another name can be set using the `search_key` option with Ransack
    # `ransack`, `search` and `@search_form_for` methods in controllers & views.
    #
    # In the controller:
    # @search = Log.ransack(params[:log_search], search_key: :log_search)
    #
    # In the view:
    # <%= f.search_form_for @search, as: :log_search %>
    #
    def search_key=(name)
      self.options[:search_key] = name
    end

    # By default Ransack ignores errors if an unknown predicate, condition or
    # attribute is passed into a search. The default may be overridden in an
    # initializer file like `config/initializers/ransack.rb` as follows:
    #
    # Ransack.configure do |config|
    #   # Raise if an unknown predicate, condition or attribute is passed
    #   config.ignore_unknown_conditions = false
    # end
    #
    def ignore_unknown_conditions=(boolean)
      self.options[:ignore_unknown_conditions] = boolean
    end

    # By default, Ransack displays sort order indicator arrows with HTML codes:
    #
    #   up_arrow:   '&#9660;'
    #   down_arrow: '&#9650;'
    #
    # One or both defaults may be globally overridden in an initializer file
    # like `config/initializers/ransack.rb` as follows:
    #
    # Ransack.configure do |config|
    #   # Globally set the up arrow to an icon and the down arrow to unicode.
    #   config.custom_arrows = {
    #     up_arrow:   '<i class="fa fa-long-arrow-up"></i>',
    #     down_arrow: 'U+02193'
    #   }
    # end
    #
    def custom_arrows=(opts = {})
      self.options[:up_arrow] = opts[:up_arrow].freeze if opts[:up_arrow]
      self.options[:down_arrow] = opts[:down_arrow].freeze if opts[:down_arrow]
    end

    # Ransack sanitizes many values in your custom scopes into booleans.
    # [1, '1', 't', 'T', 'true', 'TRUE'] all evaluate to true.
    # [0, '0', 'f', 'F', 'false', 'FALSE'] all evaluate to false.
    #
    # This default may be globally overridden in an initializer file like
    # `config/initializers/ransack.rb` as follows:
    #
    # Ransack.configure do |config|
    #   # Accept my custom scope values as what they are.
    #   config.sanitize_custom_scope_booleans = false
    # end
    #
    def sanitize_custom_scope_booleans=(boolean)
      self.options[:sanitize_scope_args] = boolean
    end

    # By default, Ransack displays sort order indicator arrows in sort links.
    # The default may be globally overridden in an initializer file like
    # `config/initializers/ransack.rb` as follows:
    #
    # Ransack.configure do |config|
    #   # Hide sort link order indicators globally across the application
    #   config.hide_sort_order_indicators = true
    # end
    #
    def hide_sort_order_indicators=(boolean)
      self.options[:hide_sort_order_indicators] = boolean
    end

    def arel_predicate_with_suffix(arel_predicate, suffix)
      if arel_predicate === Proc
        proc { |v| "#{arel_predicate.call(v)}#{suffix}" }
      else
        "#{arel_predicate}#{suffix}"
      end
    end

  end
end
