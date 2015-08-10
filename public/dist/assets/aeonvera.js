/* jshint ignore:start */

/* jshint ignore:end */

define('aeonvera/adapters/application', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].ActiveModelAdapter.extend({
    namespace: 'api',
    host: 'http://swing.vhost:3000'
  });

});
define('aeonvera/app', ['exports', 'ember', 'ember/resolver', 'ember/load-initializers', 'aeonvera/config/environment'], function (exports, Ember, Resolver, loadInitializers, config) {

	'use strict';

	var App;

	Ember['default'].MODEL_FACTORY_INJECTIONS = true;

	App = Ember['default'].Application.extend({
		modulePrefix: config['default'].modulePrefix,
		podModulePrefix: config['default'].podModulePrefix,
		Resolver: Resolver['default']
	});

	loadInitializers['default'](App, config['default'].modulePrefix);

	exports['default'] = App;

});
define('aeonvera/components/error-field-wrapper', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    classNameBindings: ['hasError:error:no-error', 'classes'],

    hasError: (function () {
      var errors = this.get('fieldErrors');
      return errors.length > 0;
    }).property('fieldErrors'),

    fieldErrors: (function () {
      var field = this.get('field');
      return this.get('errors').get(field) || [];
    }).property('errors.[]')
  });

});
define('aeonvera/components/fixed-top-nav', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'div',
    classNames: ['fixed'],

    backLinkPath: (function () {
      if (this.get('session').isAuthenticated) {
        return 'dashboard';
      } else {
        return 'welcome';
      }
    }).property(),

    backLinkText: (function () {
      return this.t('appname');
    }).property(),

    hasLeftMobileMenu: (function () {
      return !Ember['default'].isEmpty(this.get('left'));
    }).property(),

    hasRightMobileMenu: (function () {
      return !Ember['default'].isEmpty(this.get('right'));
    }).property(),

    actions: {
      goToRoute: function goToRoute(path) {
        this.transitionTo(path);
      }
    }
  });

});
define('aeonvera/components/flash-message', ['exports', 'ember-cli-flash/components/flash-message'], function (exports, FlashMessage) {

	'use strict';

	exports['default'] = FlashMessage['default'];

});
define('aeonvera/components/how-to-pronounce-ae', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'http://english.stackexchange.com/questions/70927',
		text: 'English Stack Exchange'
	});

});
define('aeonvera/components/links/aeon-wikipedia-link', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'http://en.wikipedia.org/wiki/Aeon',
		text: 'Wikipedia'
	});

});
define('aeonvera/components/links/external-link', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({
		tagName: 'a',
		attributeBindings: ['href:href']
	});

});
define('aeonvera/components/links/facebook-icon-link', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'https://www.facebook.com/aeonvera',
		icon: 'facebook-official'
	});

});
define('aeonvera/components/links/mail-support-icon-link', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'mailto:support@aeonvera.com',
		icon: 'envelope'
	});

});
define('aeonvera/components/links/mail-support-link', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'mailto:support@aeonvera.com',
		text: 'support@aeonvera.com'
	});

});
define('aeonvera/components/login-help-modal', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({});

});
define('aeonvera/components/login-modal', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({
		initFoundation: (function () {
			this.$(document).foundation('reflow');
		}).on('didInsertElement'),

		actions: {
			authenticate: function authenticate() {
				var data = this.getProperties('identification', 'password');
				return this.session.authenticate('simple-auth-authenticator:devise', data);
			}
		}
	});

});
define('aeonvera/components/nav/dashboard/right-items', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({

    actions: {
      invalidateSession: function invalidateSession() {
        this.get('session').invalidate();
      }
    }
  });

});
define('aeonvera/components/nav/left-off-canvas-menu', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'aside',
    classNames: ['left-off-canvas-menu']
  });

});
define('aeonvera/components/nav/right-off-canvas-menu', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'aside',
    classNames: ['right-off-canvas-menu'],

    actions: {
      invalidateSession: function invalidateSession() {
        this.get('session').invalidate();
      }
    }
  });

});
define('aeonvera/components/nav/welcome/left-items', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({});

});
define('aeonvera/components/nav/welcome/right-items', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({

    actions: {
      invalidateSession: function invalidateSession() {
        this.get('session').invalidate();
      }
    }
  });

});
define('aeonvera/components/nav/welcome/top-menu', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'span'
  });

});
define('aeonvera/components/pricing-preview', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({
		didInsertElement: function didInsertElement() {
			this.send('reCalculate', 75);
			this._super();
		},

		actions: {
			reCalculate: function reCalculate(enteredValue) {
				var serviceFee = this.$('#serviceFee');
				var cardFee = this.$('#cardFee');
				var buyerPays = this.$('#buyerPays');
				var youGet = this.$('#youGet');
				var ticketPrice = this.$('#ticketPrice');
				var absorbFees = this.$('#absorbFees');

				var value = typeof enteredValue !== 'undefined' ? enteredValue : parseFloat(ticketPrice.val());

				if (isNaN(value)) {
					value = 0;
				}

				var serviceFeeValue = 0;
				var cardFeeValue = 0;
				var buyerPaysValue = 0;
				var youGetValue = 0;

				if (value > 0) {
					if (absorbFees.is(':checked')) {
						serviceFeeValue = value * 0.0075;
						cardFeeValue = value * 0.029 + 0.3;
						buyerPaysValue = value;
						youGetValue = buyerPaysValue - serviceFeeValue - cardFeeValue;
					} else {
						youGetValue = value;
						buyerPaysValue = (youGetValue + 0.3) / (1 - (0.029 + 0.0075));

						serviceFeeValue = buyerPaysValue * 0.0075;
						cardFeeValue = buyerPaysValue * 0.029 + 0.3;
					}
				}

				serviceFee.html(serviceFeeValue.toFixed(2));
				cardFee.html(cardFeeValue.toFixed(2));
				buyerPays.html(buyerPaysValue.toFixed(2));
				youGet.html(youGetValue.toFixed(2));
			}
		}

	});

});
define('aeonvera/components/sign-up-modal', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({
		initFoundation: (function () {
			this.$(document).foundation('reflow');
		}).on('didInsertElement'),

		errors: (function () {
			return this.get('model').get('errors');
		}).property('model'),

		emailClass: (function () {
			var errors = this.get('errors');
			if (errors.get('email') && errors.get('email').length > 0) {
				return 'error';
			}
			return errors.email;
		}).property('errors'),

		actions: {
			register: function register() {
				this.sendAction('action');
			}
		}
	});

});
define('aeonvera/components/tool-tip', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    attributeBindings: ["data-tooltip", "data-width", "title"],
    tagName: "span",
    classNames: ["has-tip"],
    "data-tooltip": true,
    title: Ember['default'].computed.alias("message"),

    "data-width": (function () {
      return this.get("width") || 200;
    }).property("width")

  });

});
define('aeonvera/controllers/application', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Controller.extend({
    currentUser: Ember['default'].inject.service(),

    navigation: 'fixed-top-nav',
    mobileMenuLeft: 'nav/welcome/left-items',
    mobileMenuRight: 'nav/welcome/right-items',

    init: function init() {
      var store = this.get('store');
      this.set('user', store.createRecord('user'));
    },

    actions: {
      /**
        Create new account / new user.
      */
      registerNewUser: function registerNewUser() {
        var user = this.get('user');
        var self = this;

        user.save().then(function () {
          /*
            success
            - hide the modal
            - notify of confirmation email
          */
          self.get('flashMessages').success('You will receive an email with instructions about how to confirm your account in a few minutes.');
          jQuery('#signup-modal a.close-reveal-modal').trigger('click');
        }, function () {});
      }
    }

  });

  /*
    error
    - show error messages
  */

});
define('aeonvera/controllers/login', ['exports', 'ember', 'simple-auth/mixins/login-controller-mixin'], function (exports, Ember, LoginControllerMixin) {

	'use strict';

	exports['default'] = Ember['default'].Controller.extend(LoginControllerMixin['default'], {
		authenticator: 'simple-auth-authenticator:devise'
	});

});
define('aeonvera/controllers/welcome', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Controller.extend({});

});
define('aeonvera/flash/object', ['exports', 'ember-cli-flash/flash/object'], function (exports, Flash) {

	'use strict';

	exports['default'] = Flash['default'];

});
define('aeonvera/helpers/date-range', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports.dateRange = dateRange;

  function dateRange(params /*, hash*/) {
    var startDate = params[0];
    var endDate = params[1];

    var formattedStartDate = moment(startDate).format('ll');
    var formattedEndDate = moment(endDate).format('ll');

    var range = formattedStartDate + ' - ' + formattedEndDate;

    return range;
  }

  exports['default'] = Ember['default'].HTMLBars.makeBoundHelper(dateRange);

});
define('aeonvera/helpers/date-with-format', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports.dateWithFormat = dateWithFormat;

  // for date, see http://momentjs.com/
  function dateWithFormat(params) {
    return moment(params[0]).format(params[1]);
  }

  exports['default'] = Ember['default'].HTMLBars.makeBoundHelper(dateWithFormat);

});
define('aeonvera/helpers/fa-icon', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  var FA_PREFIX = /^fa\-.+/;

  var warn = Ember['default'].Logger.warn;

  /**
   * Handlebars helper for generating HTML that renders a FontAwesome icon.
   *
   * @param  {String} name    The icon name. Note that the `fa-` prefix is optional.
   *                          For example, you can pass in either `fa-camera` or just `camera`.
   * @param  {Object} options Options passed to helper.
   * @return {Ember.Handlebars.SafeString} The HTML markup.
   */
  var faIcon = function faIcon(name, options) {
    if (Ember['default'].typeOf(name) !== 'string') {
      var message = 'fa-icon: no icon specified';
      warn(message);
      return Ember['default'].String.htmlSafe(message);
    }

    var params = options.hash,
        classNames = [],
        html = '';

    classNames.push('fa');
    if (!name.match(FA_PREFIX)) {
      name = 'fa-' + name;
    }
    classNames.push(name);
    if (params.spin) {
      classNames.push('fa-spin');
    }
    if (params.flip) {
      classNames.push('fa-flip-' + params.flip);
    }
    if (params.rotate) {
      classNames.push('fa-rotate-' + params.rotate);
    }
    if (params.lg) {
      warn('fa-icon: the \'lg\' parameter is deprecated. Use \'size\' instead. I.e. {{fa-icon size="lg"}}');
      classNames.push('fa-lg');
    }
    if (params.x) {
      warn('fa-icon: the \'x\' parameter is deprecated. Use \'size\' instead. I.e. {{fa-icon size="' + params.x + '"}}');
      classNames.push('fa-' + params.x + 'x');
    }
    if (params.size) {
      if (Ember['default'].typeOf(params.size) === 'string' && params.size.match(/\d+/)) {
        params.size = Number(params.size);
      }
      if (Ember['default'].typeOf(params.size) === 'number') {
        classNames.push('fa-' + params.size + 'x');
      } else {
        classNames.push('fa-' + params.size);
      }
    }
    if (params.fixedWidth) {
      classNames.push('fa-fw');
    }
    if (params.listItem) {
      classNames.push('fa-li');
    }
    if (params.pull) {
      classNames.push('pull-' + params.pull);
    }
    if (params.border) {
      classNames.push('fa-border');
    }
    if (params.classNames && !Ember['default'].isArray(params.classNames)) {
      params.classNames = [params.classNames];
    }
    if (!Ember['default'].isEmpty(params.classNames)) {
      Array.prototype.push.apply(classNames, params.classNames);
    }

    html += '<';
    var tagName = params.tagName || 'i';
    html += tagName;
    html += ' class=\'' + classNames.join(' ') + '\'';
    if (params.title) {
      html += ' title=\'' + params.title + '\'';
    }
    if (params.ariaHidden === undefined || params.ariaHidden) {
      html += ' aria-hidden="true"';
    }
    html += '></' + tagName + '>';
    return Ember['default'].String.htmlSafe(html);
  };

  exports['default'] = Ember['default'].Handlebars.makeBoundHelper(faIcon);

  exports.faIcon = faIcon;

});
define('aeonvera/helpers/submit-idea-link', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports.submitIdeaLink = submitIdeaLink;

  function submitIdeaLink() {
    var t = this.container.lookup('utils:t');

    var url = 'https://github.com/NullVoxPopuli/aeonvera/issues?state=open';
    var text = t('submitideas');

    var anchor = '<a href="' + url + '">' + text + '</a>';
    return Ember['default'].String.htmlSafe(anchor);
  }

  exports['default'] = Ember['default'].HTMLBars.makeBoundHelper(submitIdeaLink);

});
define('aeonvera/helpers/t', ['exports', 'ember-cli-i18n/utils/stream'], function (exports, Stream) {

  'use strict';



  exports['default'] = tHelper;
  function tHelper(params, hash, options, env) {
    var view = env.data.view;
    var path = params.shift();

    var container = view.container;
    var t = container.lookup('utils:t');
    var application = container.lookup('application:main');

    var stream = new Stream['default'](function () {
      return t(path, params);
    });

    // bind any arguments that are Streams
    for (var i = 0, l = params.length; i < l; i++) {
      var param = params[i];
      if (param && param.isStream) {
        param.subscribe(stream.notify, stream);
      };
    }

    application.localeStream.subscribe(stream.notify, stream);

    if (path.isStream) {
      path.subscribe(stream.notify, stream);
    }

    return stream;
  }

});
define('aeonvera/initializers/app-version', ['exports', 'aeonvera/config/environment', 'ember'], function (exports, config, Ember) {

  'use strict';

  var classify = Ember['default'].String.classify;
  var registered = false;

  exports['default'] = {
    name: 'App Version',
    initialize: function initialize(container, application) {
      if (!registered) {
        var appName = classify(application.toString());
        Ember['default'].libraries.register(appName, config['default'].APP.version);
        registered = true;
      }
    }
  };

});
define('aeonvera/initializers/export-application-global', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, config) {

  'use strict';

  exports.initialize = initialize;

  function initialize(container, application) {
    var classifiedName = Ember['default'].String.classify(config['default'].modulePrefix);

    if (config['default'].exportApplicationGlobal && !window[classifiedName]) {
      window[classifiedName] = application;
    }
  }

  ;

  exports['default'] = {
    name: 'export-application-global',

    initialize: initialize
  };

});
define('aeonvera/initializers/flash-messages-service', ['exports', 'ember-cli-flash/services/flash-messages-service', 'aeonvera/config/environment'], function (exports, FlashMessagesService, config) {

  'use strict';

  exports.initialize = initialize;

  function initialize(_container, application) {
    var flashMessageDefaults = config['default'].flashMessageDefaults;
    var injectionFactories = flashMessageDefaults.injectionFactories;

    application.register('config:flash-messages', flashMessageDefaults, { instantiate: false });
    application.register('service:flash-messages', FlashMessagesService['default'], { singleton: true });
    application.inject('service:flash-messages', 'flashMessageDefaults', 'config:flash-messages');

    injectionFactories.forEach(function (factory) {
      application.inject(factory, 'flashMessages', 'service:flash-messages');
    });
  }

  exports['default'] = {
    name: 'flash-messages-service',
    initialize: initialize
  };

});
define('aeonvera/initializers/link-to-with-action', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  var alreadyRun = false;

  exports['default'] = {
    name: 'link-to-with-action',
    initialize: function initialize() {
      if (alreadyRun) {
        return;
      } else {
        alreadyRun = true;
      }

      // http://stackoverflow.com/questions/16124381/combine-linkto-and-action-helpers-in-ember-js

      Ember['default'].LinkView.reopen({
        action: null,
        _invoke: function _invoke(event) {
          var action = this.get('action');
          if (action) {
            // There was an action specified (in handlebars) so take custom action
            event.preventDefault(); // prevent the browser from following the link as normal
            if (this.bubbles === false) {
              event.stopPropagation();
            }

            // trigger the action on the controller
            this.get('controller').send(action, this.get('actionParam'));
            return false;
          }

          // handle the link-to normally
          return this._super(event);
        }
      });
    }
  };

});
define('aeonvera/initializers/simple-auth-devise-override', ['exports', 'ember', 'simple-auth-devise/authenticators/devise'], function (exports, Ember, Devise) {

  'use strict';

  var alreadyRun = false;

  exports['default'] = {
    name: 'simple-auth-devise-override',

    initialize: function initialize() {
      if (alreadyRun) {
        return;
      } else {
        alreadyRun = true;
      }

      Devise['default'].reopen({
        invalidate: function invalidate() {
          var self = this;

          /*
            this is required until server-side sessions are disabled
          */
          return Ember['default'].$.ajax({
            url: '/users/sign_out',
            type: 'DELETE'
          }).then(function () {
            return self._super();
          });
        }
      });
    }
  };

});
define('aeonvera/initializers/simple-auth-devise', ['exports', 'simple-auth-devise/configuration', 'simple-auth-devise/authenticators/devise', 'simple-auth-devise/authorizers/devise', 'aeonvera/config/environment'], function (exports, Configuration, Authenticator, Authorizer, ENV) {

  'use strict';

  exports['default'] = {
    name: 'simple-auth-devise',
    before: 'simple-auth',
    initialize: function initialize(container, application) {
      Configuration['default'].load(container, ENV['default']['simple-auth-devise'] || {});
      container.register('simple-auth-authorizer:devise', Authorizer['default']);
      container.register('simple-auth-authenticator:devise', Authenticator['default']);
    }
  };

});
define('aeonvera/initializers/simple-auth', ['exports', 'simple-auth/configuration', 'simple-auth/setup', 'aeonvera/config/environment'], function (exports, Configuration, setup, ENV) {

  'use strict';

  exports['default'] = {
    name: 'simple-auth',
    initialize: function initialize(container, application) {
      Configuration['default'].load(container, ENV['default']['simple-auth'] || {});
      setup['default'](container, application);
    }
  };

});
define('aeonvera/initializers/subdomain', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, ENV) {

  'use strict';

  var urlChecker = Ember['default'].Object.extend({

    subdomain: (function () {
      var regexParse = new RegExp('[a-z-0-9]{2,63}.[a-z.]{2,5}$');
      var urlParts = regexParse.exec(this.get('hostname'));
      if (urlParts) return this.normalize(this.get('hostname').replace(urlParts[0], '').slice(0, -1));else return this.normalize('');
    }).property('hostname'),

    hostname: (function () {
      if (this.get('customURI')) {
        return this.get('customURI');
      } else {
        return window.location.hostname;
      }
    }).property('customURI'),

    normalize: function normalize(subdomain) {
      return ENV['default'].subdomainMapping[subdomain] || subdomain;
    },

    customURI: '' });

  exports['default'] = {
    name: 'subdomain',
    initialize: function initialize(container, application) {
      container.register('url-checker:main', urlChecker);
      application.inject('route', 'urlChecker', 'url-checker:main');
      application.inject('controller', 'urlChecker', 'url-checker:main');
    },
    urlChecker: urlChecker
  };

});
define('aeonvera/initializers/t', ['exports', 'ember', 'ember-cli-i18n/utils/t', 'aeonvera/helpers/t', 'ember-cli-i18n/utils/stream'], function (exports, Ember, T, tHelper, Stream) {

  'use strict';

  exports.initialize = initialize;

  function initialize(container, application) {
    Ember['default'].HTMLBars._registerHelper('t', tHelper['default']);

    application.localeStream = new Stream['default'](function () {
      return application.get('locale');
    });

    Ember['default'].addObserver(application, 'locale', function () {
      application.localeStream.notify();
    });

    application.register('utils:t', T['default']);
    application.inject('route', 't', 'utils:t');
    application.inject('model', 't', 'utils:t');
    application.inject('component', 't', 'utils:t');
    application.inject('controller', 't', 'utils:t');
  }

  ;

  exports['default'] = {
    name: 't',
    initialize: initialize
  };

});
define('aeonvera/locales/en', ['exports'], function (exports) {

  'use strict';

  /*jshint multistr: true */

  exports['default'] = {
    appname: 'ÆONVERA',
    holdingcompany: 'Precognition, LLC',
    subheader: 'Event registration designed for dancers.',
    lookingforevent: 'Looking for an event?',
    hostinganevent: 'Hosting an event?',
    createyourevent: 'Create Your Event',
    lookingforscene: 'Looking for a scene?',
    whatisheader: 'What is ÆONVERA?',
    whatis: 'It is a system that helps event and scene organizers manage their events, lessons, and dances.     It helps scenes manage memberships and benefits.     It helps event organizers more easily manage their event both before and during the event.     It is constantly growing and responding to the community and doing everything it can to make the lives of organizers easier.     For more information on "how", checkout the features page.',

    features: 'Features',
    pricing: 'Pricing',
    faq: 'F.A.Q.',
    faqfull: 'Frequently Asked Questions',
    opensource: 'OpenSource',
    dashboard: 'Dashboard',
    attendedevents: 'Attended Events',
    upcomingevents: 'Upcoming Events',
    communities: 'Communities',
    aboutSummary: 'About',

    featuresinfo: 'List of current and upcoming features and possible explanations of each.     ÆONVERA is written by, and is for Swing Dancers.',
    pricinginfo: 'Overview of pricing.     The most important thing to note is that if your event dosn\'t have a need     for collecting payments electronically, you can use ÆONVERA for free.     Every feature.',
    faqinfo: 'Questions that are frequently asked as well as ones that might be     thought, but not spoken.',

    tos: 'Terms of Service',
    privacy: 'Privacy',
    submitideas: 'Submit Ideas',
    copyright: 'Copyright © 2013-2015 Precognition LLC',

    formoreinfo: 'For more information: ',

    buttons: {
      login: 'Login',
      signup: 'Sign Up',
      eventcalendar: 'Event Calendar',
      createyourevent: 'Create Your Event',
      scenesbycity: 'Scenes By City'
    },

    faqtext: {
      questions: {
        howhelp: 'How do I get help?',
        whystripe: 'Why Stripe?',
        pricecompare: 'How do your prices compare to other event registration sites?',
        name: 'How did ÆONVERA get its name?',
        pronounce: 'How do you pronounce "ÆONVERA"?',
        butthis: 'Your system is great, but I want to use this other one.',
        idea: 'I have an idea, will you please implement it?'
      },
      answers: {
        howhelp: 'If you have general question about ÆONVERA, you can contact Preston         by clicking the email / envelope icon at the bottom of every page. If you         have a question about a particular event, it would be more efficient to         contact the event organizers.',
        idea: 'Possibly. At the bottom of every page, you\'ll see a "Submit Ideas"         link. Feel free to click that and submit an "issue" on GitHub. If your         idea can meet the needs of the many, it\'ll get done. Exact timeline         cannot be known unless it\'s really urgent - like a bug or something.',
        butthis: 'That\'s fine. Free will and such.',
        whystripe: '',
        pricecompare: '',
        name: 'Names can mean a lot - they can also mean nothing. The owner of ÆONVERA         spent numerous days looking up various prefixes and suffixes to stitch together.         Eventually he decided to use a sort of exotic, yet ancient word ÆON - meaning "life".         ÆON is a good word just by itself and has a nice ring to it, especially when pronounced         with a long "a" sound instead of a typical "e" sound. But the owner felt that there         needed to be a suffix. Eventually VERA, meaning "true", was chosen so mean that ÆONVERA         is true to life, true to its promises, and true to its mission to help guide organizers         and attempt to relieve the stress that comes from organizing and mananging attendees.',
        pronounce: 'The "Æ" letter, in Modern English does not have an agreed         upon pronunciation. Some people pronounce it as "ee", like in "eon",        some pronounce it as "eh", as in "esophagus".          The creator of ÆONVERA pronounces it as a long "a" sound like in "ape".        "Vera" is pronounced like in         Aloe Vera. No tricks on that one.'
      }
    }
  };

});
define('aeonvera/models/attended-event', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({
		name: DS['default'].attr('string'),
		registeredAt: DS['default'].attr('date'),
		amount_owed: DS['default'].attr('number'),
		amount_paid: DS['default'].attr('number'),
		eventBeginsAt: DS['default'].attr('date'),
		isAttending: DS['default'].attr('boolean'),

		registrationStatus: (function () {
			if (this.get('isAttending')) {
				return 'Attending';
			} else {
				return 'Not Attending';
			}
		}).property('isAttending')

	});

});
define('aeonvera/models/community', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string'),
    tagline: DS['default'].attr('string'),

    city: DS['default'].attr('string'),
    state: DS['default'].attr('string'),

    beta: DS['default'].attr('boolean'),
    make_attendees_pay_fees: DS['default'].attr('boolean'),

    logo_file_name: DS['default'].attr('string'),
    logo_file_size: DS['default'].attr('number'),
    logo_updated_at: DS['default'].attr('date'),
    logo_url: DS['default'].attr('string'),
    logo_url_thumb: DS['default'].attr('string'),
    logo_url_medium: DS['default'].attr('string'),

    url: DS['default'].attr('string'),

    owner: DS['default'].belongsTo('user'),

    location: (function () {
      return this.get('city') + ', ' + this.get('state');
    }).property('city', 'state'),

    logo_is_missing: (function () {
      return this.get('logo_url').indexOf('missing') !== -1;
    }).property('logo_url')
  });

});
define('aeonvera/models/competition', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({});

});
define('aeonvera/models/event', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({
		name: DS['default'].attr('string'),
		beginsAt: DS['default'].attr('date'),
		endsAt: DS['default'].attr('date'),

		packages: DS['default'].hasMany('package'),
		levels: DS['default'].hasMany('level'),
		competitions: DS['default'].hasMany('competitions')
	});

});
define('aeonvera/models/level', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({});

});
define('aeonvera/models/package', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({});

});
define('aeonvera/models/upcoming-event', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string'),
    registrationOpensAt: DS['default'].attr('date'),
    startsAt: DS['default'].attr('date'),
    endsAt: DS['default'].attr('date'),
    location: DS['default'].attr('string'),
    url: DS['default'].attr('string'),

    isRegistrationOpen: (function () {
      var opensAt = this.get('registrationOpensAt').getTime();
      var now = Date.now;
      return now > opensAt;
    }).property('registrationOpensAt')
  });

});
define('aeonvera/models/user', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    firstName: DS['default'].attr('string'),
    lastName: DS['default'].attr('string'),
    email: DS['default'].attr('string'),
    password: DS['default'].attr('string'),
    passwordConfirmation: DS['default'].attr('string')
  });

});
define('aeonvera/router', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, config) {

  'use strict';

  var Router = Ember['default'].Router.extend({
    location: config['default'].locationType
  });

  exports['default'] = Router.map(function () {
    this.route('login');
    this.route('signup');
    this.resource('welcome', function () {
      this.route('features');
      this.route('pricing');
      this.route('faq');
      this.route('tos', function () {
        this.route('organizers');
        this.route('non-organizers');
        this.route('updates');
      });
      this.route('opensource');
      this.route('privacy');
      this.route('about');
    });
    this.resource('events', function () {});

    this.resource('dashboard', {
      path: '/'
    }, function () {});

    this.route('register', {
      path: 'r'
    }, function () {
      this.route('level');
      this.route('packages');
    });

    this.route('upcoming-events');
    this.route('attended-events');
    this.route('communities');
  });

});
define('aeonvera/routes/application', ['exports', 'ember', 'simple-auth/mixins/application-route-mixin'], function (exports, Ember, ApplicationRouteMixin) {

	'use strict';

	exports['default'] = Ember['default'].Route.extend(ApplicationRouteMixin['default'], {
		currentUser: Ember['default'].inject.service(),

		// http://stackoverflow.com/questions/12150624/ember-js-multiple-named-outlet-usage
		renderTemplate: function renderTemplate() {

			// Render default outlet
			this.render();

			// render footer
			this.render('shared/footer', {
				outlet: 'bottom-footer',
				into: 'application'
			});
		},

		actions: {
			linkToRoute: function linkToRoute(item) {
				this.transitionTo(item.route);
			},

			exitOffCanvas: function exitOffCanvas() {
				this.$('a.exit-off-canvas').click();
			},

			redirectToLogin: function redirectToLogin() {
				this.transitionTo('login');
			},

			redirectToSignup: function redirectToSignup() {
				this.transitionTo('signup');
			},

			invalidateSession: function invalidateSession() {
				this.get('session').invalidate();
			},

			sessionAuthenticationSucceeded: function sessionAuthenticationSucceeded() {
				jQuery('a.close-reveal-modal').trigger('click');
				this.transitionTo('dashboard');
				Ember['default'].get(this, 'flashMessages').success('You have successfully logged in');
			},

			sessionAuthenticationFailed: function sessionAuthenticationFailed(error) {
				Ember['default'].get(this, 'flashMessages').warning(error.error || error);
			},

			signup: function signup() {} }
	});

});
define('aeonvera/routes/attended-events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    activate: function activate() {
      this.set('title', this.t('attendedevents'));

      this.controllerFor('application').set('mobileMenuLeft', 'nav/dashboard/left-items');

      this._super();
    },

    model: function model() {
      return this.store.findAll('attended-event');
    },

    eventsPresent: function eventsPresent() {
      return this.get('model').length > 0;
    }
  });

});
define('aeonvera/routes/communities', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    activate: function activate() {
      this.set('title', this.t('communities'));

      var application = this.controllerFor('application');
      application.set('mobileMenuLeft', 'nav/dashboard/left-items');
      application.set('mobileMenuRight', 'nav/dashboard/right-items');

      this._super();
    },

    model: function model() {
      return this.store.findAll('community');
    }
  });

});
define('aeonvera/routes/dashboard', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    activate: function activate() {
      this.set('title', this.t('dashboard'));

      var application = this.controllerFor('application');
      application.set('mobileMenuLeft', 'nav/dashboard/left-items');
      application.set('mobileMenuRight', 'nav/dashboard/right-items');

      this._super();
    },

    /**
    	Redirect to the welcome route if not logged in.
    */
    beforeModel: function beforeModel(transition) {
      if (!this.get('session').isAuthenticated) {
        transition.abort();

        // don't show this message, as people just navigating to
        // aeonvera.com would see it.
        // but we want the dashboard to be the default URL
        // Ember.get(this, 'flashMessages').warning(
        // 'You must be logged in to view the dashboard');

        this.transitionTo('welcome');
      }
    },

    model: function model() {
      return this.store.findAll('attended-event');
    }

  });

});
define('aeonvera/routes/events', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Route.extend({});

});
define('aeonvera/routes/login', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    authenticate: function authenticate() {
      var data = this.getProperties('identification', 'password');
      return this.get('session').authenticate('simple-auth-authenticator:devise', data);
    }
  });

});
define('aeonvera/routes/register', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    model: function model() {
      return this.store.find('current-registering-event');
    }

  });

});
define('aeonvera/routes/upcoming-events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    activate: function activate() {
      this.set('title', this.t('upcomingevents'));

      var application = this.controllerFor('application');
      application.set('mobileMenuLeft', 'nav/dashboard/left-items');
      application.set('mobileMenuRight', 'nav/dashboard/right-items');

      this._super();
    },

    model: function model() {
      return this.store.findAll('upcoming-event');
    }
  });

});
define('aeonvera/routes/welcome', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    activate: function activate() {
      this.set('title', this.t('appname'));
      this._super();
    }
  });

});
define('aeonvera/services/current-registering-object', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Service.extend({});

});
define('aeonvera/services/current-user', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Service.extend({});

});
define('aeonvera/services/flash-messages-service', ['exports', 'ember-cli-flash/services/flash-messages-service'], function (exports, FlashMessagesService) {

	'use strict';

	exports['default'] = FlashMessagesService['default'];

});
define('aeonvera/templates/application', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "flash-message", [], {"flash": get(env, context, "flash"), "messageStyle": "foundation"});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"data-offcanvas","true");
        dom.setAttribute(el1,"class","off-canvas-wrap");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","inner-wrap");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"class","exit-off-canvas");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("section");
        dom.setAttribute(el3,"class","main-section");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","shell");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","inner-shell");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, inline = hooks.inline, content = hooks.content, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [4]);
        var element2 = dom.childAt(element1, [3, 0]);
        var element3 = dom.childAt(element2, [0]);
        var morph0 = dom.createMorphAt(element0,0,0);
        var morph1 = dom.createMorphAt(element0,1,1);
        var morph2 = dom.createMorphAt(element0,2,2);
        var morph3 = dom.createMorphAt(element0,3,3);
        var morph4 = dom.createMorphAt(element1,1,1);
        var morph5 = dom.createMorphAt(element1,2,2);
        var morph6 = dom.createMorphAt(element3,0,0);
        var morph7 = dom.createMorphAt(element3,1,1);
        var morph8 = dom.createMorphAt(element2,1,1);
        var morph9 = dom.createMorphAt(element1,4,4);
        inline(env, morph0, context, "component", [get(env, context, "navigation")], {"left": get(env, context, "mobileMenuLeft"), "right": get(env, context, "mobileMenuRight")});
        content(env, morph1, context, "login-modal");
        content(env, morph2, context, "login-help-modal");
        inline(env, morph3, context, "sign-up-modal", [], {"action": "registerNewUser", "model": get(env, context, "user")});
        inline(env, morph4, context, "nav/left-off-canvas-menu", [], {"items": get(env, context, "mobileMenuLeft")});
        inline(env, morph5, context, "nav/right-off-canvas-menu", [], {"items": get(env, context, "mobileMenuRight")});
        block(env, morph6, context, "each", [get(env, context, "flashMessages.queue")], {"keyword": "flash"}, child0, null);
        content(env, morph7, context, "outlet");
        inline(env, morph8, context, "outlet", ["bottom-footer"], {});
        inline(env, morph9, context, "outlet", ["fixed-footer"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/attended-events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("tr");
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, content = hooks.content, get = hooks.get, inline = hooks.inline;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var element0 = dom.childAt(fragment, [0]);
            var morph0 = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
            var morph1 = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
            var morph2 = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
            var morph3 = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
            var morph4 = dom.createMorphAt(dom.childAt(element0, [4]),0,0);
            var morph5 = dom.createMorphAt(dom.childAt(element0, [5]),0,0);
            content(env, morph0, context, "event.name");
            inline(env, morph1, context, "date-with-format", [get(env, context, "event.registeredAt"), "LLL"], {});
            content(env, morph2, context, "event.amount_owed");
            content(env, morph3, context, "event.amount_paid");
            inline(env, morph4, context, "date-with-format", [get(env, context, "event.eventBeginsAt"), "LLL"], {});
            content(env, morph5, context, "event.registrationStatus");
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          block(env, morph0, context, "each", [get(env, context, "model")], {"keyword": "event"}, child0, null);
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("tr");
          var el2 = dom.createElement("td");
          dom.setAttribute(el2,"colspan","6");
          var el3 = dom.createElement("span");
          var el4 = dom.createTextNode("You have not yet attended any events. Please view the upcoming events list to see if there is anything of interest.");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h2");
        dom.setAttribute(el1,"class","page-title");
        var el2 = dom.createTextNode("Your Attended Events");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("table");
        var el2 = dom.createElement("thead");
        var el3 = dom.createElement("tr");
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Name");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Date Registered");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Owed");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Paid");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Event Begins");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Registration Status");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [1]),1,1);
        block(env, morph0, context, "if", [get(env, context, "eventsPresent")], {}, child0, child1);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/communities', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("span");
            dom.setAttribute(el1,"class","icon-thumbnail right");
            var el2 = dom.createComment("");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, inline = hooks.inline;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
            inline(env, morph0, context, "fa-icon", ["globe"], {});
            return fragment;
          }
        };
      }());
      var child1 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("img");
            dom.setAttribute(el1,"class","right");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, get = hooks.get, concat = hooks.concat, attribute = hooks.attribute;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var element0 = dom.childAt(fragment, [0]);
            var attrMorph0 = dom.createAttrMorph(element0, 'src');
            attribute(env, attrMorph0, element0, "src", concat(env, [get(env, context, "community.logo_url_thumb")]));
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          var el2 = dom.createElement("div");
          dom.setAttribute(el2,"class","row");
          var el3 = dom.createElement("div");
          dom.setAttribute(el3,"class","columns small-2 medium-4");
          var el4 = dom.createComment("");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("div");
          dom.setAttribute(el3,"class","columns small-10 medium-8");
          var el4 = dom.createElement("h3");
          var el5 = dom.createComment("");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          var el4 = dom.createElement("h6");
          var el5 = dom.createComment("");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, concat = hooks.concat, attribute = hooks.attribute, block = hooks.block, content = hooks.content;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element1 = dom.childAt(fragment, [0]);
          var element2 = dom.childAt(element1, [0]);
          var element3 = dom.childAt(element2, [1]);
          var attrMorph0 = dom.createAttrMorph(element1, 'href');
          var morph0 = dom.createMorphAt(dom.childAt(element2, [0]),0,0);
          var morph1 = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
          var morph2 = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
          attribute(env, attrMorph0, element1, "href", concat(env, [get(env, context, "community.url")]));
          block(env, morph0, context, "if", [get(env, context, "community.logo_is_missing")], {}, child0, child1);
          content(env, morph1, context, "community.name");
          content(env, morph2, context, "community.location");
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createElement("h2");
        dom.setAttribute(el2,"class","page-title");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","center-margin percent-width-80");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        inline(env, morph0, context, "t", ["communities"], {});
        block(env, morph1, context, "each", [get(env, context, "model")], {"keyword": "community"}, child0, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/error-field-wrapper', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, content = hooks.content;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, null);
            dom.insertBoundary(fragment, 0);
            content(env, morph0, context, "error.message");
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          dom.setAttribute(el1,"class","error");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          block(env, morph0, context, "each", [get(env, context, "fieldErrors")], {"keyword": "error"}, child0, null);
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, content = hooks.content, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        var morph1 = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, null);
        dom.insertBoundary(fragment, 0);
        content(env, morph0, context, "yield");
        block(env, morph1, context, "if", [get(env, context, "hasError")], {}, child0, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/fixed-top-nav', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("section");
          dom.setAttribute(el1,"class","left-small show-for-small");
          var el2 = dom.createElement("a");
          dom.setAttribute(el2,"class","left-off-canvas-toggle menu-icon");
          var el3 = dom.createElement("span");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "fa-icon", ["angle-left"], {});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, content = hooks.content;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          content(env, morph0, context, "backLinkText");
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("section");
          dom.setAttribute(el1,"class","right-small show-for-small");
          var el2 = dom.createElement("a");
          dom.setAttribute(el2,"class","right-off-canvas-toggle menu-icon");
          var el3 = dom.createElement("span");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, content = hooks.content;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          content(env, morph0, context, "backLinkText");
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("nav");
        dom.setAttribute(el1,"data-options","is_hover:false");
        dom.setAttribute(el1,"role","navigation");
        dom.setAttribute(el1,"data-topbar","");
        dom.setAttribute(el1,"class","top-bar tab-bar");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("section");
        dom.setAttribute(el2,"class","middle tab-bar-section show-for-small");
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","left");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("h3");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","title-area");
        var el4 = dom.createElement("li");
        dom.setAttribute(el4,"class","name");
        var el5 = dom.createElement("h1");
        dom.setAttribute(el5,"class","title");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("ul");
        dom.setAttribute(el2,"class","title-area hide-for-small");
        var el3 = dom.createElement("li");
        dom.setAttribute(el3,"class","name");
        var el4 = dom.createElement("h1");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("section");
        dom.setAttribute(el2,"class","left top-bar-section hide-for-small");
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","pages");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("section");
        dom.setAttribute(el2,"class","top-bar-section hide-for-small");
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","right auth");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [1]);
        var morph0 = dom.createMorphAt(element0,0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element1, [0, 0, 0]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element1, [1, 0, 0]),0,0);
        var morph3 = dom.createMorphAt(element1,2,2);
        var morph4 = dom.createMorphAt(dom.childAt(element0, [2, 0, 0]),0,0);
        var morph5 = dom.createMorphAt(dom.childAt(element0, [3, 0]),0,0);
        var morph6 = dom.createMorphAt(dom.childAt(element0, [4, 0]),0,0);
        block(env, morph0, context, "if", [get(env, context, "hasLeftMobileMenu")], {}, child0, null);
        block(env, morph1, context, "link-to", [get(env, context, "backLinkPath")], {}, child1, null);
        block(env, morph2, context, "link-to", [get(env, context, "backLinkPath")], {}, child2, null);
        block(env, morph3, context, "if", [get(env, context, "hasRightMobileMenu")], {}, child3, null);
        block(env, morph4, context, "link-to", [get(env, context, "backLinkPath")], {}, child4, null);
        inline(env, morph5, context, "component", [get(env, context, "left")], {});
        inline(env, morph6, context, "component", [get(env, context, "right")], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/flash-message', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,1,1,contextualElement);
          inline(env, morph0, context, "yield", [get(env, context, "this"), get(env, context, "flash")], {});
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createTextNode("    ");
            dom.appendChild(el0, el1);
            var el1 = dom.createElement("div");
            dom.setAttribute(el1,"class","alert-progress");
            var el2 = dom.createTextNode("\n      ");
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("div");
            dom.setAttribute(el2,"class","alert-progressBar");
            dom.appendChild(el1, el2);
            var el2 = dom.createTextNode("\n    ");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            var el1 = dom.createTextNode("\n");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, get = hooks.get, attribute = hooks.attribute;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var element0 = dom.childAt(fragment, [1, 1]);
            var attrMorph0 = dom.createAttrMorph(element0, 'style');
            attribute(env, attrMorph0, element0, "style", get(env, context, "progressDuration"));
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, content = hooks.content, get = hooks.get, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,1,1,contextualElement);
          var morph1 = dom.createMorphAt(fragment,3,3,contextualElement);
          dom.insertBoundary(fragment, null);
          content(env, morph0, context, "flash.message");
          block(env, morph1, context, "if", [get(env, context, "showProgressBar")], {}, child0, null);
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, null);
        dom.insertBoundary(fragment, 0);
        block(env, morph0, context, "if", [get(env, context, "hasBlock")], {}, child0, child1);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/links/external-link', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,1,1,contextualElement);
          inline(env, morph0, context, "fa-icon", [get(env, context, "icon")], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        var morph1 = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, 0);
        block(env, morph0, context, "if", [get(env, context, "icon")], {}, child0, null);
        content(env, morph1, context, "text");
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/login-help-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"id","login-help-modal");
        dom.setAttribute(el1,"data-reveal","true");
        dom.setAttribute(el1,"aria-labledby","login-help-modal-title");
        dom.setAttribute(el1,"aria-hidden","true");
        dom.setAttribute(el1,"role","dialog");
        dom.setAttribute(el1,"class","reveal-modal medium");
        var el2 = dom.createElement("h2");
        dom.setAttribute(el2,"id","login-help-modal-title");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createTextNode("Login Help");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("p");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","/users/password/new");
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("Forgot your password?");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","/users/confirmation/new");
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("Didn't receive confirmation email?");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","/users/unlock/new");
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("Didn't receive unlock email?");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("p");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","button-group text-center left");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("a");
        dom.setAttribute(el5,"href","#");
        dom.setAttribute(el5,"data-reveal-id","login-modal");
        dom.setAttribute(el5,"class","button");
        var el6 = dom.createTextNode("Back");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"aria-label","Close");
        dom.setAttribute(el2,"class","close-reveal-modal");
        var el3 = dom.createTextNode("×");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/login-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"id","login-modal");
        dom.setAttribute(el1,"data-reveal","true");
        dom.setAttribute(el1,"aria-labledby","login-modal-title");
        dom.setAttribute(el1,"aria-hidden","true");
        dom.setAttribute(el1,"role","dialog");
        dom.setAttribute(el1,"class","reveal-modal medium");
        var el2 = dom.createElement("h2");
        dom.setAttribute(el2,"id","login-modal-title");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createTextNode("Login");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("p");
        var el3 = dom.createElement("form");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row collapse");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","small-3 large-2 columns");
        var el6 = dom.createElement("span");
        dom.setAttribute(el6,"class","prefix");
        var el7 = dom.createTextNode("Email");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","small-9 large-10 columns");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row collapse");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","small-3 large-2 columns");
        var el6 = dom.createElement("span");
        dom.setAttribute(el6,"class","prefix");
        var el7 = dom.createTextNode("Password");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","small-9 large-10 columns");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("br");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("ul");
        dom.setAttribute(el4,"class","button-group text-center right");
        var el5 = dom.createElement("li");
        var el6 = dom.createElement("a");
        dom.setAttribute(el6,"href","#");
        dom.setAttribute(el6,"data-reveal-id","signup-modal");
        dom.setAttribute(el6,"class","button");
        var el7 = dom.createTextNode("Sign Up");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("li");
        var el6 = dom.createElement("button");
        dom.setAttribute(el6,"type","submit");
        var el7 = dom.createTextNode("Login");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","#");
        dom.setAttribute(el4,"data-reveal-id","login-help-modal");
        dom.setAttribute(el4,"class","button");
        var el5 = dom.createTextNode("Help");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("ul");
        dom.setAttribute(el4,"data-accordion","true");
        dom.setAttribute(el4,"class","no-margins accordion");
        var el5 = dom.createElement("li");
        dom.setAttribute(el5,"class","accordion-navigation");
        var el6 = dom.createElement("a");
        dom.setAttribute(el6,"href","#login-help-why");
        var el7 = dom.createTextNode("Why do I need to make an account?");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"id","login-help-why");
        dom.setAttribute(el6,"class","content");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("It helps the event organizers know who you are, and enables them to get in contact with you. It also saves you from repeating information on other events on this site and enables you to track your registration and payment history.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("li");
        dom.setAttribute(el5,"class","accordion-navigation");
        var el6 = dom.createElement("a");
        dom.setAttribute(el6,"href","#login-help-secure");
        var el7 = dom.createTextNode("Are my credentials secure?");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"id","login-help-secure");
        dom.setAttribute(el6,"class","content");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Yes. All communication is sent over a secure connection to the server, and at no point does aeonvera actually know what your password is. The database stores passwords as hashes, so there is no way to unencrypt your password.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"aria-label","Close");
        dom.setAttribute(el3,"class","close-reveal-modal");
        var el4 = dom.createTextNode("×");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, element = hooks.element, get = hooks.get, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 2, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0, 1]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1, 1]),0,0);
        element(env, element0, context, "action", ["authenticate"], {"on": "submit"});
        inline(env, morph0, context, "input", [], {"value": get(env, context, "identification"), "placeholder": "yourname@domain.com", "type": "text"});
        inline(env, morph1, context, "input", [], {"value": get(env, context, "password"), "placeholder": "Something secure and easy to remember", "type": "password"});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/dashboard/left-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Home");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        block(env, morph0, context, "link-to", ["application"], {}, child0, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/dashboard/right-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          inline(env, morph0, context, "t", ["upcomingevents"], {});
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          inline(env, morph0, context, "t", ["communities"], {});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          dom.setAttribute(el1,"class","button");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Logout");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, element = hooks.element, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element1 = dom.childAt(fragment, [0]);
          var morph0 = dom.createMorphAt(element1,0,0);
          element(env, element1, context, "action", ["invalidateSession"], {"on": "click"});
          inline(env, morph0, context, "fa-icon", ["sign-out"], {});
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          var morph1 = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "fa-icon", ["info-circle"], {});
          inline(env, morph1, context, "t", ["aboutSummary"], {});
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Logout");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, element = hooks.element, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element0 = dom.childAt(fragment, [0]);
          var morph0 = dom.createMorphAt(element0,0,0);
          element(env, element0, context, "action", ["invalidateSession"], {"on": "click"});
          inline(env, morph0, context, "fa-icon", ["sign-out"], {});
          return fragment;
        }
      };
    }());
    var child5 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          var morph1 = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "fa-icon", ["info-circle"], {});
          inline(env, morph1, context, "t", ["aboutSummary"], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","page");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","page");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","hide-for-small");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","/hosted_events/new");
        dom.setAttribute(el2,"class","button");
        var el3 = dom.createTextNode("Host an Event");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small page");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","has-dropdown hide-for-small");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","javascript:void(0);");
        dom.setAttribute(el2,"class","cog");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("ul");
        dom.setAttribute(el2,"class","dropdown");
        var el3 = dom.createElement("li");
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","/user/edit");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Edit Profile");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        dom.setAttribute(el3,"class","divider");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, block = hooks.block, get = hooks.get, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element2 = dom.childAt(fragment, [7]);
        var element3 = dom.childAt(element2, [1]);
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(fragment, [5]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(fragment, [6]),0,0);
        var morph4 = dom.createMorphAt(dom.childAt(element2, [0]),1,1);
        var morph5 = dom.createMorphAt(dom.childAt(element3, [0, 0]),0,0);
        var morph6 = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
        var morph7 = dom.createMorphAt(dom.childAt(element3, [3]),0,0);
        block(env, morph0, context, "link-to", ["upcoming-events"], {}, child0, null);
        block(env, morph1, context, "link-to", ["communities"], {}, child1, null);
        block(env, morph2, context, "if", [get(env, context, "session.isAuthenticated")], {}, child2, null);
        block(env, morph3, context, "link-to", ["welcome.about"], {}, child3, null);
        inline(env, morph4, context, "fa-icon", ["cog"], {});
        inline(env, morph5, context, "fa-icon", ["pencil"], {});
        block(env, morph6, context, "if", [get(env, context, "session.isAuthenticated")], {}, child4, null);
        block(env, morph7, context, "link-to", ["welcome.about"], {}, child5, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/left-off-canvas-menu', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("ul");
        dom.setAttribute(el1,"class","off-canvas-list");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        inline(env, morph0, context, "component", [get(env, context, "items")], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/right-off-canvas-menu', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("ul");
        dom.setAttribute(el1,"class","off-canvas-list");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        inline(env, morph0, context, "component", [get(env, context, "items")], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/welcome/left-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Home");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["features"], {});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["pricing"], {});
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["faq"], {});
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["opensource"], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(fragment, [3]),0,0);
        var morph4 = dom.createMorphAt(dom.childAt(fragment, [4]),0,0);
        block(env, morph0, context, "link-to", ["application"], {}, child0, null);
        block(env, morph1, context, "link-to", ["welcome.features"], {}, child1, null);
        block(env, morph2, context, "link-to", ["welcome.pricing"], {}, child2, null);
        block(env, morph3, context, "link-to", ["welcome.faq"], {}, child3, null);
        block(env, morph4, context, "link-to", ["welcome.opensource"], {}, child4, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/nav/welcome/right-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            var el1 = dom.createElement("span");
            var el2 = dom.createTextNode("Dashboard");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, inline = hooks.inline;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, 0);
            inline(env, morph0, context, "fa-icon", ["tachometer"], {});
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("li");
          dom.setAttribute(el1,"class","auth-link");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          block(env, morph0, context, "link-to", ["application"], {"classNames": "button success"}, child0, null);
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          dom.setAttribute(el1,"href","user/edit");
          dom.setAttribute(el1,"class","button");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Edit Profile");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          inline(env, morph0, context, "fa-icon", ["pencil"], {});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          dom.setAttribute(el1,"href","#");
          dom.setAttribute(el1,"data-reveal-id","signup-modal");
          dom.setAttribute(el1,"class","button margin-right-5");
          var el2 = dom.createElement("span");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
          inline(env, morph0, context, "t", ["buttons.signup"], {});
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Logout");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, element = hooks.element, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element0 = dom.childAt(fragment, [0]);
          var morph0 = dom.createMorphAt(element0,0,0);
          element(env, element0, context, "action", ["invalidateSession"], {"on": "click"});
          inline(env, morph0, context, "fa-icon", ["sign-out"], {});
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("a");
          dom.setAttribute(el1,"href","#");
          dom.setAttribute(el1,"data-reveal-id","login-modal");
          dom.setAttribute(el1,"class","button margin-right-5");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          inline(env, morph0, context, "t", ["buttons.login"], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","auth-link");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","auth-link");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        var morph1 = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        dom.insertBoundary(fragment, 0);
        block(env, morph0, context, "if", [get(env, context, "session.isAuthenticated")], {}, child0, null);
        block(env, morph1, context, "if", [get(env, context, "session.isAuthenticated")], {}, child1, child2);
        block(env, morph2, context, "if", [get(env, context, "session.isAuthenticated")], {}, child3, child4);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/pricing-preview', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"style","margin: auto;");
        dom.setAttribute(el1,"class","row");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns medium-offset-2 small-10 small-offset-1");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","pricing-table");
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","title");
        var el7 = dom.createElement("h3");
        dom.setAttribute(el7,"style","color: white;");
        var el8 = dom.createTextNode("Preview Your Ticket Costs");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("h4");
        dom.setAttribute(el7,"style","color: white;");
        var el8 = dom.createTextNode("You are in control");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","description");
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-5 columns");
        var el9 = dom.createTextNode("Ticket Price");
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-7 columns");
        var el9 = dom.createElement("div");
        dom.setAttribute(el9,"class","row collapse");
        var el10 = dom.createElement("div");
        dom.setAttribute(el10,"class","small-3 columns");
        var el11 = dom.createElement("span");
        dom.setAttribute(el11,"style","padding: 10px;");
        dom.setAttribute(el11,"class","prefix");
        var el12 = dom.createTextNode("$");
        dom.appendChild(el11, el12);
        dom.appendChild(el10, el11);
        dom.appendChild(el9, el10);
        var el10 = dom.createElement("div");
        dom.setAttribute(el10,"class","small-9 columns");
        var el11 = dom.createElement("input");
        dom.setAttribute(el11,"id","ticketPrice");
        dom.setAttribute(el11,"paste","reCalculate");
        dom.setAttribute(el11,"type","text");
        dom.setAttribute(el11,"placeholder","75");
        dom.appendChild(el10, el11);
        dom.appendChild(el9, el10);
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","description");
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"id","serviceFee");
        dom.setAttribute(el8,"class","small-5 columns");
        dom.appendChild(el7, el8);
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"id","cardFee");
        dom.setAttribute(el8,"class","small-7 columns");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-5 columns");
        var el9 = dom.createElement("div");
        dom.setAttribute(el9,"class","text-center");
        var el10 = dom.createComment("");
        dom.appendChild(el9, el10);
        var el10 = dom.createTextNode(" Fee");
        dom.appendChild(el9, el10);
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-7 columns");
        var el9 = dom.createElement("div");
        dom.setAttribute(el9,"class","text-center");
        var el10 = dom.createTextNode("Gateway Processing Fee");
        dom.appendChild(el9, el10);
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","description");
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-5 columns");
        var el9 = dom.createTextNode("Buyer Pays");
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"id","buyerPays");
        dom.setAttribute(el8,"class","small-7 columns");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","description");
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-5 columns");
        var el9 = dom.createTextNode("You Get");
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"id","youGet");
        dom.setAttribute(el8,"class","small-7 columns");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("div");
        dom.setAttribute(el6,"class","description");
        var el7 = dom.createElement("div");
        dom.setAttribute(el7,"class","row");
        var el8 = dom.createElement("div");
        dom.setAttribute(el8,"class","small-12");
        var el9 = dom.createElement("label");
        var el10 = dom.createElement("input");
        dom.setAttribute(el10,"id","absorbFees");
        dom.setAttribute(el10,"type","checkbox");
        dom.appendChild(el9, el10);
        var el10 = dom.createTextNode("Absorb the fees into your price instead");
        dom.appendChild(el9, el10);
        dom.appendChild(el8, el9);
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, element = hooks.element, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 0, 0, 0, 0]);
        var element1 = dom.childAt(element0, [1, 0, 1, 0, 1, 0]);
        var element2 = dom.childAt(element0, [5, 0, 0, 0, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [2, 1, 0, 0]),0,0);
        element(env, element1, context, "action", ["reCalculate"], {"on": "keyUp"});
        inline(env, morph0, context, "t", ["appname"], {});
        element(env, element2, context, "action", ["reCalculate"], {"on": "click"});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/sign-up-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("label");
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("First Name");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          inline(env, morph0, context, "input", [], {"value": get(env, context, "model.firstName"), "placeholder": "", "type": "text", "required": "true"});
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("label");
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Last Name");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          inline(env, morph0, context, "input", [], {"value": get(env, context, "model.lastName"), "placeholder": "", "type": "text", "required": "true"});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("label");
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Email");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          inline(env, morph0, context, "input", [], {"value": get(env, context, "model.email"), "placeholder": "yourname@domain.com", "type": "text", "required": "true"});
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("label");
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Password");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          dom.setAttribute(el2,"class","padding-left-5");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline, get = hooks.get;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element0 = dom.childAt(fragment, [0]);
          var morph0 = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
          var morph1 = dom.createMorphAt(element0,2,2);
          inline(env, morph0, context, "tool-tip", [], {"message": "Length trumps complexity. If it's easier to remember a sentence, do that. This tooltip could even be your password."});
          inline(env, morph1, context, "input", [], {"value": get(env, context, "model.password"), "placeholder": "Secure and easy to remember", "type": "password", "required": "true"});
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("label");
          var el2 = dom.createElement("span");
          var el3 = dom.createTextNode("Password Confirmation");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          inline(env, morph0, context, "input", [], {"value": get(env, context, "model.passwordConfirmation"), "placeholder": "Secure and easy to remember", "type": "password", "required": "true"});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"id","signup-modal");
        dom.setAttribute(el1,"data-reveal","true");
        dom.setAttribute(el1,"aria-labeledby","signup-modal-title");
        dom.setAttribute(el1,"aria-hidden","true");
        dom.setAttribute(el1,"role","dialog");
        dom.setAttribute(el1,"class","reveal-modal medium");
        var el2 = dom.createElement("h2");
        dom.setAttribute(el2,"id","signup-modal-title");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createTextNode("Sign Up");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("p");
        var el3 = dom.createElement("form");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("br");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("ul");
        dom.setAttribute(el4,"class","button-group text-center right");
        var el5 = dom.createElement("li");
        var el6 = dom.createElement("button");
        dom.setAttribute(el6,"data-reveal-id","login-modal");
        var el7 = dom.createTextNode("Login");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("li");
        var el6 = dom.createElement("button");
        dom.setAttribute(el6,"type","submit");
        var el7 = dom.createTextNode("Sign Up");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","#");
        dom.setAttribute(el4,"data-reveal-id","login-help-modal");
        dom.setAttribute(el4,"class","button");
        var el5 = dom.createTextNode("Help");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"aria-label","Close");
        dom.setAttribute(el2,"class","close-reveal-modal");
        var el3 = dom.createTextNode("×");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, element = hooks.element, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element1 = dom.childAt(fragment, [0, 2, 0]);
        var element2 = dom.childAt(element1, [0]);
        var element3 = dom.childAt(element1, [2]);
        var morph0 = dom.createMorphAt(element2,0,0);
        var morph1 = dom.createMorphAt(element2,1,1);
        var morph2 = dom.createMorphAt(dom.childAt(element1, [1]),0,0);
        var morph3 = dom.createMorphAt(element3,0,0);
        var morph4 = dom.createMorphAt(element3,1,1);
        element(env, element1, context, "action", ["register"], {"on": "submit"});
        block(env, morph0, context, "error-field-wrapper", [], {"classes": "columns small-12 medium-6", "errors": get(env, context, "errors"), "field": "firstName"}, child0, null);
        block(env, morph1, context, "error-field-wrapper", [], {"classes": "columns small-12 medium-6", "errors": get(env, context, "errors"), "field": "lastName"}, child1, null);
        block(env, morph2, context, "error-field-wrapper", [], {"classes": "columns small-12", "errors": get(env, context, "errors"), "field": "email"}, child2, null);
        block(env, morph3, context, "error-field-wrapper", [], {"classes": "columns small-12 medium-6", "errors": get(env, context, "errors"), "field": "password"}, child3, null);
        block(env, morph4, context, "error-field-wrapper", [], {"classes": "columns small-12 medium-6", "errors": get(env, context, "errors"), "field": "passwordConfirmation"}, child4, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/components/tool-tip', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, null);
        dom.insertBoundary(fragment, 0);
        inline(env, morph0, context, "fa-icon", ["info-circle"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/dashboard', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("View Upcoming Events");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("View Communities");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("span");
        var el3 = dom.createTextNode("    ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-6 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Now what?");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Now that you are logged in, you can register for events, host your own event, start your own community or dance scene, have weekly lessons, memberships, and register for lessons or dances.");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-6 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Need help?");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Never be afraid to ask! if you have a question about anything, just send email to ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("the support email linked to at the bottom of the page");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("  and you should receive a response in one business day.");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("  There is also the facebook page linked to at the bottom of the screen, in case you want to discuss aeonvera with other people.");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [1]);
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(element0,0,0);
        var morph2 = dom.createMorphAt(element0,2,2);
        inline(env, morph0, context, "partial", ["attended_events"], {});
        block(env, morph1, context, "link-to", ["upcoming-events"], {"classNames": "button"}, child0, null);
        block(env, morph2, context, "link-to", ["communities"], {"classNames": "button"}, child1, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        content(env, morph0, context, "outlet");
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/login', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","well-centered");
        var el2 = dom.createElement("h2");
        var el3 = dom.createTextNode("Login");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","well-centered");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","panel");
        var el3 = dom.createElement("form");
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("label");
        dom.setAttribute(el4,"for","identification");
        var el5 = dom.createTextNode("Email");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("label");
        dom.setAttribute(el4,"for","password");
        var el5 = dom.createTextNode("Password");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" ");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("button");
        dom.setAttribute(el4,"type","submit");
        var el5 = dom.createTextNode("Login");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        var el3 = dom.createTextNode("Sign Up");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        var el3 = dom.createTextNode("Forgot your email?");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        var el3 = dom.createTextNode("Forgot your password?");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        var el3 = dom.createTextNode("Didn't receive confirmation instructions?");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        var el3 = dom.createTextNode("Didn't receive unlock instructions?");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, element = hooks.element, get = hooks.get, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [3, 0, 0]);
        var morph0 = dom.createMorphAt(element0,3,3);
        var morph1 = dom.createMorphAt(element0,7,7);
        var morph2 = dom.createMorphAt(fragment,7,7,contextualElement);
        dom.insertBoundary(fragment, null);
        element(env, element0, context, "action", ["authenticate"], {"on": "submit"});
        inline(env, morph0, context, "input", [], {"value": get(env, context, "identification"), "placeholder": "Enter Email"});
        inline(env, morph1, context, "input", [], {"value": get(env, context, "password"), "placeholder": "Enter Password", "type": "password"});
        inline(env, morph2, context, "render", ["shared/footer"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/register', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createTextNode("Register!");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/shared/footer', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["tos"], {});
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["privacy"], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("footer");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","medium-6 columns");
        var el4 = dom.createElement("ul");
        dom.setAttribute(el4,"class","inline-list");
        var el5 = dom.createElement("li");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("li");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("li");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","medium-6 columns");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","right");
        var el5 = dom.createElement("ul");
        dom.setAttribute(el5,"class","inline-list");
        var el6 = dom.createElement("li");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row copy");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","small-12 columns");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","right");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, block = hooks.block, content = hooks.content, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [0]);
        var element2 = dom.childAt(element1, [0, 0]);
        var element3 = dom.childAt(element1, [1, 0, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element2, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element2, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element2, [2]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
        var morph4 = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
        var morph5 = dom.createMorphAt(dom.childAt(element0, [1, 0, 0]),0,0);
        block(env, morph0, context, "link-to", ["welcome.tos"], {}, child0, null);
        block(env, morph1, context, "link-to", ["welcome.privacy"], {}, child1, null);
        content(env, morph2, context, "submit-idea-link");
        content(env, morph3, context, "links/mail-support-icon-link");
        content(env, morph4, context, "links/facebook-icon-link");
        inline(env, morph5, context, "t", ["copyright"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/upcoming-events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("span");
            var el2 = dom.createTextNode("Open");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            return fragment;
          }
        };
      }());
      var child1 = (function() {
        return {
          isHTMLBars: true,
          revision: "Ember@1.11.1",
          blockParams: 0,
          cachedFragment: null,
          hasRendered: false,
          build: function build(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            return el0;
          },
          render: function render(context, env, contextualElement) {
            var dom = env.dom;
            var hooks = env.hooks, get = hooks.get, inline = hooks.inline;
            dom.detectNamespace(contextualElement);
            var fragment;
            if (env.useFragmentCache && dom.canClone) {
              if (this.cachedFragment === null) {
                fragment = this.build(dom);
                if (this.hasRendered) {
                  this.cachedFragment = fragment;
                } else {
                  this.hasRendered = true;
                }
              }
              if (this.cachedFragment) {
                fragment = dom.cloneNode(this.cachedFragment, true);
              }
            } else {
              fragment = this.build(dom);
            }
            var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, null);
            dom.insertBoundary(fragment, 0);
            inline(env, morph0, context, "date-with-format", [get(env, context, "event.registrationOpensAt"), "llll"], {});
            return fragment;
          }
        };
      }());
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("tr");
          var el2 = dom.createElement("td");
          var el3 = dom.createElement("a");
          var el4 = dom.createComment("");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("td");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("th");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("th");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, get = hooks.get, concat = hooks.concat, attribute = hooks.attribute, content = hooks.content, inline = hooks.inline, block = hooks.block;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element0 = dom.childAt(fragment, [0]);
          var element1 = dom.childAt(element0, [0, 0]);
          var morph0 = dom.createMorphAt(element1,0,0);
          var attrMorph0 = dom.createAttrMorph(element1, 'href');
          var morph1 = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
          var morph2 = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
          var morph3 = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
          attribute(env, attrMorph0, element1, "href", concat(env, [get(env, context, "event.url")]));
          content(env, morph0, context, "event.name");
          content(env, morph1, context, "event.location");
          inline(env, morph2, context, "date-range", [get(env, context, "event.startsAt"), get(env, context, "event.endsAt")], {});
          block(env, morph3, context, "if", [get(env, context, "event.isRegistrationOpen")], {}, child0, child1);
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Back");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("h2");
        dom.setAttribute(el3,"class","page-title");
        var el4 = dom.createTextNode("Upcoming Events");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("table");
        var el4 = dom.createElement("thead");
        var el5 = dom.createElement("tr");
        var el6 = dom.createElement("th");
        var el7 = dom.createTextNode("Name");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("th");
        var el7 = dom.createTextNode("Location");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("th");
        var el7 = dom.createTextNode("Date of Event");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("th");
        var el7 = dom.createTextNode("Registration Opens");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("tbody");
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, get = hooks.get, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element2 = dom.childAt(fragment, [0, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element2, [1, 1]),0,0);
        var morph1 = dom.createMorphAt(element2,2,2);
        block(env, morph0, context, "each", [get(env, context, "model")], {"keyword": "event"}, child0, null);
        block(env, morph1, context, "link-to", ["dashboard"], {"classNames": "button"}, child1, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/about', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h1");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h6");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("span");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n  ");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h3");
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://www.facebook.com/aeonvera");
        var el4 = dom.createTextNode("\n      ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" facebook\n    ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n    ");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera/issues");
        var el4 = dom.createTextNode("\n      ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" issue tracker\n    ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("\n  ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("\n");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [2]);
        var element1 = dom.childAt(element0, [12]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [1]),1,1);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [3]),1,1);
        var morph2 = dom.createMorphAt(dom.childAt(element0, [7]),1,1);
        var morph3 = dom.createMorphAt(dom.childAt(element1, [1]),1,1);
        var morph4 = dom.createMorphAt(dom.childAt(element1, [5]),1,1);
        inline(env, morph0, context, "t", ["appname"], {});
        inline(env, morph1, context, "t", ["subheader"], {});
        inline(env, morph2, context, "t", ["copyright"], {});
        inline(env, morph3, context, "fa-icon", ["facebook"], {});
        inline(env, morph4, context, "fa-icon", ["github"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/faq', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel callout extra-padding header");
        var el2 = dom.createElement("h1");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h4");
        dom.setAttribute(el2,"class","subheader");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row imageoverlay extra-padding center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("ul");
        var el6 = dom.createElement("li");
        var el7 = dom.createTextNode("From a development perspective, Stripe was far easier to integrate with than PayPal. PayPal has a lot of red tape, and their customer support is 50 shades of horrible.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("From a consumer perspective, Stripe is transparent. No hidden fees. PayPal will charge extra if a payment is received from out of the United States. For more information on the gateway fees, check out");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("a");
        dom.setAttribute(el7,"href","https://stripe.com/us/pricing");
        var el8 = dom.createTextNode(" the Stripe pricing page ");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("and");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("a");
        dom.setAttribute(el7,"href","https://www.paypal.com/us/webapps/helpcenter/helphub/article/?solutionId=FAQ690&m=HTQ");
        var el8 = dom.createTextNode("  the PayPal fees page. ");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Additionally, Stripe will direct deposit in to your bank account, whereas, with PayPal, deposits must happen manually.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Stripe doesn't ask your registrants to login. They just pay with their credit or debit card over a secure connection.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("ul");
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("EventBrite, OpenDance, Universe, you name it. ");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode(" is cheaper than all of them.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("The only fee charged is 0.75% of any electronic payment. And it can be paid by the registrant. This is to help maintain the cost of running");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode(" ");
        dom.appendChild(el7, el8);
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode(", upgrading infrastructure, etc");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("If an event doesn't want to use electronic payments, it is perfectly fine to use");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode(" ");
        dom.appendChild(el7, el8);
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        var el8 = dom.createTextNode(" ");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("for free. No charge. :-)");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("br");
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("br");
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(", ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("h4");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-8");
        var el5 = dom.createElement("span");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(fragment, [1, 0]);
        var element2 = dom.childAt(element1, [2]);
        var element3 = dom.childAt(element2, [1, 0]);
        var element4 = dom.childAt(element1, [4]);
        var element5 = dom.childAt(element1, [6]);
        var element6 = dom.childAt(element5, [1]);
        var element7 = dom.childAt(element6, [4]);
        var element8 = dom.childAt(element1, [8]);
        var element9 = dom.childAt(element1, [10]);
        var element10 = dom.childAt(element1, [12]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element1, [0, 0, 0, 0]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(element2, [0, 0, 0]),0,0);
        var morph4 = dom.createMorphAt(dom.childAt(element3, [0, 1]),0,0);
        var morph5 = dom.createMorphAt(dom.childAt(element3, [1, 1]),1,1);
        var morph6 = dom.createMorphAt(dom.childAt(element3, [2, 1]),1,1);
        var morph7 = dom.createMorphAt(dom.childAt(element4, [0, 0, 0]),0,0);
        var morph8 = dom.createMorphAt(dom.childAt(element4, [1, 0]),0,0);
        var morph9 = dom.createMorphAt(dom.childAt(element5, [0, 0, 0]),0,0);
        var morph10 = dom.createMorphAt(dom.childAt(element6, [0]),0,0);
        var morph11 = dom.createMorphAt(dom.childAt(element6, [3]),0,0);
        var morph12 = dom.createMorphAt(element7,0,0);
        var morph13 = dom.createMorphAt(element7,2,2);
        var morph14 = dom.createMorphAt(dom.childAt(element8, [0, 0, 0]),0,0);
        var morph15 = dom.createMorphAt(dom.childAt(element8, [1, 0]),0,0);
        var morph16 = dom.createMorphAt(dom.childAt(element9, [0, 0, 0]),0,0);
        var morph17 = dom.createMorphAt(dom.childAt(element9, [1, 0]),0,0);
        var morph18 = dom.createMorphAt(dom.childAt(element10, [0, 0, 0]),0,0);
        var morph19 = dom.createMorphAt(dom.childAt(element10, [1, 0]),0,0);
        inline(env, morph0, context, "t", ["faq"], {});
        inline(env, morph1, context, "t", ["faqfull"], {});
        inline(env, morph2, context, "t", ["faqtext.questions.whystripe"], {});
        inline(env, morph3, context, "t", ["faqtext.questions.pricecompare"], {});
        inline(env, morph4, context, "t", ["appname"], {});
        inline(env, morph5, context, "t", ["appname"], {});
        inline(env, morph6, context, "t", ["appname"], {});
        inline(env, morph7, context, "t", ["faqtext.questions.name"], {});
        inline(env, morph8, context, "t", ["faqtext.answers.name"], {});
        inline(env, morph9, context, "t", ["faqtext.questions.pronounce"], {});
        inline(env, morph10, context, "t", ["faqtext.answers.pronounce"], {});
        inline(env, morph11, context, "t", ["formoreinfo"], {});
        content(env, morph12, context, "how-to-pronounce-ae");
        content(env, morph13, context, "links/aeon-wikipedia-link");
        inline(env, morph14, context, "t", ["faqtext.questions.idea"], {});
        inline(env, morph15, context, "t", ["faqtext.answers.idea"], {});
        inline(env, morph16, context, "t", ["faqtext.questions.howhelp"], {});
        inline(env, morph17, context, "t", ["faqtext.answers.howhelp"], {});
        inline(env, morph18, context, "t", ["faqtext.questions.butthis"], {});
        inline(env, morph19, context, "t", ["faqtext.answers.butthis"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel callout extra-padding header");
        var el2 = dom.createElement("h1");
        var el3 = dom.createTextNode("Features Everywhere");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h4");
        dom.setAttribute(el2,"class","subheader");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera");
        dom.setAttribute(el3,"target","_blank");
        var el4 = dom.createTextNode("Have an Idea? Submit Here.");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","/hosted_events/new");
        dom.setAttribute(el2,"class","button success");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 2]),0,0);
        var morph1 = dom.createMorphAt(fragment,1,1,contextualElement);
        var morph2 = dom.createMorphAt(fragment,2,2,contextualElement);
        var morph3 = dom.createMorphAt(fragment,3,3,contextualElement);
        var morph4 = dom.createMorphAt(fragment,4,4,contextualElement);
        var morph5 = dom.createMorphAt(fragment,5,5,contextualElement);
        var morph6 = dom.createMorphAt(fragment,6,6,contextualElement);
        var morph7 = dom.createMorphAt(fragment,7,7,contextualElement);
        dom.insertBoundary(fragment, null);
        inline(env, morph0, context, "t", ["createyourevent"], {});
        inline(env, morph1, context, "render", ["welcome/features/registration"], {});
        inline(env, morph2, context, "render", ["welcome/features/reporting"], {});
        inline(env, morph3, context, "render", ["welcome/features/discounts-and-tiers"], {});
        inline(env, morph4, context, "render", ["welcome/features/at-the-door"], {});
        inline(env, morph5, context, "render", ["welcome/features/housing"], {});
        inline(env, morph6, context, "render", ["welcome/features/inventory"], {});
        inline(env, morph7, context, "render", ["welcome/get-started"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/at-the-door', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","panel");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","small-12 columns");
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createTextNode("At The Door");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h6");
        dom.setAttribute(el4,"class","text-center subheader");
        var el5 = dom.createTextNode("Large buttons for touch screen friendlyness. Options to track money as cash, check, or credit.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-3 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("One Click Checkin");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("No need to scan through alphabetical lists. Search for a person by first or last name, and with the click of a button they are marked as checked in.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-3 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("Registration");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("Want to register someone for a full weekend, competition, or dance pass?  Registration looks nearly identical to the public registration form.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-3 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("À La Carte");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("Track individual sales of dances, classes, and shirts. À La Carte do not need to be tied to an existing registration.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-3 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("Competition Sign Up");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("Easily add competitions to a registrant by searching for their name.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("br");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("* Note that internet is required to use ");
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        var el5 = dom.createTextNode(" at the door.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 0, 0]);
        var element1 = dom.childAt(element0, [2]);
        var morph0 = dom.createMorphAt(dom.childAt(element1, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element1, [1, 0]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element1, [2, 0]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(element1, [3, 0]),0,0);
        var morph4 = dom.createMorphAt(dom.childAt(element0, [4]),1,1);
        inline(env, morph0, context, "fa-icon", ["hand-o-up"], {});
        inline(env, morph1, context, "fa-icon", ["ticket"], {});
        inline(env, morph2, context, "fa-icon", ["plus-square"], {});
        inline(env, morph3, context, "fa-icon", ["check-square"], {});
        inline(env, morph4, context, "t", ["appname"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/discounts-and-tiers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row imageoverlay extra-padding center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("h2");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createTextNode("Discounts");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Add any number of discounts and track who uses them. Discounts can apply to only a specific item (dance, competition, etc), or the entire registration.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("h2");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createTextNode("Pricing Tiers");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Tiers can be configured to increase the price of your packages (e.g.: Full Weekend, Dance Only), by number of registrants and / or by date.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/housing', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"style","margin: auto;");
        dom.setAttribute(el1,"class","row imageoverlay extra-padding");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("h2");
        dom.setAttribute(el3,"class","text-center");
        var el4 = dom.createTextNode("Housing");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h6");
        dom.setAttribute(el3,"class","text-center subheader");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Providing");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Collect information about people in your local scene, how many people they can house, if they have pets, etc");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Requesting");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Collect information about those who are possibly on a low budget, and wishing to stay with someone local to your scene.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/inventory', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","panel");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","small-12 columns");
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createTextNode("Inventory");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-6 medium-offset-3");
        var el6 = dom.createElement("ul");
        var el7 = dom.createElement("li");
        var el8 = dom.createTextNode("Upon registration, attendees can select quantites for how many of what item they wish to purchase");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("li");
        var el8 = dom.createTextNode("Track how much has been sold before placing an order for shirts (for example)");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        var el7 = dom.createElement("li");
        var el8 = dom.createTextNode("Inventory may be entered upon item arrival to help manage item sales at the door");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/registration', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row imageoverlay extra-padding center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("h2");
        dom.setAttribute(el3,"class","text-center");
        var el4 = dom.createTextNode("Registration Form");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-3 columns");
        var el5 = dom.createElement("h1");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Customizable");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Coming Soon. Want to collect additional information? Maybe to know what scene someone is from? Additional text boxes may be added.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-3 columns");
        var el5 = dom.createElement("h1");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Styleable");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Coming Soon. You'll be able to configure colors, add logos, banners, etc.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-3 columns");
        var el5 = dom.createElement("h1");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Uniform");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Everything is on one page, so your registrants can find everything and not be lost in silly broken up navigation.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-3 columns");
        var el5 = dom.createElement("h1");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createTextNode("Validation");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Dance Only packages don't require that registrants select a track. Full Weekend packages traditionally do. Validation logic is configurable.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 0, 1]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element0, [2, 0]),0,0);
        var morph3 = dom.createMorphAt(dom.childAt(element0, [3, 0]),0,0);
        inline(env, morph0, context, "fa-icon", ["adjust"], {});
        inline(env, morph1, context, "fa-icon", ["edit"], {});
        inline(env, morph2, context, "fa-icon", ["th-large"], {});
        inline(env, morph3, context, "fa-icon", ["bookmark"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/features/reporting', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","panel");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","small-12 columns");
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createTextNode("Reporting");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h6");
        dom.setAttribute(el4,"class","text-center subheader");
        var el5 = dom.createTextNode("See how your event is doing over time");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","row");
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-4 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("Track Income");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("Directly correlated to how many people register for your event. This will allow you to plan budgets for following years.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-4 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("Track Registrants");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("See how many registrants are signing up for you event over time to help tune tiers and registration opening time for next year.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","medium-4 columns");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","text-center");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h3");
        var el7 = dom.createTextNode("During Event Tracking");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("During the day while lessons are happening, or at night at a dance. Income is automatically filtered based on when the event's dances occur.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 0, 0, 2]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element0, [2, 0]),0,0);
        inline(env, morph0, context, "fa-icon", ["line-chart"], {});
        inline(env, morph1, context, "fa-icon", ["users"], {});
        inline(env, morph2, context, "fa-icon", ["bar-chart"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/get-started', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createElement("h3");
        var el3 = dom.createTextNode("Lets Begin");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"class","button success");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 1]),0,0);
        inline(env, morph0, context, "t", ["createyourevent"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["buttons.eventcalendar"], {});
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["buttons.scenesbycity"], {});
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("div");
          dom.setAttribute(el1,"class","text-center");
          var el2 = dom.createElement("ul");
          dom.setAttribute(el2,"class","button-group");
          var el3 = dom.createElement("li");
          var el4 = dom.createElement("a");
          dom.setAttribute(el4,"href","#");
          dom.setAttribute(el4,"data-reveal-id","login-modal");
          dom.setAttribute(el4,"class","button small success");
          var el5 = dom.createComment("");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("li");
          var el4 = dom.createElement("a");
          dom.setAttribute(el4,"href","#");
          dom.setAttribute(el4,"data-reveal-id","signup-modal");
          dom.setAttribute(el4,"class","button small success");
          var el5 = dom.createComment("");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("br");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("br");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var element0 = dom.childAt(fragment, [0, 0]);
          var morph0 = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
          var morph1 = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
          inline(env, morph0, context, "t", ["buttons.login"], {});
          inline(env, morph1, context, "t", ["buttons.signup"], {});
          return fragment;
        }
      };
    }());
    var child3 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["features"], {});
          return fragment;
        }
      };
    }());
    var child4 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["pricing"], {});
          return fragment;
        }
      };
    }());
    var child5 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          var hooks = env.hooks, inline = hooks.inline;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, null);
          dom.insertBoundary(fragment, 0);
          inline(env, morph0, context, "t", ["faq"], {});
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel bg-header header");
        var el2 = dom.createElement("h1");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h6");
        dom.setAttribute(el2,"class","subheader text-center");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","/hosted_events/new");
        dom.setAttribute(el3,"class","button success");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel header");
        var el2 = dom.createElement("h3");
        dom.setAttribute(el2,"class","text-center");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("span");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns medium-4 text-center");
        var el3 = dom.createElement("h3");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, block = hooks.block, get = hooks.get;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element1 = dom.childAt(fragment, [0]);
        var element2 = dom.childAt(fragment, [1]);
        var element3 = dom.childAt(element2, [0]);
        var element4 = dom.childAt(element2, [1]);
        var element5 = dom.childAt(element2, [2]);
        var element6 = dom.childAt(fragment, [5]);
        var element7 = dom.childAt(fragment, [6]);
        var element8 = dom.childAt(element7, [0]);
        var element9 = dom.childAt(element7, [1]);
        var element10 = dom.childAt(element7, [2]);
        var morph0 = dom.createMorphAt(dom.childAt(element1, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element1, [1]),0,0);
        var morph2 = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
        var morph3 = dom.createMorphAt(element3,2,2);
        var morph4 = dom.createMorphAt(dom.childAt(element4, [0]),0,0);
        var morph5 = dom.createMorphAt(dom.childAt(element4, [2]),0,0);
        var morph6 = dom.createMorphAt(dom.childAt(element5, [0]),0,0);
        var morph7 = dom.createMorphAt(element5,2,2);
        var morph8 = dom.createMorphAt(fragment,4,4,contextualElement);
        var morph9 = dom.createMorphAt(dom.childAt(element6, [0]),0,0);
        var morph10 = dom.createMorphAt(dom.childAt(element6, [1, 0]),0,0);
        var morph11 = dom.createMorphAt(dom.childAt(element8, [0]),0,0);
        var morph12 = dom.createMorphAt(dom.childAt(element8, [1]),0,0);
        var morph13 = dom.createMorphAt(dom.childAt(element9, [0]),0,0);
        var morph14 = dom.createMorphAt(dom.childAt(element9, [1]),0,0);
        var morph15 = dom.createMorphAt(dom.childAt(element10, [0]),0,0);
        var morph16 = dom.createMorphAt(dom.childAt(element10, [1]),0,0);
        inline(env, morph0, context, "t", ["appname"], {});
        inline(env, morph1, context, "t", ["subheader"], {});
        inline(env, morph2, context, "t", ["lookingforevent"], {});
        block(env, morph3, context, "link-to", ["upcoming-events"], {"classNames": "button"}, child0, null);
        inline(env, morph4, context, "t", ["hostinganevent"], {});
        inline(env, morph5, context, "t", ["buttons.createyourevent"], {});
        inline(env, morph6, context, "t", ["lookingforscene"], {});
        block(env, morph7, context, "link-to", ["communities"], {"classNames": "button"}, child1, null);
        block(env, morph8, context, "unless", [get(env, context, "session.isAuthenticated")], {}, child2, null);
        inline(env, morph9, context, "t", ["whatisheader"], {});
        inline(env, morph10, context, "t", ["whatis"], {});
        block(env, morph11, context, "link-to", ["welcome.features"], {}, child3, null);
        inline(env, morph12, context, "t", ["featuresinfo"], {});
        block(env, morph13, context, "link-to", ["welcome.pricing"], {}, child4, null);
        inline(env, morph14, context, "t", ["pricinginfo"], {});
        block(env, morph15, context, "link-to", ["welcome.faq"], {}, child5, null);
        inline(env, morph16, context, "t", ["faqinfo"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/opensource', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel callout extra-padding header");
        var el2 = dom.createElement("h2");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h4");
        dom.setAttribute(el2,"class","subheader");
        var el3 = dom.createTextNode("projects used in ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","extra-padding text-center");
        var el2 = dom.createElement("p");
        var el3 = dom.createTextNode("Turns out that coding is very time consuming. ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode(" wouldn't be where it is today if it weren't for the hard work of all of the below projects. Being able to use open source projects has easily shaved years of off ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode("'s development time. So, here is a list of some of the more notable projects used, and a special thanks to all of them! :-)");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h3");
        var el3 = dom.createTextNode("Front-End / User-Interface");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://emberjs.com/");
        var el4 = dom.createTextNode("ember");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://foundation.zurb.com/");
        var el4 = dom.createTextNode("Foundation");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://fortawesome.github.io/Font-Awesome/");
        var el4 = dom.createTextNode("Font Awesome");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://emblemjs.com/");
        var el4 = dom.createTextNode("Emblem.js");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera-ui/blob/master/bower.json");
        var el4 = dom.createTextNode("and more!");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h3");
        var el3 = dom.createTextNode("Back-End / Server");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://www.ruby-lang.org/en/");
        var el4 = dom.createTextNode("Ruby");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://rubyonrails.org/");
        var el4 = dom.createTextNode("Rails");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://www.postgresql.org/");
        var el4 = dom.createTextNode("PostgreSQL");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/newrelic/rpm");
        var el4 = dom.createTextNode("New Relic RPM");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://redis.io/");
        var el4 = dom.createTextNode("Redis");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/plataformatec/devise");
        var el4 = dom.createTextNode("Devise");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/stripe/stripe-ruby");
        var el4 = dom.createTextNode("Stripe");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera/blob/master/Gemfile");
        var el4 = dom.createTextNode("and more!");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h3");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h4");
        var el3 = dom.createTextNode("(this project)");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera-ui");
        var el4 = dom.createTextNode("Front-End");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h5");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","https://github.com/NullVoxPopuli/aeonvera");
        var el4 = dom.createTextNode("Back-End");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(fragment, [1]);
        var element2 = dom.childAt(element1, [0]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1]),1,1);
        var morph2 = dom.createMorphAt(element2,1,1);
        var morph3 = dom.createMorphAt(element2,3,3);
        var morph4 = dom.createMorphAt(dom.childAt(element1, [22]),0,0);
        inline(env, morph0, context, "t", ["opensource"], {});
        inline(env, morph1, context, "t", ["appname"], {});
        inline(env, morph2, context, "t", ["appname"], {});
        inline(env, morph3, context, "t", ["appname"], {});
        inline(env, morph4, context, "t", ["appname"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/pricing', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel callout extra-padding header");
        var el2 = dom.createElement("h1");
        var el3 = dom.createTextNode("Creating an Event is Free");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("h4");
        dom.setAttribute(el2,"class","subheader");
        var el3 = dom.createTextNode("Probably cheaper than the altervative");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","/hosted_events/new");
        dom.setAttribute(el2,"class","button success");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 2]),0,0);
        var morph1 = dom.createMorphAt(fragment,1,1,contextualElement);
        var morph2 = dom.createMorphAt(fragment,2,2,contextualElement);
        var morph3 = dom.createMorphAt(fragment,3,3,contextualElement);
        var morph4 = dom.createMorphAt(fragment,4,4,contextualElement);
        inline(env, morph0, context, "t", ["createyourevent"], {});
        inline(env, morph1, context, "render", ["welcome/pricing/free-or-not"], {});
        content(env, morph2, context, "pricing-preview");
        inline(env, morph3, context, "render", ["welcome/pricing/pricing-features"], {});
        inline(env, morph4, context, "render", ["welcome/get-started"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/pricing/free-or-not', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row imageoverlay extra-padding center-margin");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("span");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","no-bottom-margin");
        var el7 = dom.createTextNode("0.75%");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h5");
        dom.setAttribute(el6,"class","subheader");
        var el7 = dom.createTextNode("+ gateway fees (normally 2.9% + 30 cents)");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("No fees are hidden. Transparency is the game, and ");
        dom.appendChild(el6, el7);
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        var el7 = dom.createTextNode(" strives to win. No contract, no monthly fees, no termination fees, free support.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-6 columns");
        var el5 = dom.createElement("span");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createElement("h1");
        dom.setAttribute(el6,"class","no-bottom-margin");
        var el7 = dom.createTextNode("Free Everything");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("h5");
        dom.setAttribute(el6,"class","subheader");
        var el7 = dom.createTextNode(" ");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("If you don't need electronic processing, and / or would prefer your registrants pay at the door, you may use ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" at no cost whatsoever.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0, 0, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0, 1, 0]),1,1);
        var morph1 = dom.createMorphAt(dom.childAt(element0, [1, 1]),1,1);
        inline(env, morph0, context, "t", ["appname"], {});
        inline(env, morph1, context, "t", ["appname"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/pricing/pricing-features', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","panel");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","row");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","columns medium-3");
        var el4 = dom.createElement("h1");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createElement("i");
        dom.setAttribute(el5,"class","fa fa-credit-card");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","title");
        var el5 = dom.createTextNode("Credit Processing");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("p");
        dom.setAttribute(el4,"class","description");
        var el5 = dom.createTextNode("Accept Visa, MasterCard, Amex, Debit and Discover cards. Credit card processing fee determined by the payment gateway.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","columns medium-3");
        var el4 = dom.createElement("h1");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createElement("i");
        dom.setAttribute(el5,"class","fa fa-cc-stripe");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","title");
        var el5 = dom.createTextNode("Gateway Payments");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("p");
        dom.setAttribute(el4,"class","description");
        var el5 = dom.createTextNode("No merchant account required. Just connect your Stripe account and all the payment collecting is easy peasy. (Paypal and other gateways coming soon™)");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","columns medium-3");
        var el4 = dom.createElement("h1");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createElement("i");
        dom.setAttribute(el5,"class","fa fa-tag");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","title");
        var el5 = dom.createTextNode("Fee Freedom");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("p");
        dom.setAttribute(el4,"class","description");
        var el5 = dom.createTextNode("For electronic payments, fees may be passed on to registrants, or absorbed into your price.  You decide who is paying the fees.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","columns medium-3");
        var el4 = dom.createElement("h1");
        dom.setAttribute(el4,"class","text-center");
        var el5 = dom.createElement("i");
        dom.setAttribute(el5,"class","fa fa-lock");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("h2");
        dom.setAttribute(el4,"class","title");
        var el5 = dom.createTextNode("Secure Payments");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("p");
        dom.setAttribute(el4,"class","description");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Encrypted transactions and payments via");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("a");
        dom.setAttribute(el5,"href","http://en.wikipedia.org/wiki/Transport_Layer_Security");
        var el6 = dom.createTextNode(" TLS (better than SSL)");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/privacy', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay text-center panel callout extra-padding header");
        var el2 = dom.createElement("h2");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode(" Privacy Policy Statement");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("p");
        var el3 = dom.createTextNode("Revision date: January 7, 2015");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","surround-padding-20");
        var el2 = dom.createElement("p");
        var el3 = dom.createTextNode("Protecting your privacy is a serious matter and doing so is very important to us. Please read this Privacy Policy statement (the \"Policy\") to learn more about our Privacy Policy. This Policy describes the information we collect from you and what may happen to that information, and only applies to such information. This Policy applies to all sites under the aeonvera.com domain.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("ol");
        dom.setAttribute(el1,"class","legal surround-padding-20");
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Information Collection");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Disclaimer: The administrator of ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" will never share or sell information about any event, registrant, or organization. The only time an administrator of ÆONVERA will access data reguarding a particular event of registrant is if and only if it pertains to fixing a problem or bug within the system (ÆONVERA).");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("We collect the following information about you and your use of the website in order help provide a streamline registration process, which will evolve over time.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("ol");
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("First and last name so that event organizers can identify you as an attendee and be able to check you in when you arrive to the event location.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Email is used for notifications through ");
        dom.appendChild(el7, el8);
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        var el8 = dom.createTextNode(", confirming event registrations and cancellations.  An event organizer may also use your email address to contact you for housing purposes, or other information pertaining to the event.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Address is for verifying that any potentially mailed payments belong to you, the registrant. The address is also used in the generation of a map of attendees by city (specific addresses are not used in this map)");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("li");
        var el7 = dom.createElement("span");
        var el8 = dom.createTextNode("Every event you register for is tracked for historical purposes such that in the event of a dispute, ");
        dom.appendChild(el7, el8);
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        var el8 = dom.createTextNode(" can prove a particular action was taken. However, if any payments occur outside of the system, ");
        dom.appendChild(el7, el8);
        var el8 = dom.createComment("");
        dom.appendChild(el7, el8);
        var el8 = dom.createTextNode(" can not help in any arbitration.  It is also possible to look through a history of events that you have registered for so that you may track your own spending.");
        dom.appendChild(el7, el8);
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("For our members' convenience, we use \"cookies\" to allow you to enter your password less frequently during a session and to provide for an easier registration process. If you configure your browser or otherwise choose to reject the cookies, you may still use our site. However, to best experience our website and Platform and most easily use our Platform you must have cookies enabled. Our use of cookies is consistent with the rights and restrictions set forth in Section 2.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("We may collect information such as registrations you make to various events on our website, messages you send or receive to/from a particular event's organizers, messages you send to us, and correspondence we receive from other members. Our use of this information is consistent with the rights and restrictions set forth in Section 2.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Use of Information");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("We may compile the information we collect about you and use it, in an aggregate form only, in the negotiation and establishment of service agreements with public and/or private enterprises under which such enterprises will serve as ÆONVERA partners or as venues for meetings between our members.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Disclosure of Your Information");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Opt-in requirement. WITHOUT YOUR AFFIRMATIVE CONSENT (ON A CASE-BY-CASE BASIS), WE DO NOT SELL, RENT OR OTHERWISE SHARE YOUR PERSONALLY IDENTIFIABLE INFORMATION WITH OTHER THIRD PARTIES, UNLESS OTHERWISE REQUIRED AS DESCRIBED BELOW UNDER \"REQUIRED DISCLOSURES\". TO THE EXTENT WE SHARE INFORMATION WITH OUR PARTNERS.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("You should understand that information you provide through the registration process, or through the use of our Platform (including your name and location information) may be accessible by event organizers .");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Required disclosures. Though we make every effort to preserve member privacy, we may need to disclose your Personally Identifiable Information when required by law or if we have a good-faith belief that such action is necessary to (a) comply with a current judicial proceeding, a court order or legal process served on our website, (b) enforce this Policy or the Terms of Service Agreement, (c) respond to claims that your Personal Information violates the rights of third parties; or (d) protect the rights, property or personal safety of ÆONVERA, its members and the public. You authorize us to disclose any information about you to law enforcement or other government officials as we, in our sole discretion, believe necessary or appropriate, in connection with an investigation of fraud, intellectual property infringements, or other activity that is illegal or may expose us or you to legal liability.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Communications from ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        var el4 = dom.createTextNode(" events");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Communication from ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" and Members of the ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" Community are governed by Sections 7.1 and 7.2 of our Terms of Service. You may manage your subscriptions to all ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" Communications in the Communication Preferences tab of the Your Account page.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Reviewing, Updating, Deleting and Deactivating Personal Information");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("After registration for our Platform and for specific topic groups, ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" Groups or ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" Everywheres, we provide a way to update your Personally Identifiable Information. Upon your request, we will deactivate your account and remove your Personally Identifiable Information from our active databases. To make this request, email support@aeonvera.com. Upon our receipt of your request, we will deactivate your account and remove your Personally Identifiable Information as soon as reasonably possible in accordance with our deactivation policy and applicable law. Nonetheless, we will retain in our files information you may have requested us to remove if, in our discretion, retention of the information is necessary to resolve disputes, troubleshoot problems or to enforce the Terms of Service Agreement. Furthermore, your information is never completely removed from our databases due to technical and legal constraints (for example, we will not remove your information from our back up storage).");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Notifications of Changes");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("If we decide to change this Policy, we will post those changes on http://www.aeonvera.com/privacy or post a notice of the changes to this Policy on the homepage (http://www.aeonvera.com/) and other places we deem appropriate, so you are always aware of what information we collect, how we use it, and under what circumstances, if any, we disclose it. We will use information in accordance with the Privacy Policy statement under which the information was collected.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("If we make any material changes in our privacy practices, we will post a prominent notice on our website notifying you and our other members of the change. In some cases where we post a notice we will also email you and other members who have opted to receive communications from us, notifying them of the changes in our privacy practices. However, if you have deleted/deactivated your account, then you will not be contacted, nor will your previously collected personal information be used in this new manner.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("If the change to this Policy would change how your Personally Identifiable Information is treated, then the change will not apply to you without your affirmative consent. However, if after a period of thirty (30) days you have not consented to the change in the Policy, your account will be automatically suspended until such time as you may choose to consent to the Policy change. Until such consent, your personal information will be treated under the Policy terms in force when you began your membership.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("Any other change to this Policy (i.e., if it does not change how we treat your Personally Identifiable Information) will become are effective after we provide you with at least thirty (30) days notice of the changes and provide notice of the changes as described above. You must notify us within this 30 day period if you do not agree to the changes to the Policy and wish to deactivate your account as provided under Section 5.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Dispute Resolution");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("li");
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("Any dispute, claim or controversy arising out of or relating to this Policy or previous Privacy Policy statements shall be resolved through negotiation, mediation and arbitration as provided under our Terms of Service Agreement.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Contact Information");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ol");
        var el4 = dom.createElement("li");
        var el5 = dom.createElement("span");
        var el6 = dom.createTextNode("If members have any questions or suggestions regarding this Policy, please contact the Secretary of ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" using email at this address: ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","panel no-margins");
        var el2 = dom.createElement("sub");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("* Some elements of this privacy, and in some situations entire paragraphs, are borrowed from ");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","http://www.meetup.com/privacy/");
        var el4 = dom.createElement("span");
        var el5 = dom.createTextNode("Meetup.com's Privacy Policy.");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Thank you, Meetup.com, for doing most of the monontonous hardwork that no one is going to read :-)");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("sub");
        var el3 = dom.createTextNode("This Privacy Policy is governed by the terms of the ");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode(" Terms of Service Agreement, including but not limited to Section 17 of such Terms of Service Agreement.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [2]);
        var element1 = dom.childAt(element0, [0, 1]);
        var element2 = dom.childAt(element1, [1, 1]);
        var element3 = dom.childAt(element2, [3, 0]);
        var element4 = dom.childAt(element0, [3]);
        var element5 = dom.childAt(element4, [1, 0, 0]);
        var element6 = dom.childAt(element0, [4, 1, 0, 0]);
        var element7 = dom.childAt(element0, [7, 1, 0, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element1, [0, 0]),1,1);
        var morph2 = dom.createMorphAt(dom.childAt(element2, [1, 0]),1,1);
        var morph3 = dom.createMorphAt(element3,1,1);
        var morph4 = dom.createMorphAt(element3,3,3);
        var morph5 = dom.createMorphAt(dom.childAt(element4, [0]),1,1);
        var morph6 = dom.createMorphAt(element5,1,1);
        var morph7 = dom.createMorphAt(element5,3,3);
        var morph8 = dom.createMorphAt(element5,5,5);
        var morph9 = dom.createMorphAt(element6,1,1);
        var morph10 = dom.createMorphAt(element6,3,3);
        var morph11 = dom.createMorphAt(element7,1,1);
        var morph12 = dom.createMorphAt(element7,3,3);
        var morph13 = dom.createMorphAt(dom.childAt(fragment, [6, 3]),1,1);
        inline(env, morph0, context, "t", ["appname"], {});
        inline(env, morph1, context, "t", ["appname"], {});
        inline(env, morph2, context, "t", ["appname"], {});
        inline(env, morph3, context, "t", ["appname"], {});
        inline(env, morph4, context, "t", ["appname"], {});
        inline(env, morph5, context, "t", ["appname"], {});
        inline(env, morph6, context, "t", ["appname"], {});
        inline(env, morph7, context, "t", ["appname"], {});
        inline(env, morph8, context, "t", ["appname"], {});
        inline(env, morph9, context, "t", ["appname"], {});
        inline(env, morph10, context, "t", ["appname"], {});
        inline(env, morph11, context, "t", ["appname"], {});
        content(env, morph12, context, "mali-support-link");
        inline(env, morph13, context, "t", ["appname"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/tos', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("recent updates");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child1 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Non-Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    var child2 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","imageoverlay callout text-center panel");
        var el2 = dom.createElement("h2");
        dom.setAttribute(el2,"class","terms-title");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createTextNode(" Terms of Service Agreement");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("table");
        dom.setAttribute(el2,"class","center-margin");
        var el3 = dom.createElement("tr");
        var el4 = dom.createElement("td");
        dom.setAttribute(el4,"class","status");
        var el5 = dom.createElement("h6");
        var el6 = dom.createElement("em");
        var el7 = dom.createTextNode("Last updated: February 17, 2014");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h6");
        var el6 = dom.createElement("em");
        var el7 = dom.createComment("");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("td");
        dom.setAttribute(el4,"class","tos");
        var el5 = dom.createElement("h5");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        var el6 = dom.createTextNode(" | ");
        dom.appendChild(el5, el6);
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","surround-padding-20");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","terms");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline, block = hooks.block, content = hooks.content;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [2, 0]);
        var element2 = dom.childAt(element1, [1, 0]);
        var morph0 = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        var morph1 = dom.createMorphAt(dom.childAt(element1, [0, 1, 0]),0,0);
        var morph2 = dom.createMorphAt(element2,0,0);
        var morph3 = dom.createMorphAt(element2,2,2);
        var morph4 = dom.createMorphAt(dom.childAt(fragment, [1, 0]),0,0);
        inline(env, morph0, context, "t", ["appname"], {});
        block(env, morph1, context, "link-to", ["welcome.tos.updates"], {}, child0, null);
        block(env, morph2, context, "link-to", ["welcome.tos.non-organizers"], {}, child1, null);
        block(env, morph3, context, "link-to", ["welcome.tos.organizers"], {}, child2, null);
        content(env, morph4, context, "outlet");
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/tos/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, inline = hooks.inline;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, null);
        dom.insertBoundary(fragment, 0);
        inline(env, morph0, context, "render", ["welcome.tos.organizers"], {});
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/tos/non-organizers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        isHTMLBars: true,
        revision: "Ember@1.11.1",
        blockParams: 0,
        cachedFragment: null,
        hasRendered: false,
        build: function build(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        render: function render(context, env, contextualElement) {
          var dom = env.dom;
          dom.detectNamespace(contextualElement);
          var fragment;
          if (env.useFragmentCache && dom.canClone) {
            if (this.cachedFragment === null) {
              fragment = this.build(dom);
              if (this.hasRendered) {
                this.cachedFragment = fragment;
              } else {
                this.hasRendered = true;
              }
            }
            if (this.cachedFragment) {
              fragment = dom.cloneNode(this.cachedFragment, true);
            }
          } else {
            fragment = this.build(dom);
          }
          return fragment;
        }
      };
    }());
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Non-Organizers");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("ÆONVERA is a platform for organizers to quickly set up pain-free registration for an event, manage at-the-door changes to registrations, and the sales of à la carte items.  Below, resides the Terms of Service for ÆONVERA, which governs acceptable use and conditions for the services provided by ÆONVERA.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("Everything under the ");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode(" agreement is applicable to non-organizers as well.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        var hooks = env.hooks, block = hooks.block;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        var morph0 = dom.createMorphAt(dom.childAt(fragment, [3]),1,1);
        block(env, morph0, context, "link-to", ["welcome.tos.organizers"], {}, child0, null);
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/tos/organizers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Organizers");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("Please read these Terms of Service (\"Agreement\", \"Terms of Service\") carefully before using http://aeonvera.com (\"the Site\") operated by Precognition LLC (\"us\", \"we\", or \"our\"). This Agreement sets forth the legally binding terms and conditions for your use of the Site at http://aeonvera.com.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("By accessing or using the Site in any manner, including, but not limited to, visiting or browsing the Site or contributing content or other materials to the Site, you agree to be bound by these Terms of Service. Capitalized terms are defined in this Agreement.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Intellectual Property");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("The Site and its original content, features and functionality are owned by Precognition LLC and are protected by international copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Termination");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("We may terminate your access to the Site, without cause or notice, which may result in the forfeiture and destruction of all information associated with you. All provisions of this Agreement that by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Links To Other Sites");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("Our Site may contain links to third-party sites that are not owned or controlled by Precognition LLC.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("Precognition LLC has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party sites or services. We strongly advise you to read the terms and conditions and privacy policy of any third-party site that you visit.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Governing Law");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("This Agreement (and any further rules, polices, or guidelines incorporated by reference) shall be governed and construed in accordance with the laws of Indiana, United States, without giving effect to any principles of conflicts of law.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Changes To This Agreement");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("The reserve the right, at our sole discretion, to modify or replace these Terms of Service by posting the updated terms on the Site. Your continued use of the Site after any such changes constitutes your acceptance of the new Terms of Service.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createTextNode("Please review this Agreement periodically for changes. If you do not agree to any of this Agreement or any changes to this Agreement, do not use, access or continue to access the Site or discontinue any use of the Site immediately.");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createElement("strong");
        var el3 = dom.createTextNode("Contact Us");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createTextNode("If you have any questions about this Agreement, please contact us.");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/templates/welcome/tos/updates', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      isHTMLBars: true,
      revision: "Ember@1.11.1",
      blockParams: 0,
      cachedFragment: null,
      hasRendered: false,
      build: function build(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Updates");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("h4");
        var el2 = dom.createTextNode("Februray 17, 2014");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("ul");
        var el2 = dom.createElement("li");
        var el3 = dom.createTextNode("Initial Version based off of the ");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","http://www.eventbrite.com/tos/");
        var el3 = dom.createTextNode("EventBrite ToS");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      render: function render(context, env, contextualElement) {
        var dom = env.dom;
        dom.detectNamespace(contextualElement);
        var fragment;
        if (env.useFragmentCache && dom.canClone) {
          if (this.cachedFragment === null) {
            fragment = this.build(dom);
            if (this.hasRendered) {
              this.cachedFragment = fragment;
            } else {
              this.hasRendered = true;
            }
          }
          if (this.cachedFragment) {
            fragment = dom.cloneNode(this.cachedFragment, true);
          }
        } else {
          fragment = this.build(dom);
        }
        return fragment;
      }
    };
  }()));

});
define('aeonvera/tests/adapters/application.jshint', function () {

  'use strict';

  module('JSHint - adapters');
  test('adapters/application.js should pass jshint', function() { 
    ok(true, 'adapters/application.js should pass jshint.'); 
  });

});
define('aeonvera/tests/app.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('app.js should pass jshint', function() { 
    ok(true, 'app.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/error-field-wrapper.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/error-field-wrapper.js should pass jshint', function() { 
    ok(true, 'components/error-field-wrapper.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/fixed-top-nav.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/fixed-top-nav.js should pass jshint', function() { 
    ok(true, 'components/fixed-top-nav.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/how-to-pronounce-ae.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/how-to-pronounce-ae.js should pass jshint', function() { 
    ok(true, 'components/how-to-pronounce-ae.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/links/aeon-wikipedia-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/aeon-wikipedia-link.js should pass jshint', function() { 
    ok(true, 'components/links/aeon-wikipedia-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/links/external-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/external-link.js should pass jshint', function() { 
    ok(true, 'components/links/external-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/links/facebook-icon-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/facebook-icon-link.js should pass jshint', function() { 
    ok(true, 'components/links/facebook-icon-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/links/mail-support-icon-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/mail-support-icon-link.js should pass jshint', function() { 
    ok(true, 'components/links/mail-support-icon-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/links/mail-support-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/mail-support-link.js should pass jshint', function() { 
    ok(true, 'components/links/mail-support-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/login-help-modal.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/login-help-modal.js should pass jshint', function() { 
    ok(true, 'components/login-help-modal.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/login-modal.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/login-modal.js should pass jshint', function() { 
    ok(true, 'components/login-modal.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/dashboard/right-items.jshint', function () {

  'use strict';

  module('JSHint - components/nav/dashboard');
  test('components/nav/dashboard/right-items.js should pass jshint', function() { 
    ok(true, 'components/nav/dashboard/right-items.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/left-off-canvas-menu.jshint', function () {

  'use strict';

  module('JSHint - components/nav');
  test('components/nav/left-off-canvas-menu.js should pass jshint', function() { 
    ok(true, 'components/nav/left-off-canvas-menu.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/right-off-canvas-menu.jshint', function () {

  'use strict';

  module('JSHint - components/nav');
  test('components/nav/right-off-canvas-menu.js should pass jshint', function() { 
    ok(true, 'components/nav/right-off-canvas-menu.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/welcome/left-items.jshint', function () {

  'use strict';

  module('JSHint - components/nav/welcome');
  test('components/nav/welcome/left-items.js should pass jshint', function() { 
    ok(true, 'components/nav/welcome/left-items.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/welcome/right-items.jshint', function () {

  'use strict';

  module('JSHint - components/nav/welcome');
  test('components/nav/welcome/right-items.js should pass jshint', function() { 
    ok(true, 'components/nav/welcome/right-items.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/nav/welcome/top-menu.jshint', function () {

  'use strict';

  module('JSHint - components/nav/welcome');
  test('components/nav/welcome/top-menu.js should pass jshint', function() { 
    ok(true, 'components/nav/welcome/top-menu.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/pricing-preview.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/pricing-preview.js should pass jshint', function() { 
    ok(true, 'components/pricing-preview.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/sign-up-modal.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/sign-up-modal.js should pass jshint', function() { 
    ok(true, 'components/sign-up-modal.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/tool-tip.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/tool-tip.js should pass jshint', function() { 
    ok(true, 'components/tool-tip.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/application.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/application.js should pass jshint', function() { 
    ok(true, 'controllers/application.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/login.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/login.js should pass jshint', function() { 
    ok(true, 'controllers/login.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/welcome.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/welcome.js should pass jshint', function() { 
    ok(true, 'controllers/welcome.js should pass jshint.'); 
  });

});
define('aeonvera/tests/ember-cli-i18n-test', ['ember', 'aeonvera/config/environment'], function (Ember, config) {

  'use strict';

  /* globals requirejs, require */

  if (window.QUnit) {
    var keys = Ember['default'].keys;

    var locales, defaultLocale;
    module('ember-cli-i18n', {
      setup: function setup() {
        var localRegExp = new RegExp(config['default'].modulePrefix + '/locales/(.+)');
        var match, moduleName;

        locales = {};

        for (moduleName in requirejs.entries) {
          if (match = moduleName.match(localRegExp)) {
            locales[match[1]] = require(moduleName)['default'];
          }
        }

        defaultLocale = locales[config['default'].APP.defaultLocale];
      }
    });

    test('locales all contain the same keys', function () {
      var knownLocales = keys(locales);
      if (knownLocales.length === 1) {
        expect(0);
        return;
      }

      for (var i = 0, l = knownLocales.length; i < l; i++) {
        var currentLocale = locales[knownLocales[i]];

        if (currentLocale === defaultLocale) {
          continue;
        }

        for (var translationKey in defaultLocale) {
          ok(currentLocale[translationKey], '`' + translationKey + '` should exist in the `' + knownLocales[i] + '` locale.');
        }
      }
    });
  }

});
define('aeonvera/tests/helpers/date-range.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/date-range.js should pass jshint', function() { 
    ok(true, 'helpers/date-range.js should pass jshint.'); 
  });

});
define('aeonvera/tests/helpers/date-with-format.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/date-with-format.js should pass jshint', function() { 
    ok(true, 'helpers/date-with-format.js should pass jshint.'); 
  });

});
define('aeonvera/tests/helpers/flash-message', ['ember-cli-flash/flash/object'], function (FlashObject) {

	'use strict';

	FlashObject['default'].reopen({ _destroyLater: null });

});
define('aeonvera/tests/helpers/flash-message.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/flash-message.js should pass jshint', function() { 
    ok(true, 'helpers/flash-message.js should pass jshint.'); 
  });

});
define('aeonvera/tests/helpers/resolver', ['exports', 'ember/resolver', 'aeonvera/config/environment'], function (exports, Resolver, config) {

  'use strict';

  var resolver = Resolver['default'].create();

  resolver.namespace = {
    modulePrefix: config['default'].modulePrefix,
    podModulePrefix: config['default'].podModulePrefix
  };

  exports['default'] = resolver;

});
define('aeonvera/tests/helpers/resolver.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/resolver.js should pass jshint', function() { 
    ok(true, 'helpers/resolver.js should pass jshint.'); 
  });

});
define('aeonvera/tests/helpers/start-app', ['exports', 'ember', 'aeonvera/app', 'aeonvera/router', 'aeonvera/config/environment'], function (exports, Ember, Application, Router, config) {

  'use strict';



  exports['default'] = startApp;
  function startApp(attrs) {
    var application;

    var attributes = Ember['default'].merge({}, config['default'].APP);
    attributes = Ember['default'].merge(attributes, attrs); // use defaults, but you can override;

    Ember['default'].run(function () {
      application = Application['default'].create(attributes);
      application.setupForTesting();
      application.injectTestHelpers();
    });

    return application;
  }

});
define('aeonvera/tests/helpers/start-app.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/start-app.js should pass jshint', function() { 
    ok(true, 'helpers/start-app.js should pass jshint.'); 
  });

});
define('aeonvera/tests/helpers/submit-idea-link.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/submit-idea-link.js should pass jshint', function() { 
    ok(true, 'helpers/submit-idea-link.js should pass jshint.'); 
  });

});
define('aeonvera/tests/initializers/link-to-with-action.jshint', function () {

  'use strict';

  module('JSHint - initializers');
  test('initializers/link-to-with-action.js should pass jshint', function() { 
    ok(true, 'initializers/link-to-with-action.js should pass jshint.'); 
  });

});
define('aeonvera/tests/initializers/simple-auth-devise-override.jshint', function () {

  'use strict';

  module('JSHint - initializers');
  test('initializers/simple-auth-devise-override.js should pass jshint', function() { 
    ok(true, 'initializers/simple-auth-devise-override.js should pass jshint.'); 
  });

});
define('aeonvera/tests/locales/en.jshint', function () {

  'use strict';

  module('JSHint - locales');
  test('locales/en.js should pass jshint', function() { 
    ok(true, 'locales/en.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/attended-event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/attended-event.js should pass jshint', function() { 
    ok(true, 'models/attended-event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/community.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/community.js should pass jshint', function() { 
    ok(true, 'models/community.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/competition.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/competition.js should pass jshint', function() { 
    ok(true, 'models/competition.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/event.js should pass jshint', function() { 
    ok(true, 'models/event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/level.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/level.js should pass jshint', function() { 
    ok(true, 'models/level.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/package.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/package.js should pass jshint', function() { 
    ok(true, 'models/package.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/upcoming-event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/upcoming-event.js should pass jshint', function() { 
    ok(true, 'models/upcoming-event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/user.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/user.js should pass jshint', function() { 
    ok(true, 'models/user.js should pass jshint.'); 
  });

});
define('aeonvera/tests/router.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('router.js should pass jshint', function() { 
    ok(true, 'router.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/application.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/application.js should pass jshint', function() { 
    ok(true, 'routes/application.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/attended-events.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/attended-events.js should pass jshint', function() { 
    ok(true, 'routes/attended-events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/communities.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/communities.js should pass jshint', function() { 
    ok(true, 'routes/communities.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/dashboard.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/dashboard.js should pass jshint', function() { 
    ok(true, 'routes/dashboard.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/events.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/events.js should pass jshint', function() { 
    ok(true, 'routes/events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/login.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/login.js should pass jshint', function() { 
    ok(true, 'routes/login.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/register.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/register.js should pass jshint', function() { 
    ok(true, 'routes/register.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/upcoming-events.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/upcoming-events.js should pass jshint', function() { 
    ok(true, 'routes/upcoming-events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/welcome.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/welcome.js should pass jshint', function() { 
    ok(true, 'routes/welcome.js should pass jshint.'); 
  });

});
define('aeonvera/tests/services/current-registering-object.jshint', function () {

  'use strict';

  module('JSHint - services');
  test('services/current-registering-object.js should pass jshint', function() { 
    ok(true, 'services/current-registering-object.js should pass jshint.'); 
  });

});
define('aeonvera/tests/services/current-user.jshint', function () {

  'use strict';

  module('JSHint - services');
  test('services/current-user.js should pass jshint', function() { 
    ok(true, 'services/current-user.js should pass jshint.'); 
  });

});
define('aeonvera/tests/test-helper', ['aeonvera/tests/helpers/resolver', 'aeonvera/tests/helpers/flash-message', 'ember-qunit'], function (resolver, flashMessageHelper, ember_qunit) {

	'use strict';

	ember_qunit.setResolver(resolver['default']);

});
define('aeonvera/tests/test-helper.jshint', function () {

  'use strict';

  module('JSHint - .');
  test('test-helper.js should pass jshint', function() { 
    ok(true, 'test-helper.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/error-field-wrapper-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('error-field-wrapper', 'Unit | Component | error field wrapper', {
    // Specify the other units that are required for this test
    // needs: ['component:foo', 'helper:bar'],
    unit: true
  });

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

});
define('aeonvera/tests/unit/components/error-field-wrapper-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/error-field-wrapper-test.js should pass jshint', function() { 
    ok(true, 'unit/components/error-field-wrapper-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/external-link-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('external-link', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/external-link-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/external-link-test.js should pass jshint', function() { 
    ok(true, 'unit/components/external-link-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/login-help-modal-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('login-help-modal', 'Unit | Component | login help modal', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/login-help-modal-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/login-help-modal-test.js should pass jshint', function() { 
    ok(true, 'unit/components/login-help-modal-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/login-modal-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('login-modal', 'Unit | Component | login modal', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/login-modal-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/login-modal-test.js should pass jshint', function() { 
    ok(true, 'unit/components/login-modal-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/nav/left-off-canvas-menu-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('nav/left-off-canvas-menu', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/nav/left-off-canvas-menu-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components/nav');
  test('unit/components/nav/left-off-canvas-menu-test.js should pass jshint', function() { 
    ok(true, 'unit/components/nav/left-off-canvas-menu-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/nav/right-off-canvas-menu-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('nav/right-off-canvas-menu', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/nav/right-off-canvas-menu-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components/nav');
  test('unit/components/nav/right-off-canvas-menu-test.js should pass jshint', function() { 
    ok(true, 'unit/components/nav/right-off-canvas-menu-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/nav/welcome/left-items-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('nav/welcome/left-items', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/nav/welcome/left-items-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components/nav/welcome');
  test('unit/components/nav/welcome/left-items-test.js should pass jshint', function() { 
    ok(true, 'unit/components/nav/welcome/left-items-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/nav/welcome/right-items-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('nav/welcome/right-items', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/nav/welcome/right-items-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components/nav/welcome');
  test('unit/components/nav/welcome/right-items-test.js should pass jshint', function() { 
    ok(true, 'unit/components/nav/welcome/right-items-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/nav/welcome/top-menu-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('nav/welcome/top-menu', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/nav/welcome/top-menu-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components/nav/welcome');
  test('unit/components/nav/welcome/top-menu-test.js should pass jshint', function() { 
    ok(true, 'unit/components/nav/welcome/top-menu-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/pricing-preview-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('pricing-preview', {});

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

  // Specify the other units that are required for this test
  // needs: ['component:foo', 'helper:bar']

});
define('aeonvera/tests/unit/components/pricing-preview-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/pricing-preview-test.js should pass jshint', function() { 
    ok(true, 'unit/components/pricing-preview-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/components/tool-tip-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForComponent('tool-tip', 'Unit | Component | tool tip', {
    // Specify the other units that are required for this test
    // needs: ['component:foo', 'helper:bar'],
    unit: true
  });

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Creates the component instance
    var component = this.subject();
    assert.equal(component._state, 'preRender');

    // Renders the component to the page
    this.render();
    assert.equal(component._state, 'inDOM');
  });

});
define('aeonvera/tests/unit/components/tool-tip-test.jshint', function () {

  'use strict';

  module('JSHint - unit/components');
  test('unit/components/tool-tip-test.js should pass jshint', function() { 
    ok(true, 'unit/components/tool-tip-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/controllers/application-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('controller:application', {});

  // Replace this with your real tests.
  ember_qunit.test('it exists', function (assert) {
    var controller = this.subject();
    assert.ok(controller);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/controllers/application-test.jshint', function () {

  'use strict';

  module('JSHint - unit/controllers');
  test('unit/controllers/application-test.js should pass jshint', function() { 
    ok(true, 'unit/controllers/application-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/controllers/login-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('controller:login', {});

  // Replace this with your real tests.
  ember_qunit.test('it exists', function (assert) {
    var controller = this.subject();
    assert.ok(controller);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/controllers/login-test.jshint', function () {

  'use strict';

  module('JSHint - unit/controllers');
  test('unit/controllers/login-test.js should pass jshint', function() { 
    ok(true, 'unit/controllers/login-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/controllers/welcome-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('controller:welcome', {});

  // Replace this with your real tests.
  ember_qunit.test('it exists', function (assert) {
    var controller = this.subject();
    assert.ok(controller);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/controllers/welcome-test.jshint', function () {

  'use strict';

  module('JSHint - unit/controllers');
  test('unit/controllers/welcome-test.js should pass jshint', function() { 
    ok(true, 'unit/controllers/welcome-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/helpers/date-range-test', ['aeonvera/helpers/date-range', 'qunit'], function (date_range, qunit) {

  'use strict';

  qunit.module('Unit | Helper | date range');

  // Replace this with your real tests.
  qunit.test('it works', function (assert) {
    var result = date_range.dateRange(42);
    assert.ok(result);
  });

});
define('aeonvera/tests/unit/helpers/date-range-test.jshint', function () {

  'use strict';

  module('JSHint - unit/helpers');
  test('unit/helpers/date-range-test.js should pass jshint', function() { 
    ok(true, 'unit/helpers/date-range-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/helpers/date-with-format-test', ['aeonvera/helpers/date-with-format', 'qunit'], function (date_with_format, qunit) {

  'use strict';

  qunit.module('Unit | Helper | date with format');

  // Replace this with your real tests.
  qunit.test('it works', function (assert) {
    var result = date_with_format.dateWithFormat(42);
    assert.ok(result);
  });

});
define('aeonvera/tests/unit/helpers/date-with-format-test.jshint', function () {

  'use strict';

  module('JSHint - unit/helpers');
  test('unit/helpers/date-with-format-test.js should pass jshint', function() { 
    ok(true, 'unit/helpers/date-with-format-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/attended-event-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('attended-event', 'Unit | Model | attended event', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/attended-event-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/attended-event-test.js should pass jshint', function() { 
    ok(true, 'unit/models/attended-event-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/community-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('community', 'Unit | Model | community', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/community-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/community-test.js should pass jshint', function() { 
    ok(true, 'unit/models/community-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/competition-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('competition', 'Unit | Model | competition', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/competition-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/competition-test.js should pass jshint', function() { 
    ok(true, 'unit/models/competition-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/current-registring-event-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('current-registring-event', 'Unit | Model | current registring event', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/current-registring-event-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/current-registring-event-test.js should pass jshint', function() { 
    ok(true, 'unit/models/current-registring-event-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/event-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('event', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/event-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/event-test.js should pass jshint', function() { 
    ok(true, 'unit/models/event-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/level-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('level', 'Unit | Model | level', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/level-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/level-test.js should pass jshint', function() { 
    ok(true, 'unit/models/level-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/package-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('package', 'Unit | Model | package', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/package-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/package-test.js should pass jshint', function() { 
    ok(true, 'unit/models/package-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/models/user-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleForModel('user', 'Unit | Model | user', {
    // Specify the other units that are required for this test.
    needs: []
  });

  ember_qunit.test('it exists', function (assert) {
    var model = this.subject();
    // var store = this.store();
    assert.ok(!!model);
  });

});
define('aeonvera/tests/unit/models/user-test.jshint', function () {

  'use strict';

  module('JSHint - unit/models');
  test('unit/models/user-test.js should pass jshint', function() { 
    ok(true, 'unit/models/user-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/application-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:application', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/application-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/application-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/application-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/attended-events-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:attended-events', 'Unit | Route | attended events', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/attended-events-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/attended-events-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/attended-events-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/communities-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:communities', 'Unit | Route | communities', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/communities-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/communities-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/communities-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/dashboard-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:dashboard', 'Unit | Route | dashboard', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/dashboard-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/dashboard-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/dashboard-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/events-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:events', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/events-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/events-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/events-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/login-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:login', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/login-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/login-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/login-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/register-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:register', 'Unit | Route | register', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/register-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/register-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/register-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/upcoming-events-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:upcoming-events', 'Unit | Route | upcoming events', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/upcoming-events-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/upcoming-events-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/upcoming-events-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/routes/welcome-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:welcome', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/welcome-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/welcome-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/welcome-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/services/current-registering-object-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('service:current-registering-object', 'Unit | Service | current registering object', {});

  // Replace this with your real tests.
  ember_qunit.test('it exists', function (assert) {
    var service = this.subject();
    assert.ok(service);
  });

  // Specify the other units that are required for this test.
  // needs: ['service:foo']

});
define('aeonvera/tests/unit/services/current-registering-object-test.jshint', function () {

  'use strict';

  module('JSHint - unit/services');
  test('unit/services/current-registering-object-test.js should pass jshint', function() { 
    ok(true, 'unit/services/current-registering-object-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/unit/services/current-user-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('service:current-user', 'Unit | Service | current user', {});

  // Replace this with your real tests.
  ember_qunit.test('it exists', function (assert) {
    var service = this.subject();
    assert.ok(service);
  });

  // Specify the other units that are required for this test.
  // needs: ['service:foo']

});
define('aeonvera/tests/unit/services/current-user-test.jshint', function () {

  'use strict';

  module('JSHint - unit/services');
  test('unit/services/current-user-test.js should pass jshint', function() { 
    ok(true, 'unit/services/current-user-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/views/application.jshint', function () {

  'use strict';

  module('JSHint - views');
  test('views/application.js should pass jshint', function() { 
    ok(true, 'views/application.js should pass jshint.'); 
  });

});
define('aeonvera/views/application', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].View.extend({ //or Ember.Component.extend

    initFoundation: (function () {
      this.$(document).foundation();
    }).on('didInsertElement')

  });

});
/* jshint ignore:start */

/* jshint ignore:end */

/* jshint ignore:start */

define('aeonvera/config/environment', ['ember'], function(Ember) {
  var prefix = 'aeonvera';
/* jshint ignore:start */

try {
  var metaName = prefix + '/config/environment';
  var rawConfig = Ember['default'].$('meta[name="' + metaName + '"]').attr('content');
  var config = JSON.parse(unescape(rawConfig));

  return { 'default': config };
}
catch(err) {
  throw new Error('Could not read config from meta tag with name "' + metaName + '".');
}

/* jshint ignore:end */

});

if (runningTests) {
  require("aeonvera/tests/test-helper");
} else {
  require("aeonvera/app")["default"].create({"defaultLocale":"en","name":"aeonvera","version":"0.0.0.507f3b26"});
}

/* jshint ignore:end */
//# sourceMappingURL=aeonvera.map