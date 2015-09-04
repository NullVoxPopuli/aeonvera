"use strict";
/* jshint ignore:start */

/* jshint ignore:end */

define('aeonvera/adapters/application', ['exports', 'ember-data', 'aeonvera/config/environment'], function (exports, DS, ENV) {

  'use strict';

  exports['default'] = DS['default'].ActiveModelAdapter.extend({
    namespace: 'api',
    host: ENV['default'].host
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
define('aeonvera/components/attendance-list', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({

    attendances: (function () {
      return this.get('model');
    }).property('model'),

    attendancesPresent: (function () {
      return true;
    }).property('model')
  });

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
define('aeonvera/components/event-at-the-door/checkin-attendance', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'tr',

    actions: {
      pay: function pay() {},

      payViaCash: function payViaCash() {},

      payViaCheck: function payViaCheck() {},

      checkin: function checkin(attendance) {
        attendance.set('checkedInAt', new Date());
        attendance.save();
      }

    }
  });

});
define('aeonvera/components/event-at-the-door/checkin-list', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    queryText: '',
    showOnlyNonCheckedIn: false,
    showOnlyThoseWhoOweMoney: false,

    activeRegistrant: null,

    attendances: (function () {
      var model = this.get('model');
      var query = this.get('queryText');
      var queryPresent = Ember['default'].isPresent(query);
      var onlyNonCheckedIn = this.get('showOnlyNonCheckedIn');
      var onlyOweMoney = this.get('showOnlyThoseWhoOweMoney');
      var lowerQuery = query.toLowerCase();

      var filtered = model;

      if (onlyNonCheckedIn) {
        filtered = filtered.filterBy('isCheckedIn', false);
      }

      if (onlyOweMoney) {
        filtered = filtered.filterBy('owesMoney');
      }

      if (queryPresent) {
        filtered = filtered.filterBy('attendeeName', function (ea) {
          var name = ea.get('attendeeName').toLowerCase();
          return name.indexOf(lowerQuery) !== -1;
        });
      }

      return filtered;
    }).property('model', 'queryText', 'showOnlyNonCheckedIn', 'showOnlyThoseWhoOweMoney'),

    percentCheckedIn: (function () {
      var checkedIn = this.get('numberCheckedIn');
      /* var checkedOut = this.get('numberCheckedOut'); */
      var total = this.get('model').get('length');
      var percent = checkedIn / total * 100;

      return Math.round(percent, 2);
    }).property('model.@each.isCheckedIn'),

    numberCheckedIn: (function () {
      var model = this.get('model');
      return model.filterBy('isCheckedIn').get('length');
    }).property('model.@each.isCheckedIn'),

    numberNotCheckedIn: (function () {
      var model = this.get('model');
      return model.filterBy('isCheckedIn', false).get('length');
    }).property('model.@each.isCheckedIn'),

    actions: {

      setActiveRegistrant: function setActiveRegistrant(attendance) {
        this.set('activeRegistrant', attendance);
      }
    }

  });

});
define('aeonvera/components/fixed-top-nav', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    i18n: Ember['default'].inject.service(),

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
      return this.get('i18n').t('appname');
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
define('aeonvera/components/foundation-modal', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    title: '',
    name: '',
    role: 'dialog',
    hidden: true,
    reveal: true,

    classNames: ['reveal-modal', 'medium'],

    attributeBindings: ['reveal:data-reveal', 'titleId:aria-labledby', 'hidden:aria-hidden', 'role', 'elementId:id'],

    initFoundation: (function () {
      this.$(document).foundation('reflow');
    }).on('didInsertElement'),

    modalName: (function () {
      var dashedName = (this.get('name') || '').dasherize();
      var dashedTitle = this.get('title').dasherize();
      return Ember['default'].isPresent(dashedName) ? dashedName : dashedTitle;
    }).property('title', 'name'),

    elementId: (function () {
      return this.get('modalName') + '-modal';
    }).property('modalName'),

    titleId: (function () {
      return this.get('elementId') + '-title';
    }).property('elementId')

  });

});
define('aeonvera/components/handle-payment', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    title: 'Choose Payment Method',

    checkNumber: '',

    order: (function () {
      return this.get('model');
    }).property('model'),

    amount: (function () {
      return this.get('order.subTotal');
    }).property('order', 'order.subTotal'),

    actions: {
      process: function process(paymentMethod) {
        this.get('targetObject').send('process', {
          checkNumber: this.get('checkNumber'),
          paymentMethod: paymentMethod
        });
      },

      processStripeToken: function processStripeToken(args) {
        this.get('targetObject').send('processStripeToken', args);
      }
    }

  });

});
define('aeonvera/components/how-to-pronounce-ae', ['exports', 'aeonvera/components/links/external-link'], function (exports, ExternalLink) {

	'use strict';

	exports['default'] = ExternalLink['default'].extend({
		layoutName: 'components/links/external-link',
		href: 'http://english.stackexchange.com/questions/70927',
		text: 'English Stack Exchange'
	});

});
define('aeonvera/components/labeled-radio-button', ['exports', 'ember-radio-button/components/labeled-radio-button'], function (exports, LabeledRadioButton) {

	'use strict';

	exports['default'] = LabeledRadioButton['default'];

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
define('aeonvera/components/links/submit-idea-link', ['exports', 'ember', 'aeonvera/components/links/external-link'], function (exports, Ember, ExternalLink) {

  'use strict';

  exports['default'] = ExternalLink['default'].extend({
    i18n: Ember['default'].inject.service(),

    layoutName: 'components/links/external-link',
    href: 'https://github.com/NullVoxPopuli/aeonvera/issues?state=open',

    text: (function () {
      return this.get('i18n').t('submitideas');
    }).property()
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
        localStorage.clear();
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
        localStorage.clear();
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
        localStorage.clear();
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
define('aeonvera/components/radio-button-input', ['exports', 'ember-radio-button/components/radio-button-input'], function (exports, RadioButtonInput) {

	'use strict';

	exports['default'] = RadioButtonInput['default'];

});
define('aeonvera/components/radio-button', ['exports', 'ember-radio-button/components/radio-button'], function (exports, RadioButton) {

	'use strict';

	exports['default'] = RadioButton['default'];

});
define('aeonvera/components/select-2', ['exports', 'ember-select-2/components/select-2'], function (exports, Select2Component) {

	'use strict';

	/*
		This is just a proxy file requiring the component from the /addon folder and
		making it available to the dummy application!
	 */
	exports['default'] = Select2Component['default'];

});
define('aeonvera/components/sidebar-container', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({});

});
define('aeonvera/components/sidebar/dashboard-sidebar', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({});

});
define('aeonvera/components/sidebar/event-at-the-door-sidebar', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Component.extend({});

});
define('aeonvera/components/sidebar/event-sidebar', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    event: Ember['default'].computed.alias('model')
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
define('aeonvera/components/stripe-checkout', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, config) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({
    tagName: 'button',
    classNames: ['stripe-checkout'],
    attributeBindings: ['isDisabled:disabled'],

    /**********************************
     * Required attributes
     **********************************/

    /**
     * Your publishable key (test or live).
     */
    key: config['default'].stripe.key,

    /**********************************
     * Highly recommended attributes
     **********************************/

    /**
     * A relative URL pointing to a square image of your brand or
     * product. The recommended minimum size is 128x128px.
     * Eg. "/square-image.png"
     */
    image: null,

    /**
     * The name of your company or website.
     */
    name: 'Demo Site',

    /**
     * A description of the product or service being purchased.
     */
    description: '2 widgets ($20.00)',

    /**
     * The amount (in cents) that's shown to the user. Note that you
     * will still have to explicitly include it when you create a
     * charge using the Stripe API.
     */
    amount: 2000,

    /**********************************
     * Optional attributes
     **********************************/

    /**
     * Accept Bitcoin payments.
     */
    bitcoin: false,

    /**
     * The currency of the amount (3-letter ISO code). The default is USD.
     */
    currency: 'USD',

    /**
     * The label of the payment button in the Checkout form (e.g. “Subscribe”,
     * “Pay {{amount}}”, etc.). If you include {{amount}}, it will be replaced
     * by the provided amount. Otherwise, the amount will be appended to the
     * end of your label.
     */
    panelLabel: null,

    /**
     * Specify whether Checkout should validate the billing ZIP code
     * (true or false). The default is false.
     */
    zipCode: false,

    /**
     * Specify whether Checkout should collect the customer's billing address
     * (true or false). The default is false.
     */
    address: false,

    /**
     * If you already know the email address of your user, you can provide
     * it to Checkout to be pre-filled.
     */
    email: null,

    /**
     * The text to be shown on the default blue button.
     */
    label: 'Pay with card',

    /**
     * Specify whether to include the option to "Remember Me" for future
     * purchases (true or false). The default is true.
     */
    allowRememberMe: true,

    /**
     * Specify whether to include the option to use alipay to
     * checkout (true or false or auto). The default is false.
     */
    alipay: false,

    /**
     * Specify whether to reuse alipay information to
     * checkout (true or false). The default is false.
     */
    'alipay-reusable': false,

    /**
     * Specify language preference.
     */
    locale: config['default'].stripe.locale,

    /**********************************
     * Extras
     **********************************/

    /**
     * Bind to this attribute to disable the stripe
     * button until the user completes prior requirements
     * (like choosing a plan)
     */
    isDisabled: false,

    /**
     * Stripe handler
     */
    handler: null,

    /**
     * By default we add stripe button classes.
     * Set to false to disable Stripe styles
     *
     * TODO: Need to load stripe styles in order for this to apply
     */
    useStripeStyles: true,

    /**
     * Sets up Stripe and sends component action
     * with the Stripe token when checkout succeeds.
     *
     * The token looks like this
     * {
     *   "id": "tok_150enDGA2quO03uZPF8Nve2a",
     *   "livemode": false,
     *   "created": 1416427871,
     *   "used": false,
     *   "object": "token",
     *   "type": "card",
     *   "card": {
     *     "id": "card_150enDGA2quO03uZK8AwnT9x",
     *     "object": "card",
     *     "last4": "4242",
     *     "brand": "Visa",
     *     "funding": "credit",
     *     "exp_month": 8,
     *     "exp_year": 2015,
     *     "fingerprint": "AwGY3mROvhSpEvSc",
     *     "country": "US",
     *     "name": null,
     *     "address_line1": null,
     *     "address_line2": null,
     *     "address_city": null,
     *     "address_state": null,
     *     "address_zip": null,
     *     "address_country": null,
     *     "dynamic_last4": null,
     *     "customer": null
     *   }
     * }
     *
     * Source: https://stripe.com/docs/api#tokens
     */
    setupStripe: Ember['default'].on('init', function () {
      var self = this;

      if (Ember['default'].isNone(this.get('key'))) {
        throw ['Your Stripe key must be set to use the stripe-checkout component. ', 'Set the key in your environment.js file (ENV.stripe.key) or set the ', 'key property on the component when instantiating it in your hbs template. ', 'Find your Stripe publishable key at https://dashboard.stripe.com/account/apikeys'].join('\n');
      }

      var handler = StripeCheckout.configure({
        key: this.get('key'),
        locale: this.get('locale'),
        token: function token(_token) {
          self.sendAction('action', _token);
        },
        opened: function opened() {
          self.sendAction('opened');
        },
        closed: function closed() {
          self.sendAction('closed');
        }
      });
      this.set('handler', handler);
    }),

    /**
     * Kick up the modal if we're clicked
     */
    click: function click(e) {
      this.openModal();
      e.preventDefault();
    },

    /**
     * Opens the Stripe modal for payment
     */
    openModal: function openModal() {
      var options = this.getProperties(['image', 'name', 'description', 'amount', 'bitcoin', 'currency', 'panelLabel', 'zipCode', 'address', 'email', 'label', 'allowRememberMe', 'alipay', 'alipay-reusable']);
      this.get('handler').open(options);
    },

    closeOnDestroy: Ember['default'].on('willDestroyElement', function () {
      // Close modal if the user navigates away from page
      this.get('handler').close();
    })
  });

});
define('aeonvera/components/stripe/checkout-button', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Component.extend({

    host: (function () {
      return this.get('model').get('host');
    }).property('model'),

    image: (function () {
      return this.get('host.loguUrlMedium');
    }).property('host'),

    key: (function () {
      return this.get('host.stripePublishableKey');
    }).property('host'),

    emailForReceipt: (function () {
      return this.get('model.userEmail');
    }).property('model'),

    description: (function () {
      return this.get('host.name');
    }).property('host'),

    amountInCents: (function () {
      return this.get('model.totalInCents') || this.get('model.subTotal') * 100;
    }).property('model'),

    actions: {
      /**
       * Receives a Stripe token after checkout succeeds
       * The token looks like this https://stripe.com/docs/api#tokens
       */
      processStripeToken: function processStripeToken(args) {
        this.get('targetObject').send('processStripeToken', args);
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
define('aeonvera/controllers/dashboard', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Controller.extend({
    sidebar: null,
    data: null
  });

});
define('aeonvera/controllers/dashboard/hosted-events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Controller.extend({
    showMyEvents: false,

    /*
      TODO: make the checkbox call an action and then
      move this logic to the route
    */
    filteredModel: (function () {
      var store = this.store;
      var onlyMe = this.get('showMyEvents');

      if (onlyMe) {
        var promise = store.filter('hosted-event', function (e) {
          return e.get('myEvent');
        });

        return promise;
      } else {
        return store.all('hosted-event');
      }
    }).property('model.[]', 'showMyEvents')

  });

});
define('aeonvera/controllers/event-at-the-door/a-la-carte', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Controller.extend({
    atTheDoorController: Ember['default'].inject.controller('event-at-the-door'),
    event: Ember['default'].computed.reads('atTheDoorController.model'),

    itemsInOrder: [],

    currentOrder: null,

    sidebarContainerClasses: 'large-3 medium-4 columns',
    itemContainerClasses: 'large-9 medium-8 columns',

    defaultSidebarContainerClasses: 'large-3 medium-4 columns',
    defaultItemContainerClasses: 'large-9 medium-8 columns',

    buildingSidebarContainerClasses: 'large-3 medium-4 columns',
    buildingItemContainerClasses: 'large-6 medium-8 columns',
    orderContainerClasses: 'large-3 medium-3 columns',

    buildingAnOrder: (function () {
      var currentOrder = this.get('currentOrder');
      if (Ember['default'].isPresent(currentOrder)) {
        return true;
      }

      return false;
    }).property('currentOrder'),

    currentItems: (function () {
      return this.get('currentOrder.lineItems');
    }).property('currentOrder.lineItems.@each'),

    actions: {
      beginBuildingAnOrder: function beginBuildingAnOrder() {
        this.set('sidebarContainerClasses', this.get('buildingSidebarContainerClasses'));
        this.set('itemContainerClasses', this.get('buildingItemContainerClasses'));
      },

      addToOrder: function addToOrder(item) {
        if (!this.get('buildingAnOrder')) {

          this.send('beginBuildingAnOrder');

          var currentEvent = this.get('event');
          var order = this.store.createRecord('order', {
            host: currentEvent
          });

          this.set('currentOrder', order);
        }

        this.get('currentOrder').addLineItem(item);
      },

      removeItem: function removeItem(item) {
        var order = this.get('currentOrder');
        order.removeOrderLineItem(item);

        if (!order.get('hasLineItems')) {
          this.send('cancelOrder');
        }
      },

      cancelOrder: function cancelOrder() {
        this.set('sidebarContainerClasses', this.get('defaultSidebarContainerClasses'));
        this.set('itemContainerClasses', this.get('defaultItemContainerClasses'));

        this.get('currentOrder.lineItems').toArray().forEach(function (item) {
          item.destroyRecord();
          item.save();
        });
        this.get('currentOrder').destroyRecord();
        this.get('currentOrder').save();
        this.set('currentOrder', null);
      },

      finishedOrder: function finishedOrder() {
        Ember['default'].$('.close-reveal-modal').click();

        this.set('sidebarContainerClasses', this.get('defaultSidebarContainerClasses'));
        this.set('itemContainerClasses', this.get('defaultItemContainerClasses'));
        this.set('currentOrder', null);
        this.get('flashMessages').success('Order was successfully created and recorded');
      },

      processStripeToken: function processStripeToken(args) {
        var order = this.get('currentOrder');
        var self = this;
        /*
          send the token to the server to actually create the charge
         */
        order.setProperties({
          paymentMethod: 'Stripe',
          checkoutToken: args.id,
          checkoutEmail: args.email
        });

        /* save the line order first */
        if (order.get('isNew')) {
          order.save().then(function (o) {
            o.get('lineItems').invoke('save');
            o.save().then(function () {
              self.send('finishedOrder');
            }, function (errors) {
              alert(errors);
            });
          });
        } else {
          order.setProperties({
            checkoutToken: args.id,
            checkoutEmail: args.email
          });

          order.save().then(function () {
            /* what happens if the card is declined? */
            self.send('finishedOrder');
          }, function (order) {
            alert(order);
          });
        }
      },

      process: function process(args) {
        var paymentMethod = args.paymentMethod;
        var checkNumber = args.checkNumber;
        var stripeData = args.stripeData;
        var order = this.get('currentOrder');
        var self = this;

        order.markPaid(paymentMethod, checkNumber, stripeData);
        /* save the line order first */
        order.save().then(function (o) {
          /* then line items */
          o.get('lineItems').invoke('save');
          o.save().then(function () {}, function (error) {
            alert(error);
          });
          self.send('finishedOrder');
        }, function (error) {
          alert(error);
        });
      }
    }
  });

});
define('aeonvera/controllers/events/index', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Controller.extend({
    sidebar: null,
    data: null
  });

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

  exports['default'] = Ember['default'].Helper.helper(function (params /*, hash*/) {
    var startDate = params[0];
    var endDate = params[1];

    var formattedStartDate = moment(startDate).format('ll');
    var formattedEndDate = moment(endDate).format('ll');

    var range = formattedStartDate + ' - ' + formattedEndDate;

    return range;
  });

});
define('aeonvera/helpers/date-with-format', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Helper.helper(function (params) {
    return moment(params[0]).format(params[1]);
  });

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
define('aeonvera/helpers/t', ['exports', 'ember-i18n/helper'], function (exports, helper) {

	'use strict';



	exports['default'] = helper['default'];

});
define('aeonvera/helpers/to-usd', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Helper.helper(function (params) {
    var value = params[0];

    if (value === undefined) {
      return value;
    }

    var amount = (value || 0).toFixed(2),
        sign = "$";

    return "" + sign + amount;
  });

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
define('aeonvera/initializers/current-user', ['exports', 'ember', 'simple-auth/session'], function (exports, Ember, Session) {

  'use strict';

  // from here:
  // modified to work with aeonvera's particular setup
  // http://discuss.emberjs.com/t/best-practice-for-loading-and-persisting-current-user-in-an-authenticated-system/6987/6

  var alreadyRun = false;

  exports['default'] = {
    name: "current-user",
    before: "simple-auth",
    initialize: function initialize(container) {

      if (alreadyRun) {
        return;
      } else {
        alreadyRun = true;
      }

      Session['default'].reopen({
        setCurrentUser: (function () {
          var accessToken = this.get("secure.token");

          /*
            not sure if this will be needed, but token and email are
            the two relevant fields on the secure object.
            var email = this.get('secure.email');
          */

          var self = this;

          /*
            the token will be present if we are logged in
          */
          if (!Ember['default'].isEmpty(accessToken)) {
            /*
              make a call to the server that only returns the current user
              see UserController#show
            */
            return container.lookup("service:store")
            /*
              the id of 0 here doesn't actually matter,
              the server alwasy returns the current user.
              This is just to route to the show action on the controller.
            */
            .find("user", 0).then(function (user) {
              self.set("content.currentUser", user);
            });
          }
        }).observes("secure.token")
      });
    }
  };

});
define('aeonvera/initializers/ember-i18n', ['exports', 'aeonvera/instance-initializers/ember-i18n'], function (exports, instanceInitializer) {

  'use strict';

  exports['default'] = {
    name: instanceInitializer['default'].name,

    initialize: function initialize(registry, application) {
      if (application.instanceInitializer) {
        return;
      }

      instanceInitializer['default'].initialize(application);
    }
  };

});
define('aeonvera/initializers/error-handler', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, ENV) {

  'use strict';

  var alreadyRun = false;

  var reportError = function reportError(errorData) {
    Ember['default'].$.ajax({
      url: 'https://aeonvera.com/api/front_end_error',
      method: 'POST',
      dataType: 'json',
      data: { error: errorData },
      success: function success() {},
      error: function error() {}
    });
  };

  exports['default'] = {
    name: 'error-handler',

    initialize: function initialize() {
      if (alreadyRun) {
        return;
      } else {
        alreadyRun = true;
      }
      if (ENV['default'].environment === 'production') {

        Ember['default'].Logger.error = function (message, cause, stack) {
          console.error(message);
          console.error(stack);

          var errorData = {
            message: message,
            stack: stack,
            cause: cause
          };

          reportError(errorData);
        };
      }
    }
  };
  /*data, textStatus, jqXHR*/
  // notify the user what happened, give link
  // similar to atom.io's editor

  /*jqXHR, textStatus, errorThrown*/
  // not sure what to do if this fails... we can't report it

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
            // url: 'http://swing.vhost:3000/users/sign_out',
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

    customURI: ''

  });

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
define('aeonvera/instance-initializers/ember-i18n', ['exports', 'ember', 'ember-i18n/legacy-helper', 'aeonvera/config/environment'], function (exports, Ember, legacyHelper, ENV) {

  'use strict';

  exports['default'] = {
    name: "ember-i18n",

    initialize: function initialize(instance) {
      var defaultLocale = (ENV['default'].i18n || {}).defaultLocale;
      if (defaultLocale === undefined) {
        Ember['default'].warn("ember-i18n did not find a default locale; falling back to \"en\".");
        defaultLocale = "en";
      }
      instance.container.lookup("service:i18n").set("locale", defaultLocale);

      if (legacyHelper['default'] != null) {
        Ember['default'].HTMLBars._registerHelper("t", legacyHelper['default']);
      }
    }
  };

});
define('aeonvera/locales/en/translations', ['exports'], function (exports) {

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

    atdPaymentCollectionAgree: 'You agree that by clicking the pay button below, that you have collected {{amount}} from the customer.',

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
define('aeonvera/mixins/authenticated-ui', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Mixin.create({

    activate: function activate() {
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

      this._super();
    }
  });

});
define('aeonvera/mixins/models/buyable', ['exports', 'ember', 'ember-data'], function (exports, Ember, DS) {

  'use strict';

  exports['default'] = Ember['default'].Mixin.create({
    currentPrice: DS['default'].attr('number')
  });

});
define('aeonvera/models/attendance', ['exports', 'ember', 'ember-data'], function (exports, Ember, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    attendeeName: DS['default'].attr('string'),
    danceOrientation: DS['default'].attr('string'),
    amountOwed: DS['default'].attr('number'),
    amountPaid: DS['default'].attr('number'),
    registeredAt: DS['default'].attr('date'),
    checkedInAt: DS['default'].attr('date'),

    packageName: DS['default'].attr('string'),
    levelName: DS['default'].attr('string'),

    eventId: DS['default'].attr('string'),

    unpaidOrder: DS['default'].belongsTo('unpaidOrder', { async: true }),

    hasUnpaidOrder: (function () {
      return Ember['default'].isPresent(this.get('unpaidOrder'));
    }).property('unpaidOrder'),

    isCheckedIn: (function () {
      return Ember['default'].isPresent(this.get('checkedInAt'));
    }).property('checkedInAt'),

    owesMoney: (function () {
      return this.get('amountOwed') > 0;
    }).property('amountOwed'),

    paymentStatus: (function () {
      var owed = this.get('amountOwed');
      var paid = this.get('amountPaid');
      var doesOwe = owed > 0;
      var hasPaid = paid > 0;
      var status = '';

      if (doesOwe) {
        status += 'Owe: $' + owed;
      }

      if (doesOwe && hasPaid) {
        status += ', ';
      }

      if (hasPaid) {
        status += 'Paid: $' + paid;
      }

      return status;
    }).property('amountOwed', 'amountPaid')
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
define('aeonvera/models/competition-response', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    attendance: DS['default'].belongsTo('attendance', { polymorphic: true }),
    competition: DS['default'].belongsTo('competition'),

    danceOrientation: DS['default'].attr('string'),
    partnerName: DS['default'].attr('string')

  });

});
define('aeonvera/models/competition', ['exports', 'ember-data', 'aeonvera/models/line-item'], function (exports, DS, LineItem) {

  'use strict';

  exports['default'] = LineItem['default'].extend({
    initialPrice: DS['default'].attr('number'),
    atTheDoorPrice: DS['default'].attr('number'),
    kind: DS['default'].attr('number'),

    requiresOrientation: DS['default'].attr('boolean'),
    requiresPartner: DS['default'].attr('boolean'),

    competitionResponses: DS['default'].hasMany('competitionResponse', { async: false, params: 'id' }),

    /**
      TODO: find out if there is a better way to represent this...
    */
    kindName: (function () {
      var kind = this.get('kind');

      if (kind === 0) {
        return 'Solo Jazz';
      } else if (kind === 1) {
        return 'Jack & Jill';
      } else if (kind === 2) {
        return 'Strictly';
      } else if (kind === 3) {
        return 'Team';
      } else if (kind === 4) {
        return 'Crossover Jack & Jill';
      }
    }).property('kind')

  });
  // requiresPartner: function(){
  //   return this.get('kind') === 2;
  // }.property('kind'),
  //
  // requiresOrientation: function(){
  //   let kind = this.get('kind');
  //   return (kind === 1 || kind === 4)
  // }.property('kind')

});
define('aeonvera/models/event-attendance', ['exports', 'ember-data', 'aeonvera/models/attendance'], function (exports, DS, Attendance) {

  'use strict';

  exports['default'] = Attendance['default'].extend({
    competitionResponses: DS['default'].hasMany('competitionResponse')
  });

});
define('aeonvera/models/event-summary', ['exports', 'ember-data', 'aeonvera/models/hosted-event'], function (exports, DS, HostedEvent) {

  'use strict';

  exports['default'] = HostedEvent['default'].extend({
    revenue: DS['default'].attr('number'),
    unpaid: DS['default'].attr('number'),
    recentRegistrations: DS['default'].hasMany('recentRegistrations', { async: false })
  });

});
define('aeonvera/models/event', ['exports', 'ember-data', 'aeonvera/models/host'], function (exports, DS, Host) {

	'use strict';

	exports['default'] = Host['default'].extend({
		shortDescription: DS['default'].attr('string'),
		location: DS['default'].attr('string'),

		startsAt: DS['default'].attr('date'),
		endsAt: DS['default'].attr('date'),

		mailPaymentsEndAt: DS['default'].attr('date'),
		electronicPaymentsEndAt: DS['default'].attr('date'),
		refundsEndAt: DS['default'].attr('date'),
		shirtSalesEndAt: DS['default'].attr('date'),
		showAtTheDorPricesAt: DS['default'].attr('date'),

		showOnPublicCalendar: DS['default'].attr('boolean'),
		acceptOnlyElectronicPayments: DS['default'].attr('boolean'),
		makeAttendeesPayFees: DS['default'].attr('boolean'),
		hasVolunteers: DS['default'].attr('boolean'),
		volunteerDescription: DS['default'].attr('string'),

		housingStatus: DS['default'].attr('boolean'),
		housingNights: DS['default'].attr(),

		allowDiscounts: DS['default'].attr('boolean'),
		allowCombinedDiscounts: DS['default'].attr('boolean'),

		registrationEmailDisclaimer: DS['default'].attr('string'),

		logo_url: DS['default'].attr('string'),
		logo_url_medium: DS['default'].attr('string'),
		logo_url_thumb: DS['default'].attr('string'),

		url: DS['default'].attr('string'),

		integrations: DS['default'].hasMany('integration'),

		packages: DS['default'].hasMany('package'),
		levels: DS['default'].hasMany('level'),
		competitions: DS['default'].hasMany('competitions'),

		stripePublishableKey: (function () {
			/*
	  	TODO: find a way to make the 'stripe' key not a string somehow
	  	so typing it over and over doesn't lead to silent errors
	  */
			var integrations = this.get('integrations').filterBy('name', 'stripe');
			var stripeIntegration = null;

			if (integrations.length > 0) {
				stripeIntegration = integrations[0];
			}

			return stripeIntegration.get('publishableKey');
		}).property('integrations.[]')
	});

});
define('aeonvera/models/host', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string')
  });

});
define('aeonvera/models/hosted-event', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string'),
    registrationOpensAt: DS['default'].attr('date'),
    numberOfLeads: DS['default'].attr('number'),
    numberOfFollows: DS['default'].attr('number'),
    numberOfShirtsSold: DS['default'].attr('number'),
    myEvent: DS['default'].attr('boolean'),
    startsAt: DS['default'].attr('date'),
    endsAt: DS['default'].attr('date'),

    isRegistrationOpen: (function () {
      var open = this.get('hasRegistrationOpened');
      var ended = this.get('hasEnded');

      return open && !ended;
    }).property('registrationOpensAt', 'endsAt'),

    hasRegistrationOpened: (function () {
      var opensAt = this.get('registrationOpensAt').getTime();
      var currently = Date.now();
      return currently > opensAt;
    }).property('registrationOpensAt'),

    hasEnded: (function () {
      var endedAt = this.get('endsAt').getTime();
      var currently = Date.now();
      return currently > endedAt;
    }).property('endsAt'),

    totalAttendees: (function () {
      var leads = this.get('numberOfLeads');
      var follows = this.get('numberOfFollows');

      return leads + follows;
    }).property('numberOfLeads', 'numberOfFollows'),

    totalRegistrants: (function () {
      return this.get('totalAttendees');
    }).property('totalAttendees')
  });

});
define('aeonvera/models/integration', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string'),
    publishableKey: DS['default'].attr('string')
  });

});
define('aeonvera/models/level', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string')
  });

});
define('aeonvera/models/line-item', ['exports', 'ember-data', 'aeonvera/mixins/models/buyable'], function (exports, DS, Buyable) {

  'use strict';

  exports['default'] = DS['default'].Model.extend(Buyable['default'], {
    name: DS['default'].attr('string'),
    description: DS['default'].attr('string'),
    price: DS['default'].attr('number'),
    itemType: DS['default'].attr('string'),

    schedule: DS['default'].attr('string'),
    durationAmount: DS['default'].attr('number'),
    durationUnit: DS['default'].attr('number'),

    pictureUrlMedium: DS['default'].attr('string'),
    pictureUrlThumb: DS['default'].attr('string'),

    expiresAt: DS['default'].attr('date'),
    startsAt: DS['default'].attr('date'),
    endsAt: DS['default'].attr('date'),

    registrationOpensAt: DS['default'].attr('date'),
    registrationClosesAt: DS['default'].attr('date'),
    becomesAvailableAt: DS['default'].attr('date'),

    event: DS['default'].belongsTo('event'),
    host: DS['default'].belongsTo('host', { polymorphic: true })

  });

});
define('aeonvera/models/order-line-item', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    lineItem: DS['default'].belongsTo('line-item', { polymorphic: true }),
    order: DS['default'].belongsTo('order'),
    quantity: DS['default'].attr('number'),
    price: DS['default'].attr('number'),

    /*
      these properties are for additional objects that need to be created on the
      server, and are not actually stored with the order-line-item
      TODO: maybe the order-line-item could have an additional polymorphic
      associations that could point to stuff like the competition-response
      - This would make rendering of the order summaries MUCH easier...
       TODO: there should also be shirt responses (and there aren't. boo).
    */
    partnerName: DS['default'].attr('string'),
    danceOrientation: DS['default'].attr('string'),
    size: DS['default'].attr('string'),

    priceNeedsChanging: (function () {
      var lineItem = this.get('lineItem');
      var size = this.get('size');
      var sizePrice = lineItem.priceForSize(size);
      this.set('price', sizePrice);
    }).observes('size'),

    name: (function () {
      return this.get('lineItem').get('name');
    }).property('lineItem'),

    total: (function () {
      var price = this.get('price'),
          quantity = this.get('quantity');

      return price * quantity;
    }).property('price', 'quantity'),

    isCompetition: (function () {
      return this.get('lineItem').get('constructor.typeKey') === 'competition';
    }).property('lineItem', 'lineItemType'),

    isShirt: (function () {
      return this.get('lineItem').get('constructor.typeKey') === 'shirt';
    }).property('lineItem', 'lineItemType')

  });

});
define('aeonvera/models/order', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    hostName: DS['default'].attr('string'),
    hostUrl: DS['default'].attr('string'),
    createdAt: DS['default'].attr('date'),
    paidAmount: DS['default'].attr('number'),
    netAmountReceived: DS['default'].attr('number'),
    totalFeeAmount: DS['default'].attr('number'),
    paymentMethod: DS['default'].attr('string'),
    checkNumber: DS['default'].attr('string'),

    totalInCents: DS['default'].attr('number'),

    userEmail: DS['default'].attr('string'),

    host: DS['default'].belongsTo('host', { polymorphic: true }),
    lineItems: DS['default'].hasMany('orderLineItem'),
    attendance: DS['default'].belongsTo('attendance'),

    /*
      stripe specific things
      TODO: think about extracting this in to an object,
      and saving all of the toke info (like IP, maybe other stuff)
    */
    checkoutToken: DS['default'].attr('string'),
    checkoutEmail: DS['default'].attr('string'),

    /* aliases */
    event: (function () {
      return this.get('host');
    }).property('host'),

    hasLineItems: (function () {
      return this.get('lineItems').length > 0;
    }).property('lineItems.[]'),

    /*
      Calculates raw total of all the order line items
    */
    subTotal: (function () {
      var lineItems = this.get('lineItems'),
          subTotal = 0;

      lineItems.forEach(function (item) {
        subTotal += item.get('total');
      });

      return subTotal;
    }).property('lineItems.@each.price'),

    /*
      takes the line item, and makes an order line item out of it
    */
    addLineItem: function addLineItem(lineItem) {
      var quantity = arguments[1] === undefined ? 1 : arguments[1];
      var price = arguments[2] === undefined ? lineItem.get('currentPrice') : arguments[2];
      return (function () {
        var orderLineItem = this.get('lineItems').createRecord({
          lineItem: lineItem,
          price: price,
          quantity: quantity
        });

        this.get('lineItems').pushObject(orderLineItem);
      }).apply(this, arguments);
    },

    removeOrderLineItem: function removeOrderLineItem(orderLineItem) {
      this.get('lineItems').removeObject(orderLineItem);
      orderLineItem.destroyRecord();
    },

    /*
      stripe data doesn't need to be kept on the model, but is important for
      record keeping and eventual refunds
      - it might actually become available on when refunds are implemented,
        but I don't know how that's going to work yet
    */
    markPaid: function markPaid(paymentMethod) {
      var checkNumber = arguments[1] === undefined ? null : arguments[1];
      var stripeData = arguments[2] === undefined ? null : arguments[2];

      /*
        orders can't be changed once paid.
        - for refunds, a refund object should be associated
        - does this mean there should be a set of transactions on an order?
          which include payments and refunds?
      */
      if (!this.get('paid')) {
        /*
          any other monetary properties are set by the server
        */
        this.setProperties({
          paymentMethod: paymentMethod,
          checkNumber: checkNumber,
          paid: true,
          paidAmount: this.get('subTotal'),
          stripeData: stripeData
        });
      }
    }

  });

});
define('aeonvera/models/package', ['exports', 'ember-data'], function (exports, DS) {

  'use strict';

  exports['default'] = DS['default'].Model.extend({
    name: DS['default'].attr('string')
  });

});
define('aeonvera/models/recent-registration', ['exports', 'aeonvera/models/attendance'], function (exports, Attendance) {

	'use strict';

	exports['default'] = Attendance['default'].extend({});

});
define('aeonvera/models/registered-event', ['exports', 'ember-data'], function (exports, DS) {

	'use strict';

	exports['default'] = DS['default'].Model.extend({
		name: DS['default'].attr('string'),
		registeredAt: DS['default'].attr('date'),
		amountOwed: DS['default'].attr('number'),
		amountPaid: DS['default'].attr('number'),
		eventBeginsAt: DS['default'].attr('date'),
		isAttending: DS['default'].attr('boolean'),
		url: DS['default'].attr('string'),

		registrationStatus: (function () {
			if (this.get('isAttending')) {
				return 'Attending';
			} else {
				return 'Not Attending';
			}
		}).property('isAttending'),

		paymentStatus: (function () {
			var paid = this.get('amountPaid');
			var owe = this.get('amountOwed');
			var hasPaid = paid > 0;
			var doesOwe = owe > 0;

			var status = '';

			if (hasPaid) {
				status = 'Paid: $' + paid;
			}

			if (hasPaid && doesOwe) {
				status = status + '; ';
			}

			if (doesOwe) {
				status = status + 'Owe: $' + owe;
			}

			return status;
		}).property('amountOwed', 'amountPaid')

	});

});
define('aeonvera/models/shirt', ['exports', 'ember-data', 'aeonvera/models/line-item'], function (exports, DS, LineItem) {

  'use strict';

  exports['default'] = LineItem['default'].extend({
    sizes: DS['default'].attr(),

    priceForSize: function priceForSize(size) {
      var sizes = this.get('sizes');
      var price = this.get('price');
      sizes.forEach(function (sizeData) {
        if (sizeData.size === size) {
          price = sizeData.price;
        }
      });
      return price;
    }

  });

});
define('aeonvera/models/unpaid-order', ['exports', 'aeonvera/models/order'], function (exports, Order) {

	'use strict';

	exports['default'] = Order['default'].extend({});

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
      var currently = Date.now();
      return currently > opensAt;
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
    passwordConfirmation: DS['default'].attr('string'),
    currentPassword: DS['default'].attr('string'),
    unconfirmedEmail: DS['default'].attr('string'),
    timeZone: DS['default'].attr('string'),

    name: (function () {
      return this.get('firstName') + ' ' + this.get('lastName');
    }).property('firstName', 'lastName')

  });

});
define('aeonvera/router', ['exports', 'ember', 'aeonvera/config/environment'], function (exports, Ember, config) {

  'use strict';

  var Router = Ember['default'].Router.extend({
    location: config['default'].locationType
  });
  /*
    Notes:

    route == verb
    resource == noun

    this.resource('post', function(){
      this.route('comment'); // PostCommentRoute
      this.resource('comment'); // CommentRoute
    });

    index route is automatic
  */
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

    this.route('dashboard', {
      path: '/'
    }, function () {
      this.route('hosted-events');
      this.route('registered-events');
      this.route('orders');

      this.resource('event-at-the-door', { path: '/event-at-the-door/:event_id' }, function () {
        this.route('checkin');
        this.route('competition-list');
        this.route('a-la-carte');
      });
      this.resource('events', function () {
        this.route('show', {
          path: ':event_id'
        }, function () {});
        this.route('housing-requests', function () {
          this.route('new');
        });
        this.route('housing-provisions', function () {
          this.route('new');
        });

        this.route('checkin', function () {
          this.route('take-payment');
        });
      });
    });

    this.route('register', {
      path: 'r'
    }, function () {
      this.route('level');
      this.route('packages');
    });

    this.route('upcoming-events');
    this.route('communities');

    this.resource('user', function () {
      this.route('edit');
    });
  });

  /* attendees, volunteers, etc */

});
define('aeonvera/routes/application', ['exports', 'ember', 'simple-auth/mixins/application-route-mixin'], function (exports, Ember, ApplicationRouteMixin) {

	'use strict';

	exports['default'] = Ember['default'].Route.extend(ApplicationRouteMixin['default'], {
		// intl: Ember.inject.service(),
		// beforeModel: function(){
		// 	// define the app's runtime locale
		// 	// For example, here you would maybe do an API lookup to resolver
		// 	// which locale the user should be targeted and perhaps lazily
		// 	// load translations using XHR and calling intl's `addTranslation`/`addTranslations`
		// 	// method with the results of the XHR request
		// 	this.get('intl').setLocale('en-us');
		// },

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
				localStorage.clear();
			},

			sessionAuthenticationSucceeded: function sessionAuthenticationSucceeded() {
				// close the modal
				Ember['default'].$('a.close-reveal-modal').trigger('click');

				// set user and redirect
				this.transitionTo('dashboard');

				// notify of success
				Ember['default'].get(this, 'flashMessages').success('You have successfully logged in');
			},

			sessionAuthenticationFailed: function sessionAuthenticationFailed(error) {
				Ember['default'].Logger.debug('Session authentication failed!');

				Ember['default'].$('#login-error-message .message').text(error.error || error);
				Ember['default'].$('#login-error-message').show();
			}

		}
	});

});
define('aeonvera/routes/communities', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    i18n: Ember['default'].inject.service(),

    activate: function activate() {
      this.set('title', this.get('i18n').t('communities'));

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
define('aeonvera/routes/dashboard', ['exports', 'ember', 'aeonvera/mixins/authenticated-ui'], function (exports, Ember, AuthenticatedUi) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend(AuthenticatedUi['default'], {
    i18n: Ember['default'].inject.service(),

    activate: function activate() {
      this.set('title', this.get('i18n').t('dashboard'));

      var dashboard = this.controllerFor('dashboard');
      dashboard.set('sidebar', 'sidebar/dashboard-sidebar');

      this._super();
    },

    actions: {
      setSidebar: function setSidebar(name) {
        var dashboard = this.controllerFor('dashboard');

        dashboard.set('sidebar', name);
      },

      setData: function setData(data) {
        var dashboard = this.controllerFor('dashboard');

        dashboard.set('data', data);
      }
    }

  });

});
define('aeonvera/routes/dashboard/hosted-events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    showMyEvents: false,

    model: function model() {
      return this.store.findAll('hosted-event');
    }
  });

});
define('aeonvera/routes/dashboard/orders', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    model: function model() {
      return this.store.findAll('order');
    }
  });

});
define('aeonvera/routes/dashboard/registered-events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    model: function model() {
      return this.store.findAll('registered-event');
    }
  });

});
define('aeonvera/routes/event-at-the-door', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    renderTemplate: function renderTemplate() {
      this.render('event-at-the-door', {
        into: 'application'
      });
    }
  });

});
define('aeonvera/routes/event-at-the-door/a-la-carte', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    model: function model() {
      var fromRoute = this.modelFor('event-at-the-door');
      this.set('event', fromRoute);
      return Ember['default'].RSVP.hash({
        attendances: this.store.query('event-attendance', { event_id: fromRoute.get('id') }),
        lineItems: this.store.query('line-item', { event_id: fromRoute.get('id'), active: true }),
        competitions: this.store.query('competition', { event_id: fromRoute.get('id') }),
        shirts: this.store.query('shirt', { event_id: fromRoute.get('id') })
      });
    }

  });

});
define('aeonvera/routes/event-at-the-door/checkin', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    model: function model() {
      var fromRoute = this.modelFor('event-at-the-door');
      return this.store.query('event-attendance', { event_id: fromRoute.get('id') });
    }
  });

});
define('aeonvera/routes/event-at-the-door/competition-list', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    eventId: null,
    event: null,
    eventName: 'why',

    beforeModel: function beforeModel() {
      var fromRoute = this.modelFor('event-at-the-door');
      this.set('eventId', fromRoute.get('id'));
      this.set('event', fromRoute);
      return fromRoute;
    },

    model: function model() {
      var host = this.get('event');
      this.set('eventName', host.get('name'));
      return this.store.query('competition', { event_id: host.get('id') });
    },

    afterModel: function afterModel(model) {
      return model.getEach('competitionResponses');
    }

  });

});
define('aeonvera/routes/event-at-the-door/index', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Route.extend({});

});
define('aeonvera/routes/events', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    renderTemplate: function renderTemplate() {
      this.render('events/index', {
        into: 'application'
      });
    }
  });

});
define('aeonvera/routes/events/index', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    redirect: function redirect() {
      this.transitionTo('dashboard.hosted-events');
    }
  });

});
define('aeonvera/routes/events/show', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({

    afterModel: function afterModel(model /*, transition */) {
      this._super();

      this.set('title', model.get('name'));

      var self = this;
      Ember['default'].run.later(function () {
        var dashboard = self.controllerFor('events/index');
        dashboard.set('data', model);
      });
    },

    model: function model(params) {
      return this.store.find('eventSummary', params.event_id);
    }
  });

});
define('aeonvera/routes/events/show/index', ['exports', 'ember'], function (exports, Ember) {

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
    i18n: Ember['default'].inject.service(),

    activate: function activate() {
      this.set('title', this.get('i18n').t('upcomingevents'));

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
define('aeonvera/routes/user/edit', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    i18n: Ember['default'].inject.service(),

    activate: function activate() {

      this.set('title', this.get('i18n').t('attendedevents'));

      this.controllerFor('application').set('mobileMenuLeft', 'nav/dashboard/left-items');

      this._super();
    },

    /**
      Redirect to the welcome route if not logged in.
      TODO: extract this to a mixin
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

    actions: {
      updateCurrentUser: function updateCurrentUser() {
        var store = this.get('store');

        store.find('user', 0).then(function (user) {
          user.save();
        });
      },

      deactivateAccount: function deactivateAccount() {
        var store = this.get('store');
        var self = this;

        store.find('user', 0).then(function (user) {
          user.deleteRecord();
          user.save().then(function () {
            self.send('invalidateSession');
          });
        });
      }
    }
  });

});
define('aeonvera/routes/welcome', ['exports', 'ember'], function (exports, Ember) {

  'use strict';

  exports['default'] = Ember['default'].Route.extend({
    i18n: Ember['default'].inject.service(),

    activate: function activate() {
      this.set('title', this.get('i18n').t('appname'));
      this._super();
    }
  });

});
define('aeonvera/services/current-registering-object', ['exports', 'ember'], function (exports, Ember) {

	'use strict';

	exports['default'] = Ember['default'].Service.extend({});

});
define('aeonvera/services/flash-messages-service', ['exports', 'ember-cli-flash/services/flash-messages-service'], function (exports, FlashMessagesService) {

	'use strict';

	exports['default'] = FlashMessagesService['default'];

});
define('aeonvera/services/i18n', ['exports', 'ember-i18n/services/i18n'], function (exports, i18n) {

	'use strict';



	exports['default'] = i18n['default'];

});
define('aeonvera/templates/application', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 452
            },
            "end": {
              "line": 1,
              "column": 572
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","flash-message",[],["flash",["subexpr","@mut",[["get","flash",["loc",[null,[1,512],[1,517]]]]],[],[]],"messageStyle","foundation","classNames","flash-message"],["loc",[null,[1,490],[1,572]]]]
        ],
        locals: ["flash"],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 676
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [5]);
        var element2 = dom.childAt(element1, [3, 0]);
        var element3 = dom.childAt(element2, [0]);
        var morphs = new Array(11);
        morphs[0] = dom.createMorphAt(element0,0,0);
        morphs[1] = dom.createMorphAt(element0,1,1);
        morphs[2] = dom.createMorphAt(element0,2,2);
        morphs[3] = dom.createMorphAt(element0,3,3);
        morphs[4] = dom.createMorphAt(element0,4,4);
        morphs[5] = dom.createMorphAt(element1,1,1);
        morphs[6] = dom.createMorphAt(element1,2,2);
        morphs[7] = dom.createMorphAt(element3,0,0);
        morphs[8] = dom.createMorphAt(element3,1,1);
        morphs[9] = dom.createMorphAt(element2,1,1);
        morphs[10] = dom.createMorphAt(element1,4,4);
        return morphs;
      },
      statements: [
        ["inline","component",[["get","navigation",["loc",[null,[1,63],[1,73]]]]],["left",["subexpr","@mut",[["get","mobileMenuLeft",["loc",[null,[1,79],[1,93]]]]],[],[]],"right",["subexpr","@mut",[["get","mobileMenuRight",["loc",[null,[1,100],[1,115]]]]],[],[]]],["loc",[null,[1,51],[1,117]]]],
        ["inline","outlet",["modal"],[],["loc",[null,[1,117],[1,135]]]],
        ["content","login-modal",["loc",[null,[1,135],[1,150]]]],
        ["content","login-help-modal",["loc",[null,[1,150],[1,170]]]],
        ["inline","sign-up-modal",[],["action","registerNewUser","model",["subexpr","@mut",[["get","user",["loc",[null,[1,217],[1,221]]]]],[],[]]],["loc",[null,[1,170],[1,223]]]],
        ["inline","nav/left-off-canvas-menu",[],["items",["subexpr","@mut",[["get","mobileMenuLeft",["loc",[null,[1,311],[1,325]]]]],[],[]]],["loc",[null,[1,278],[1,327]]]],
        ["inline","nav/right-off-canvas-menu",[],["items",["subexpr","@mut",[["get","mobileMenuRight",["loc",[null,[1,361],[1,376]]]]],[],[]]],["loc",[null,[1,327],[1,378]]]],
        ["block","each",[["get","flashMessages.queue",["loc",[null,[1,469],[1,488]]]]],[],0,null,["loc",[null,[1,452],[1,581]]]],
        ["content","outlet",["loc",[null,[1,581],[1,591]]]],
        ["inline","outlet",["bottom-footer"],[],["loc",[null,[1,597],[1,623]]]],
        ["inline","outlet",["fixed-footer"],[],["loc",[null,[1,639],[1,664]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/communities', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 237
              },
              "end": {
                "line": 1,
                "column": 331
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("span");
            dom.setAttribute(el1,"class","icon-thumbnail right");
            var el2 = dom.createComment("");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var morphs = new Array(1);
            morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
            return morphs;
          },
          statements: [
            ["inline","fa-icon",["globe"],[],["loc",[null,[1,305],[1,324]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      var child1 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 331
              },
              "end": {
                "line": 1,
                "column": 393
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("img");
            dom.setAttribute(el1,"class","right");
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var morphs = new Array(1);
            morphs[0] = dom.createAttrMorph(element0, 'src');
            return morphs;
          },
          statements: [
            ["attribute","src",["concat",[["get","community.logo_url_thumb",["loc",[null,[1,351],[1,375]]]]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 126
            },
            "end": {
              "line": 1,
              "column": 519
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element1 = dom.childAt(fragment, [0]);
          var element2 = dom.childAt(element1, [0]);
          var element3 = dom.childAt(element2, [1]);
          var morphs = new Array(4);
          morphs[0] = dom.createAttrMorph(element1, 'href');
          morphs[1] = dom.createMorphAt(dom.childAt(element2, [0]),0,0);
          morphs[2] = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
          morphs[3] = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
          return morphs;
        },
        statements: [
          ["attribute","href",["concat",[["get","community.url",["loc",[null,[1,165],[1,178]]]]]]],
          ["block","if",[["get","community.logo_is_missing",["loc",[null,[1,243],[1,268]]]]],[],0,1,["loc",[null,[1,237],[1,400]]]],
          ["content","community.name",["loc",[null,[1,449],[1,467]]]],
          ["content","community.location",["loc",[null,[1,476],[1,498]]]]
        ],
        locals: ["community"],
        templates: [child0, child1]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 542
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["communities"],[],["loc",[null,[1,48],[1,67]]]],
        ["block","each",[["get","model",["loc",[null,[1,147],[1,152]]]]],[],0,null,["loc",[null,[1,126],[1,528]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/attendance-list', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 184
              },
              "end": {
                "line": 1,
                "column": 561
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("tr");
            var el2 = dom.createElement("td");
            var el3 = dom.createElement("a");
            var el4 = dom.createElement("span");
            var el5 = dom.createComment("");
            dom.appendChild(el4, el5);
            dom.appendChild(el3, el4);
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
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var element1 = dom.childAt(element0, [0, 0]);
            var morphs = new Array(7);
            morphs[0] = dom.createAttrMorph(element1, 'href');
            morphs[1] = dom.createMorphAt(dom.childAt(element1, [0]),0,0);
            morphs[2] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
            morphs[3] = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
            morphs[4] = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
            morphs[5] = dom.createMorphAt(dom.childAt(element0, [4]),0,0);
            morphs[6] = dom.createMorphAt(dom.childAt(element0, [5]),0,0);
            return morphs;
          },
          statements: [
            ["attribute","href",["concat",["/hosted_events/",["get","attendance.eventId",["loc",[null,[1,247],[1,265]]]],"/attendances/",["get","attendance.id",["loc",[null,[1,282],[1,295]]]]]]],
            ["content","attendance.attendeeName",["loc",[null,[1,305],[1,332]]]],
            ["content","attendance.packageName",["loc",[null,[1,352],[1,378]]]],
            ["content","attendance.levelName",["loc",[null,[1,387],[1,411]]]],
            ["content","attendance.danceOrientation",["loc",[null,[1,420],[1,451]]]],
            ["inline","to-usd",[["get","attendance.amountOwed",["loc",[null,[1,469],[1,490]]]]],[],["loc",[null,[1,460],[1,492]]]],
            ["inline","date-with-format",[["get","attendance.registeredAt",["loc",[null,[1,520],[1,543]]]],"lll"],[],["loc",[null,[1,501],[1,551]]]]
          ],
          locals: ["attendance"],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 158
            },
            "end": {
              "line": 1,
              "column": 570
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["block","each",[["get","model",["loc",[null,[1,206],[1,211]]]]],[],0,null,["loc",[null,[1,184],[1,570]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 593
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("table");
        dom.setAttribute(el1,"class","responsive");
        var el2 = dom.createElement("thead");
        var el3 = dom.createElement("tr");
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Name");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Package");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Level");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Orientation");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Owe $");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Time Registered");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("tbody");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 1]),0,0);
        return morphs;
      },
      statements: [
        ["block","if",[["get","attendancesPresent",["loc",[null,[1,164],[1,182]]]]],[],0,null,["loc",[null,[1,158],[1,577]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/error-field-wrapper', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 45
              },
              "end": {
                "line": 1,
                "column": 92
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var morphs = new Array(1);
            morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, 0);
            dom.insertBoundary(fragment, null);
            return morphs;
          },
          statements: [
            ["content","error.message",["loc",[null,[1,75],[1,92]]]]
          ],
          locals: ["error"],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 9
            },
            "end": {
              "line": 1,
              "column": 108
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          dom.setAttribute(el1,"class","error");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["block","each",[["get","fieldErrors",["loc",[null,[1,62],[1,73]]]]],[],0,null,["loc",[null,[1,45],[1,101]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 115
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["content","yield",["loc",[null,[1,0],[1,9]]]],
        ["block","if",[["get","hasError",["loc",[null,[1,15],[1,23]]]]],[],0,null,["loc",[null,[1,9],[1,115]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/event-at-the-door/checkin-attendance', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 35
            },
            "end": {
              "line": 1,
              "column": 165
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("button");
          dom.setAttribute(el1,"class","small no-margins success");
          var el2 = dom.createTextNode("Check in");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element3 = dom.childAt(fragment, [0]);
          var morphs = new Array(1);
          morphs[0] = dom.createElementMorph(element3);
          return morphs;
        },
        statements: [
          ["element","action",["checkin",["get","attendance",["loc",[null,[1,91],[1,101]]]]],["on","click"],["loc",[null,[1,72],[1,114]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 252
            },
            "end": {
              "line": 1,
              "column": 657
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode(" Owes ");
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("br");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("a");
          dom.setAttribute(el1,"href","#");
          dom.setAttribute(el1,"class","button small split");
          var el2 = dom.createTextNode("Pay with ");
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("span");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("ul");
          dom.setAttribute(el1,"class","f-dropdown");
          var el2 = dom.createElement("li");
          var el3 = dom.createTextNode("stripe/checkout-button model=model.unpaidOrder");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("li");
          var el3 = dom.createElement("a");
          var el4 = dom.createTextNode("Cash");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("li");
          var el3 = dom.createElement("a");
          var el4 = dom.createTextNode("Check");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [2]);
          var element1 = dom.childAt(element0, [2]);
          var element2 = dom.childAt(fragment, [3]);
          var morphs = new Array(5);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          morphs[1] = dom.createElementMorph(element0);
          morphs[2] = dom.createMorphAt(element0,1,1);
          morphs[3] = dom.createAttrMorph(element1, 'data-dropdown');
          morphs[4] = dom.createAttrMorph(element2, 'id');
          return morphs;
        },
        statements: [
          ["inline","to-usd",[["get","model.amountOwed",["loc",[null,[1,296],[1,312]]]]],[],["loc",[null,[1,287],[1,314]]]],
          ["element","action",["pay"],["on","click"],["loc",[null,[1,328],[1,355]]]],
          ["content","currentPaymentMethod",["loc",[null,[1,401],[1,425]]]],
          ["attribute","data-dropdown",["concat",["payment-dropdown-",["get","attendance.id",["loc",[null,[1,465],[1,478]]]]]]],
          ["attribute","id",["concat",["payment-dropdown-",["get","attendance.id",["loc",[null,[1,520],[1,533]]]]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 657
            },
            "end": {
              "line": 1,
              "column": 682
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Paid");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 752
            },
            "end": {
              "line": 1,
              "column": 821
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","date-with-format",[["get","model.checkedInAt",["loc",[null,[1,796],[1,813]]]],"lll"],[],["loc",[null,[1,777],[1,821]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 833
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("td");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(7);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [3]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(fragment, [5]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(fragment, [6]),0,0);
        morphs[6] = dom.createMorphAt(dom.childAt(fragment, [7]),0,0);
        return morphs;
      },
      statements: [
        ["content","model.attendeeName",["loc",[null,[1,4],[1,26]]]],
        ["block","unless",[["get","model.isCheckedIn",["loc",[null,[1,45],[1,62]]]]],[],0,null,["loc",[null,[1,35],[1,176]]]],
        ["content","model.packageName",["loc",[null,[1,185],[1,206]]]],
        ["content","model.levelName",["loc",[null,[1,215],[1,234]]]],
        ["block","if",[["get","model.owesMoney",["loc",[null,[1,258],[1,273]]]]],[],1,2,["loc",[null,[1,252],[1,689]]]],
        ["inline","date-with-format",[["get","model.registeredAt",["loc",[null,[1,717],[1,735]]]],"lll"],[],["loc",[null,[1,698],[1,743]]]],
        ["block","if",[["get","model.isCheckedIn",["loc",[null,[1,758],[1,775]]]]],[],3,null,["loc",[null,[1,752],[1,828]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3]
    };
  }()));

});
define('aeonvera/templates/components/event-at-the-door/checkin-list', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 703
            },
            "end": {
              "line": 1,
              "column": 807
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","component",["event-at-the-door/checkin-attendance"],["model",["subexpr","@mut",[["get","attendance",["loc",[null,[1,795],[1,805]]]]],[],[]]],["loc",[null,[1,738],[1,807]]]]
        ],
        locals: ["attendance"],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 832
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 medium-6 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 medium-6 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("label");
        var el4 = dom.createTextNode("Show only non checked in");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("br");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("label");
        var el4 = dom.createTextNode("Show only those who owe money");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("span");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("% | ");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("span");
        var el2 = dom.createTextNode("Checked In: ");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode(" | Not Checked In: ");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("table");
        dom.setAttribute(el1,"class","margin-center");
        var el2 = dom.createElement("thead");
        var el3 = dom.createElement("tr");
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Name");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Package");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Track");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Competitions");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("$ Owed");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Date Registered");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Checked in at");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("tbody");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [1]);
        var element2 = dom.childAt(fragment, [3]);
        var morphs = new Array(7);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(element1,0,0);
        morphs[2] = dom.createMorphAt(element1,3,3);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        morphs[4] = dom.createMorphAt(element2,1,1);
        morphs[5] = dom.createMorphAt(element2,3,3);
        morphs[6] = dom.createMorphAt(dom.childAt(fragment, [4, 1]),0,0);
        return morphs;
      },
      statements: [
        ["inline","input",[],["type","text","value",["subexpr","@mut",[["get","queryText",["loc",[null,[1,82],[1,91]]]]],[],[]],"placeholder","Search by name"],["loc",[null,[1,56],[1,122]]]],
        ["inline","input",[],["type","checkbox","checked",["subexpr","@mut",[["get","showOnlyNonCheckedIn",["loc",[null,[1,199],[1,219]]]]],[],[]]],["loc",[null,[1,167],[1,221]]]],
        ["inline","input",[],["type","checkbox","checked",["subexpr","@mut",[["get","showOnlyThoseWhoOweMoney",["loc",[null,[1,296],[1,320]]]]],[],[]]],["loc",[null,[1,264],[1,322]]]],
        ["content","percentCheckedIn",["loc",[null,[1,388],[1,408]]]],
        ["content","numberCheckedIn",["loc",[null,[1,442],[1,461]]]],
        ["content","numberNotCheckedIn",["loc",[null,[1,480],[1,502]]]],
        ["block","each",[["get","attendances",["loc",[null,[1,725],[1,736]]]]],[],0,null,["loc",[null,[1,703],[1,816]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/fixed-top-nav', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 92
            },
            "end": {
              "line": 1,
              "column": 231
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 318
            },
            "end": {
              "line": 1,
              "column": 367
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","fa-icon",["angle-left"],[],["loc",[null,[1,343],[1,367]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 452
            },
            "end": {
              "line": 1,
              "column": 493
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["content","backLinkText",["loc",[null,[1,477],[1,493]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 520
            },
            "end": {
              "line": 1,
              "column": 662
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 738
            },
            "end": {
              "line": 1,
              "column": 779
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["content","backLinkText",["loc",[null,[1,763],[1,779]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1021
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [1]);
        var morphs = new Array(7);
        morphs[0] = dom.createMorphAt(element0,0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0, 0, 0]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element1, [1, 0, 0]),0,0);
        morphs[3] = dom.createMorphAt(element1,2,2);
        morphs[4] = dom.createMorphAt(dom.childAt(element0, [2, 0, 0]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element0, [3, 0]),0,0);
        morphs[6] = dom.createMorphAt(dom.childAt(element0, [4, 0]),0,0);
        return morphs;
      },
      statements: [
        ["block","if",[["get","hasLeftMobileMenu",["loc",[null,[1,98],[1,115]]]]],[],0,null,["loc",[null,[1,92],[1,238]]]],
        ["block","link-to",[["get","backLinkPath",["loc",[null,[1,329],[1,341]]]]],[],1,null,["loc",[null,[1,318],[1,379]]]],
        ["block","link-to",[["get","backLinkPath",["loc",[null,[1,463],[1,475]]]]],[],2,null,["loc",[null,[1,452],[1,505]]]],
        ["block","if",[["get","hasRightMobileMenu",["loc",[null,[1,526],[1,544]]]]],[],3,null,["loc",[null,[1,520],[1,669]]]],
        ["block","link-to",[["get","backLinkPath",["loc",[null,[1,749],[1,761]]]]],[],4,null,["loc",[null,[1,738],[1,791]]]],
        ["inline","component",[["get","left",["loc",[null,[1,889],[1,893]]]]],[],["loc",[null,[1,877],[1,895]]]],
        ["inline","component",[["get","right",["loc",[null,[1,993],[1,998]]]]],[],["loc",[null,[1,981],[1,1000]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4]
    };
  }()));

});
define('aeonvera/templates/components/flash-message', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 0
            },
            "end": {
              "line": 3,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          return morphs;
        },
        statements: [
          ["inline","yield",[["get","this",["loc",[null,[2,10],[2,14]]]],["get","flash",["loc",[null,[2,15],[2,20]]]]],[],["loc",[null,[2,2],[2,22]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 5,
                "column": 2
              },
              "end": {
                "line": 9,
                "column": 2
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
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
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [1, 1]);
            var morphs = new Array(1);
            morphs[0] = dom.createAttrMorph(element0, 'style');
            return morphs;
          },
          statements: [
            ["attribute","style",["get","progressDuration",["loc",[null,[7,45],[7,61]]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 3,
              "column": 0
            },
            "end": {
              "line": 10,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(2);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          morphs[1] = dom.createMorphAt(fragment,3,3,contextualElement);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["content","flash.message",["loc",[null,[4,2],[4,19]]]],
          ["block","if",[["get","showProgressBar",["loc",[null,[5,8],[5,23]]]]],[],0,null,["loc",[null,[5,2],[9,9]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 11,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["block","if",[["get","hasBlock",["loc",[null,[1,6],[1,14]]]]],[],0,1,["loc",[null,[1,0],[10,7]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/components/foundation-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 138
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h2");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("p");
        var el2 = dom.createComment("");
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var morphs = new Array(3);
        morphs[0] = dom.createAttrMorph(element0, 'id');
        morphs[1] = dom.createMorphAt(element0,0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        return morphs;
      },
      statements: [
        ["attribute","id",["get","titleId",["loc",[null,[1,19],[1,26]]]]],
        ["content","title",["loc",[null,[1,49],[1,58]]]],
        ["content","yield",["loc",[null,[1,66],[1,75]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/handle-payment', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1114
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h4");
        var el2 = dom.createTextNode("Choose Payment Method");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"id","payment-error-message");
        dom.setAttribute(el1,"data-alert","true");
        dom.setAttribute(el1,"class","modal-top-message alert-box alert");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","#");
        dom.setAttribute(el2,"class","close");
        var el3 = dom.createTextNode("×");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("span");
        dom.setAttribute(el2,"class","message");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("br");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("ul");
        dom.setAttribute(el1,"data-tab","true");
        dom.setAttribute(el1,"class","tabs");
        var el2 = dom.createElement("li");
        dom.setAttribute(el2,"class","tab-title active");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","#payment-panel-cash");
        var el4 = dom.createTextNode("Cash");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        dom.setAttribute(el2,"class","tab-title");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","#payment-panel-check");
        var el4 = dom.createTextNode("Check");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("li");
        dom.setAttribute(el2,"class","tab-title");
        var el3 = dom.createElement("a");
        dom.setAttribute(el3,"href","#payment-panel-stripe");
        var el4 = dom.createTextNode("Credit/Debit Card");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","tabs-content");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"id","payment-panel-stripe");
        dom.setAttribute(el2,"class","content");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","right");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"id","payment-panel-cash");
        dom.setAttribute(el2,"class","content active");
        var el3 = dom.createElement("p");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("button");
        dom.setAttribute(el3,"class","right");
        var el4 = dom.createTextNode("Pay ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"id","payment-panel-check");
        dom.setAttribute(el2,"class","content");
        var el3 = dom.createElement("p");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("label");
        var el4 = dom.createTextNode("Check Number");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("button");
        dom.setAttribute(el3,"class","right");
        var el4 = dom.createTextNode("Pay ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [3]);
        var element1 = dom.childAt(element0, [1]);
        var element2 = dom.childAt(element1, [1]);
        var element3 = dom.childAt(element0, [2]);
        var element4 = dom.childAt(element3, [3]);
        var morphs = new Array(8);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0]),0,0);
        morphs[2] = dom.createElementMorph(element2);
        morphs[3] = dom.createMorphAt(element2,1,1);
        morphs[4] = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
        morphs[5] = dom.createMorphAt(element3,2,2);
        morphs[6] = dom.createElementMorph(element4);
        morphs[7] = dom.createMorphAt(element4,1,1);
        return morphs;
      },
      statements: [
        ["inline","stripe/checkout-button",[],["model",["subexpr","@mut",[["get","order",["loc",[null,[1,578],[1,583]]]]],[],[]],"action",["subexpr","@mut",[["get","processStripeToken",["loc",[null,[1,591],[1,609]]]]],[],[]]],["loc",[null,[1,547],[1,611]]]],
        ["inline","t",["atdPaymentCollectionAgree"],["amount",["subexpr","to-usd",[["get","amount",["loc",[null,[1,725],[1,731]]]]],[],["loc",[null,[1,717],[1,732]]]]],["loc",[null,[1,678],[1,734]]]],
        ["element","action",["process","Cash"],["on","click"],["loc",[null,[1,746],[1,784]]]],
        ["inline","to-usd",[["get","amount",["loc",[null,[1,812],[1,818]]]]],[],["loc",[null,[1,803],[1,820]]]],
        ["inline","t",["atdPaymentCollectionAgree"],["amount",["subexpr","to-usd",[["get","amount",["loc",[null,[1,931],[1,937]]]]],[],["loc",[null,[1,923],[1,938]]]]],["loc",[null,[1,884],[1,940]]]],
        ["inline","input",[],["type","text","value",["subexpr","@mut",[["get","checkNumber",["loc",[null,[1,997],[1,1008]]]]],[],[]]],["loc",[null,[1,971],[1,1010]]]],
        ["element","action",["process","Check"],["on","click"],["loc",[null,[1,1018],[1,1057]]]],
        ["inline","to-usd",[["get","amount",["loc",[null,[1,1085],[1,1091]]]]],[],["loc",[null,[1,1076],[1,1093]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/labeled-radio-button', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 12,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n\n");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        morphs[1] = dom.createMorphAt(fragment,2,2,contextualElement);
        dom.insertBoundary(fragment, 0);
        return morphs;
      },
      statements: [
        ["inline","radio-button",[],["radioClass",["subexpr","@mut",[["get","radioClass",["loc",[null,[2,15],[2,25]]]]],[],[]],"radioId",["subexpr","@mut",[["get","radioId",["loc",[null,[3,12],[3,19]]]]],[],[]],"changed","innerRadioChanged","disabled",["subexpr","@mut",[["get","disabled",["loc",[null,[5,13],[5,21]]]]],[],[]],"groupValue",["subexpr","@mut",[["get","groupValue",["loc",[null,[6,15],[6,25]]]]],[],[]],"name",["subexpr","@mut",[["get","name",["loc",[null,[7,9],[7,13]]]]],[],[]],"required",["subexpr","@mut",[["get","required",["loc",[null,[8,13],[8,21]]]]],[],[]],"value",["subexpr","@mut",[["get","value",["loc",[null,[9,10],[9,15]]]]],[],[]]],["loc",[null,[1,0],[9,17]]]],
        ["content","yield",["loc",[null,[11,0],[11,9]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/links/external-link', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 0
            },
            "end": {
              "line": 3,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          return morphs;
        },
        statements: [
          ["inline","fa-icon",[["get","icon",["loc",[null,[2,12],[2,16]]]]],[],["loc",[null,[2,2],[2,18]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 5,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, 0);
        return morphs;
      },
      statements: [
        ["block","if",[["get","icon",["loc",[null,[1,6],[1,10]]]]],[],0,null,["loc",[null,[1,0],[3,7]]]],
        ["content","text",["loc",[null,[4,0],[4,8]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/login-help-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 654
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/login-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 2036
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
        var el2 = dom.createElement("p");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"id","login-error-message");
        dom.setAttribute(el3,"data-alert","true");
        dom.setAttribute(el3,"class","modal-top-message alert-box alert");
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","#");
        dom.setAttribute(el4,"class","close");
        var el5 = dom.createTextNode("×");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("span");
        dom.setAttribute(el4,"class","message");
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("br");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 1, 1]);
        var morphs = new Array(3);
        morphs[0] = dom.createElementMorph(element0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [0, 1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element0, [1, 1]),0,0);
        return morphs;
      },
      statements: [
        ["element","action",["authenticate"],["on","submit"],["loc",[null,[1,368],[1,405]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","identification",["loc",[null,[1,560],[1,574]]]]],[],[]],"placeholder","yourname@domain.com","type","text"],["loc",[null,[1,546],[1,622]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","password",["loc",[null,[1,791],[1,799]]]]],[],[]],"placeholder","Something secure and easy to remember","type","password"],["loc",[null,[1,777],[1,869]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/nav/dashboard/left-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 27
            },
            "end": {
              "line": 1,
              "column": 57
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Home");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 74
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","show-for-small");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        return morphs;
      },
      statements: [
        ["block","link-to",["application"],[],0,null,["loc",[null,[1,27],[1,69]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/components/nav/dashboard/right-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 17
            },
            "end": {
              "line": 1,
              "column": 82
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","t",["upcomingevents"],[],["loc",[null,[1,53],[1,75]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 116
            },
            "end": {
              "line": 1,
              "column": 174
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","t",["communities"],[],["loc",[null,[1,148],[1,167]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 388
            },
            "end": {
              "line": 1,
              "column": 524
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element1 = dom.childAt(fragment, [0]);
          var morphs = new Array(2);
          morphs[0] = dom.createElementMorph(element1);
          morphs[1] = dom.createMorphAt(element1,0,0);
          return morphs;
        },
        statements: [
          ["element","action",["invalidateSession"],["on","click"],["loc",[null,[1,422],[1,463]]]],
          ["inline","fa-icon",["sign-out"],[],["loc",[null,[1,479],[1,501]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 563
            },
            "end": {
              "line": 1,
              "column": 649
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(2);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
          dom.insertBoundary(fragment, 0);
          return morphs;
        },
        statements: [
          ["inline","fa-icon",["info-circle"],[],["loc",[null,[1,591],[1,616]]]],
          ["inline","t",["aboutSummary"],[],["loc",[null,[1,622],[1,642]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 911
            },
            "end": {
              "line": 1,
              "column": 1032
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [0]);
          var morphs = new Array(2);
          morphs[0] = dom.createElementMorph(element0);
          morphs[1] = dom.createMorphAt(element0,0,0);
          return morphs;
        },
        statements: [
          ["element","action",["invalidateSession"],["on","click"],["loc",[null,[1,945],[1,986]]]],
          ["inline","fa-icon",["sign-out"],[],["loc",[null,[1,987],[1,1009]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child5 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1073
            },
            "end": {
              "line": 1,
              "column": 1159
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(2);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
          dom.insertBoundary(fragment, 0);
          return morphs;
        },
        statements: [
          ["inline","fa-icon",["info-circle"],[],["loc",[null,[1,1101],[1,1126]]]],
          ["inline","t",["aboutSummary"],[],["loc",[null,[1,1132],[1,1152]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1186
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element2 = dom.childAt(fragment, [7]);
        var element3 = dom.childAt(element2, [1]);
        var morphs = new Array(8);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [5]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [6]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element2, [0]),1,1);
        morphs[5] = dom.createMorphAt(dom.childAt(element3, [0, 0]),0,0);
        morphs[6] = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
        morphs[7] = dom.createMorphAt(dom.childAt(element3, [3]),0,0);
        return morphs;
      },
      statements: [
        ["block","link-to",["upcoming-events"],[],0,null,["loc",[null,[1,17],[1,94]]]],
        ["block","link-to",["communities"],[],1,null,["loc",[null,[1,116],[1,186]]]],
        ["block","if",[["get","session.isAuthenticated",["loc",[null,[1,394],[1,417]]]]],[],2,null,["loc",[null,[1,388],[1,531]]]],
        ["block","link-to",["welcome.about"],[],3,null,["loc",[null,[1,563],[1,661]]]],
        ["inline","fa-icon",["cog"],[],["loc",[null,[1,767],[1,784]]]],
        ["inline","fa-icon",["pencil"],[],["loc",[null,[1,853],[1,873]]]],
        ["block","if",[["get","session.isAuthenticated",["loc",[null,[1,917],[1,940]]]]],[],4,null,["loc",[null,[1,911],[1,1039]]]],
        ["block","link-to",["welcome.about"],[],5,null,["loc",[null,[1,1073],[1,1171]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4, child5]
    };
  }()));

});
define('aeonvera/templates/components/nav/left-off-canvas-menu', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 52
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("ul");
        dom.setAttribute(el1,"class","off-canvas-list");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","component",[["get","items",["loc",[null,[1,40],[1,45]]]]],[],["loc",[null,[1,28],[1,47]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/nav/right-off-canvas-menu', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 52
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("ul");
        dom.setAttribute(el1,"class","off-canvas-list");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","component",[["get","items",["loc",[null,[1,40],[1,45]]]]],[],["loc",[null,[1,28],[1,47]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/nav/welcome/left-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 27
            },
            "end": {
              "line": 1,
              "column": 57
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Home");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 78
            },
            "end": {
              "line": 1,
              "column": 125
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["features"],[],["loc",[null,[1,109],[1,125]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 146
            },
            "end": {
              "line": 1,
              "column": 191
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["pricing"],[],["loc",[null,[1,176],[1,191]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 212
            },
            "end": {
              "line": 1,
              "column": 250
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["faq"],[],["loc",[null,[1,238],[1,250]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 271
            },
            "end": {
              "line": 1,
              "column": 323
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["opensource"],[],["loc",[null,[1,304],[1,323]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 340
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [3]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(fragment, [4]),0,0);
        return morphs;
      },
      statements: [
        ["block","link-to",["application"],[],0,null,["loc",[null,[1,27],[1,69]]]],
        ["block","link-to",["welcome.features"],[],1,null,["loc",[null,[1,78],[1,137]]]],
        ["block","link-to",["welcome.pricing"],[],2,null,["loc",[null,[1,146],[1,203]]]],
        ["block","link-to",["welcome.faq"],[],3,null,["loc",[null,[1,212],[1,262]]]],
        ["block","link-to",["welcome.opensource"],[],4,null,["loc",[null,[1,271],[1,335]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4]
    };
  }()));

});
define('aeonvera/templates/components/nav/welcome/right-items', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 53
              },
              "end": {
                "line": 1,
                "column": 153
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            var el1 = dom.createElement("span");
            var el2 = dom.createTextNode("Dashboard");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var morphs = new Array(1);
            morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, 0);
            return morphs;
          },
          statements: [
            ["inline","fa-icon",["tachometer"],[],["loc",[null,[1,107],[1,131]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 0
            },
            "end": {
              "line": 1,
              "column": 170
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("li");
          dom.setAttribute(el1,"class","auth-link");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["block","link-to",["application"],["classNames","button success"],0,null,["loc",[null,[1,53],[1,165]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 199
            },
            "end": {
              "line": 1,
              "column": 314
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","fa-icon",["pencil"],[],["loc",[null,[1,265],[1,285]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 314
            },
            "end": {
              "line": 1,
              "column": 433
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","t",["buttons.signup"],[],["loc",[null,[1,400],[1,422]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 467
            },
            "end": {
              "line": 1,
              "column": 588
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [0]);
          var morphs = new Array(2);
          morphs[0] = dom.createElementMorph(element0);
          morphs[1] = dom.createMorphAt(element0,0,0);
          return morphs;
        },
        statements: [
          ["element","action",["invalidateSession"],["on","click"],["loc",[null,[1,501],[1,542]]]],
          ["inline","fa-icon",["sign-out"],[],["loc",[null,[1,543],[1,565]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 588
            },
            "end": {
              "line": 1,
              "column": 692
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","t",["buttons.login"],[],["loc",[null,[1,667],[1,688]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 704
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(3);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        dom.insertBoundary(fragment, 0);
        return morphs;
      },
      statements: [
        ["block","if",[["get","session.isAuthenticated",["loc",[null,[1,6],[1,29]]]]],[],0,null,["loc",[null,[1,0],[1,177]]]],
        ["block","if",[["get","session.isAuthenticated",["loc",[null,[1,205],[1,228]]]]],[],1,2,["loc",[null,[1,199],[1,440]]]],
        ["block","if",[["get","session.isAuthenticated",["loc",[null,[1,473],[1,496]]]]],[],3,4,["loc",[null,[1,467],[1,699]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4]
    };
  }()));

});
define('aeonvera/templates/components/pricing-preview', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1594
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0, 0, 0, 0]);
        var element1 = dom.childAt(element0, [1, 0, 1, 0, 1, 0]);
        var element2 = dom.childAt(element0, [5, 0, 0, 0, 0]);
        var morphs = new Array(3);
        morphs[0] = dom.createElementMorph(element1);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [2, 1, 0, 0]),0,0);
        morphs[2] = dom.createElementMorph(element2);
        return morphs;
      },
      statements: [
        ["element","action",["reCalculate"],["on","keyUp"],["loc",[null,[1,597],[1,632]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,930],[1,945]]]],
        ["element","action",["reCalculate"],["on","click"],["loc",[null,[1,1447],[1,1482]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/radio-button', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 0
            },
            "end": {
              "line": 15,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("label");
          var el2 = dom.createTextNode("\n    ");
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createTextNode("\n\n    ");
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createTextNode("\n  ");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [1]);
          var morphs = new Array(4);
          morphs[0] = dom.createAttrMorph(element0, 'class');
          morphs[1] = dom.createAttrMorph(element0, 'for');
          morphs[2] = dom.createMorphAt(element0,1,1);
          morphs[3] = dom.createMorphAt(element0,3,3);
          return morphs;
        },
        statements: [
          ["attribute","class",["concat",["ember-radio-button ",["subexpr","if",[["get","checked",["loc",[null,[2,40],[2,47]]]],"checked"],[],["loc",[null,[2,35],[2,59]]]]," ",["get","joinedClassNames",["loc",[null,[2,62],[2,78]]]]]]],
          ["attribute","for",["get","radioId",["loc",[null,[2,88],[2,95]]]]],
          ["inline","radio-button-input",[],["class",["subexpr","@mut",[["get","radioClass",["loc",[null,[4,14],[4,24]]]]],[],[]],"id",["subexpr","@mut",[["get","radioId",["loc",[null,[5,11],[5,18]]]]],[],[]],"disabled",["subexpr","@mut",[["get","disabled",["loc",[null,[6,17],[6,25]]]]],[],[]],"name",["subexpr","@mut",[["get","name",["loc",[null,[7,13],[7,17]]]]],[],[]],"required",["subexpr","@mut",[["get","required",["loc",[null,[8,17],[8,25]]]]],[],[]],"groupValue",["subexpr","@mut",[["get","groupValue",["loc",[null,[9,19],[9,29]]]]],[],[]],"value",["subexpr","@mut",[["get","value",["loc",[null,[10,14],[10,19]]]]],[],[]],"changed","changed"],["loc",[null,[3,4],[11,27]]]],
          ["content","yield",["loc",[null,[13,4],[13,13]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 15,
              "column": 0
            },
            "end": {
              "line": 25,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          return morphs;
        },
        statements: [
          ["inline","radio-button-input",[],["class",["subexpr","@mut",[["get","radioClass",["loc",[null,[17,12],[17,22]]]]],[],[]],"id",["subexpr","@mut",[["get","radioId",["loc",[null,[18,9],[18,16]]]]],[],[]],"disabled",["subexpr","@mut",[["get","disabled",["loc",[null,[19,15],[19,23]]]]],[],[]],"name",["subexpr","@mut",[["get","name",["loc",[null,[20,11],[20,15]]]]],[],[]],"required",["subexpr","@mut",[["get","required",["loc",[null,[21,15],[21,23]]]]],[],[]],"groupValue",["subexpr","@mut",[["get","groupValue",["loc",[null,[22,17],[22,27]]]]],[],[]],"value",["subexpr","@mut",[["get","value",["loc",[null,[23,12],[23,17]]]]],[],[]],"changed","changed"],["loc",[null,[16,2],[24,25]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 26,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["block","if",[["get","hasBlock",["loc",[null,[1,6],[1,14]]]]],[],0,1,["loc",[null,[1,0],[25,7]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/components/sidebar-container', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 73
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","sidebar");
        var el2 = dom.createElement("nav");
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","side-nav");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0, 0]),0,0);
        return morphs;
      },
      statements: [
        ["content","yield",["loc",[null,[1,47],[1,56]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/sidebar/dashboard-sidebar', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 41
            },
            "end": {
              "line": 1,
              "column": 90
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Edit Profile");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 151
            },
            "end": {
              "line": 1,
              "column": 223
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Registered Events");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 244
            },
            "end": {
              "line": 1,
              "column": 308
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Hosted Events");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 329
            },
            "end": {
              "line": 1,
              "column": 379
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Orders");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 523
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createTextNode("Manage");
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
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createTextNode(" ");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"href","/hosted_events/new");
        dom.setAttribute(el2,"class","button success expand");
        var el3 = dom.createTextNode("Create an Event");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [4]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [5]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(fragment, [6]),0,0);
        return morphs;
      },
      statements: [
        ["content","session.currentUser.name",["loc",[null,[1,4],[1,32]]]],
        ["block","link-to",["user.edit"],[],0,null,["loc",[null,[1,41],[1,102]]]],
        ["block","link-to",["dashboard.registered-events"],[],1,null,["loc",[null,[1,151],[1,235]]]],
        ["block","link-to",["dashboard.hosted-events"],[],2,null,["loc",[null,[1,244],[1,320]]]],
        ["block","link-to",["dashboard.orders"],[],3,null,["loc",[null,[1,329],[1,391]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3]
    };
  }()));

});
define('aeonvera/templates/components/sidebar/event-at-the-door-sidebar', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 223
            },
            "end": {
              "line": 1,
              "column": 339
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Competition List");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 360
            },
            "end": {
              "line": 1,
              "column": 464
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("A La Carte");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 481
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"class","button percent-width-100");
        var el3 = dom.createTextNode("Checkin");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"class","button percent-width-100");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Register");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0]);
        var element1 = dom.childAt(fragment, [1, 0]);
        var morphs = new Array(4);
        morphs[0] = dom.createAttrMorph(element0, 'href');
        morphs[1] = dom.createAttrMorph(element1, 'href');
        morphs[2] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(fragment, [3]),0,0);
        return morphs;
      },
      statements: [
        ["attribute","href",["concat",["/hosted_events/",["get","model.id",["loc",[null,[1,30],[1,38]]]],"/checkin"]]],
        ["attribute","href",["concat",["hosted_events/",["get","model.id",["loc",[null,[1,128],[1,136]]]],"/attendances/new"]]],
        ["block","link-to",["event-at-the-door.competition-list"],["classNames","button percent-width-100"],0,null,["loc",[null,[1,223],[1,351]]]],
        ["block","link-to",["event-at-the-door.a-la-carte"],["classNames","button percent-width-100"],1,null,["loc",[null,[1,360],[1,476]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/components/sidebar/event-sidebar', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 8
            },
            "end": {
              "line": 1,
              "column": 57
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["content","model.name",["loc",[null,[1,43],[1,57]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 83
            },
            "end": {
              "line": 1,
              "column": 148
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("At the Door");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1092
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("h5");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createTextNode("View");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Attendees");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Unpaid Registrations");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Cancelled Registrations");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Packet Printout");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Volunteers");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Housing");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createTextNode("Reporting");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Revenue");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        var el3 = dom.createElement("span");
        var el4 = dom.createTextNode("Charts");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        dom.setAttribute(el1,"class","divider");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("li");
        var el2 = dom.createElement("a");
        dom.setAttribute(el2,"class","button expand");
        var el3 = dom.createTextNode("Manage");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [4, 0]);
        var element1 = dom.childAt(fragment, [5, 0]);
        var element2 = dom.childAt(fragment, [6, 0]);
        var element3 = dom.childAt(fragment, [8, 0]);
        var element4 = dom.childAt(fragment, [9, 0]);
        var element5 = dom.childAt(fragment, [10, 0]);
        var element6 = dom.childAt(fragment, [13, 0]);
        var element7 = dom.childAt(fragment, [14, 0]);
        var element8 = dom.childAt(fragment, [16, 0]);
        var morphs = new Array(11);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[2] = dom.createAttrMorph(element0, 'href');
        morphs[3] = dom.createAttrMorph(element1, 'href');
        morphs[4] = dom.createAttrMorph(element2, 'href');
        morphs[5] = dom.createAttrMorph(element3, 'href');
        morphs[6] = dom.createAttrMorph(element4, 'href');
        morphs[7] = dom.createAttrMorph(element5, 'href');
        morphs[8] = dom.createAttrMorph(element6, 'href');
        morphs[9] = dom.createAttrMorph(element7, 'href');
        morphs[10] = dom.createAttrMorph(element8, 'href');
        return morphs;
      },
      statements: [
        ["block","link-to",["events.show",["get","model.id",["loc",[null,[1,33],[1,41]]]]],[],0,null,["loc",[null,[1,8],[1,69]]]],
        ["block","link-to",["event-at-the-door",["get","event.id",["loc",[null,[1,114],[1,122]]]]],[],1,null,["loc",[null,[1,83],[1,160]]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,233],[1,241]]]],"/attendances"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,318],[1,326]]]],"/attendances/unpaid"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,421],[1,429]]]],"/cancelled_attendances"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,555],[1,563]]]],"/packet_printout"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,650],[1,658]]]],"/volunteers"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,735],[1,743]]]],"/housing"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,857],[1,865]]]],"/revenue"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,936],[1,944]]]],"/charts"]]],
        ["attribute","href",["concat",["/hosted_events/",["get","event.id",["loc",[null,[1,1038],[1,1046]]]],"/edit"]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/components/sign-up-modal', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 263
            },
            "end": {
              "line": 1,
              "column": 467
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          return morphs;
        },
        statements: [
          ["inline","input",[],["value",["subexpr","@mut",[["get","model.firstName",["loc",[null,[1,399],[1,414]]]]],[],[]],"placeholder","","type","text","required","true"],["loc",[null,[1,385],[1,459]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 491
            },
            "end": {
              "line": 1,
              "column": 692
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          return morphs;
        },
        statements: [
          ["inline","input",[],["value",["subexpr","@mut",[["get","model.lastName",["loc",[null,[1,625],[1,639]]]]],[],[]],"placeholder","","type","text","required","true"],["loc",[null,[1,611],[1,684]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 739
            },
            "end": {
              "line": 1,
              "column": 940
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          return morphs;
        },
        statements: [
          ["inline","input",[],["value",["subexpr","@mut",[["get","model.email",["loc",[null,[1,857],[1,868]]]]],[],[]],"placeholder","yourname@domain.com","type","text","required","true"],["loc",[null,[1,843],[1,932]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 987
            },
            "end": {
              "line": 1,
              "column": 1392
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [0]);
          var morphs = new Array(2);
          morphs[0] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
          morphs[1] = dom.createMorphAt(element0,2,2);
          return morphs;
        },
        statements: [
          ["inline","tool-tip",[],["message","Length trumps complexity. If it's easier to remember a sentence, do that. This tooltip could even be your password."],["loc",[null,[1,1135],[1,1273]]]],
          ["inline","input",[],["value",["subexpr","@mut",[["get","model.password",["loc",[null,[1,1294],[1,1308]]]]],[],[]],"placeholder","Secure and easy to remember","type","password","required","true"],["loc",[null,[1,1280],[1,1384]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1416
            },
            "end": {
              "line": 1,
              "column": 1684
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          return morphs;
        },
        statements: [
          ["inline","input",[],["value",["subexpr","@mut",[["get","model.passwordConfirmation",["loc",[null,[1,1574],[1,1600]]]]],[],[]],"placeholder","Secure and easy to remember","type","password","required","true"],["loc",[null,[1,1560],[1,1676]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 2018
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element1 = dom.childAt(fragment, [0, 2, 0]);
        var element2 = dom.childAt(element1, [0]);
        var element3 = dom.childAt(element1, [2]);
        var morphs = new Array(6);
        morphs[0] = dom.createElementMorph(element1);
        morphs[1] = dom.createMorphAt(element2,0,0);
        morphs[2] = dom.createMorphAt(element2,1,1);
        morphs[3] = dom.createMorphAt(dom.childAt(element1, [1]),0,0);
        morphs[4] = dom.createMorphAt(element3,0,0);
        morphs[5] = dom.createMorphAt(element3,1,1);
        return morphs;
      },
      statements: [
        ["element","action",["register"],["on","submit"],["loc",[null,[1,212],[1,245]]]],
        ["block","error-field-wrapper",[],["classes","columns small-12 medium-6","errors",["subexpr","@mut",[["get","errors",["loc",[null,[1,329],[1,335]]]]],[],[]],"field","firstName"],0,null,["loc",[null,[1,263],[1,491]]]],
        ["block","error-field-wrapper",[],["classes","columns small-12 medium-6","errors",["subexpr","@mut",[["get","errors",["loc",[null,[1,557],[1,563]]]]],[],[]],"field","lastName"],1,null,["loc",[null,[1,491],[1,716]]]],
        ["block","error-field-wrapper",[],["classes","columns small-12","errors",["subexpr","@mut",[["get","errors",["loc",[null,[1,796],[1,802]]]]],[],[]],"field","email"],2,null,["loc",[null,[1,739],[1,964]]]],
        ["block","error-field-wrapper",[],["classes","columns small-12 medium-6","errors",["subexpr","@mut",[["get","errors",["loc",[null,[1,1053],[1,1059]]]]],[],[]],"field","password"],3,null,["loc",[null,[1,987],[1,1416]]]],
        ["block","error-field-wrapper",[],["classes","columns small-12 medium-6","errors",["subexpr","@mut",[["get","errors",["loc",[null,[1,1482],[1,1488]]]]],[],[]],"field","passwordConfirmation"],4,null,["loc",[null,[1,1416],[1,1708]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4]
    };
  }()));

});
define('aeonvera/templates/components/stripe-checkout', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 0
            },
            "end": {
              "line": 3,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          return morphs;
        },
        statements: [
          ["content","yield",["loc",[null,[2,2],[2,11]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 3,
              "column": 0
            },
            "end": {
              "line": 5,
              "column": 0
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("  ");
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createTextNode("\n");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          return morphs;
        },
        statements: [
          ["content","label",["loc",[null,[4,2],[4,11]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 5,
            "column": 7
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["block","if",[["get","template",["loc",[null,[1,6],[1,14]]]]],[],0,1,["loc",[null,[1,0],[5,7]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/components/stripe/checkout-button', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 11,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        var el1 = dom.createTextNode("\n");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        return morphs;
      },
      statements: [
        ["inline","stripe-checkout",[],["image",["subexpr","@mut",[["get","image",["loc",[null,[2,8],[2,13]]]]],[],[]],"name",["subexpr","@mut",[["get","name",["loc",[null,[3,7],[3,11]]]]],[],[]],"key",["subexpr","@mut",[["get","key",["loc",[null,[4,6],[4,9]]]]],[],[]],"email",["subexpr","@mut",[["get","emailForReceipt",["loc",[null,[5,8],[5,23]]]]],[],[]],"description",["subexpr","@mut",[["get","description",["loc",[null,[6,14],[6,25]]]]],[],[]],"amount",["subexpr","@mut",[["get","amountInCents",["loc",[null,[7,9],[7,22]]]]],[],[]],"allowRememberMe",false,"action","processStripeToken"],["loc",[null,[1,0],[10,2]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/components/tool-tip', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 25
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["inline","fa-icon",["info-circle"],[],["loc",[null,[1,0],[1,25]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/dashboard', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 228
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row full-width");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-3 medium-4 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","sidebar");
        var el4 = dom.createElement("nav");
        var el5 = dom.createElement("ul");
        dom.setAttribute(el5,"class","side-nav");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-9 medium-8 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0, 0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
        return morphs;
      },
      statements: [
        ["inline","component",[["get","sidebar",["loc",[null,[1,125],[1,132]]]]],["model",["subexpr","@mut",[["get","data",["loc",[null,[1,139],[1,143]]]]],[],[]]],["loc",[null,[1,113],[1,145]]]],
        ["content","outlet",["loc",[null,[1,206],[1,216]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/dashboard/hosted-events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        var child0 = (function() {
          return {
            meta: {
              "revision": "Ember@1.13.7",
              "loc": {
                "source": null,
                "start": {
                  "line": 1,
                  "column": 432
                },
                "end": {
                  "line": 1,
                  "column": 481
                }
              }
            },
            arity: 0,
            cachedFragment: null,
            hasRendered: false,
            buildFragment: function buildFragment(dom) {
              var el0 = dom.createDocumentFragment();
              var el1 = dom.createComment("");
              dom.appendChild(el0, el1);
              return el0;
            },
            buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
              var morphs = new Array(1);
              morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
              dom.insertBoundary(fragment, 0);
              dom.insertBoundary(fragment, null);
              return morphs;
            },
            statements: [
              ["content","event.name",["loc",[null,[1,467],[1,481]]]]
            ],
            locals: [],
            templates: []
          };
        }());
        var child1 = (function() {
          return {
            meta: {
              "revision": "Ember@1.13.7",
              "loc": {
                "source": null,
                "start": {
                  "line": 1,
                  "column": 638
                },
                "end": {
                  "line": 1,
                  "column": 687
                }
              }
            },
            arity: 0,
            cachedFragment: null,
            hasRendered: false,
            buildFragment: function buildFragment(dom) {
              var el0 = dom.createDocumentFragment();
              var el1 = dom.createElement("span");
              var el2 = dom.createTextNode("Open");
              dom.appendChild(el1, el2);
              dom.appendChild(el0, el1);
              return el0;
            },
            buildRenderNodes: function buildRenderNodes() { return []; },
            statements: [

            ],
            locals: [],
            templates: []
          };
        }());
        var child2 = (function() {
          var child0 = (function() {
            return {
              meta: {
                "revision": "Ember@1.13.7",
                "loc": {
                  "source": null,
                  "start": {
                    "line": 1,
                    "column": 695
                  },
                  "end": {
                    "line": 1,
                    "column": 736
                  }
                }
              },
              arity: 0,
              cachedFragment: null,
              hasRendered: false,
              buildFragment: function buildFragment(dom) {
                var el0 = dom.createDocumentFragment();
                var el1 = dom.createElement("span");
                var el2 = dom.createTextNode("Closed");
                dom.appendChild(el1, el2);
                dom.appendChild(el0, el1);
                return el0;
              },
              buildRenderNodes: function buildRenderNodes() { return []; },
              statements: [

              ],
              locals: [],
              templates: []
            };
          }());
          var child1 = (function() {
            return {
              meta: {
                "revision": "Ember@1.13.7",
                "loc": {
                  "source": null,
                  "start": {
                    "line": 1,
                    "column": 736
                  },
                  "end": {
                    "line": 1,
                    "column": 797
                  }
                }
              },
              arity: 0,
              cachedFragment: null,
              hasRendered: false,
              buildFragment: function buildFragment(dom) {
                var el0 = dom.createDocumentFragment();
                var el1 = dom.createComment("");
                dom.appendChild(el0, el1);
                return el0;
              },
              buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
                var morphs = new Array(1);
                morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
                dom.insertBoundary(fragment, 0);
                dom.insertBoundary(fragment, null);
                return morphs;
              },
              statements: [
                ["inline","date-with-format",[["get","event.registrationOpensAt",["loc",[null,[1,763],[1,788]]]],"llll"],[],["loc",[null,[1,744],[1,797]]]]
              ],
              locals: [],
              templates: []
            };
          }());
          return {
            meta: {
              "revision": "Ember@1.13.7",
              "loc": {
                "source": null,
                "start": {
                  "line": 1,
                  "column": 687
                },
                "end": {
                  "line": 1,
                  "column": 804
                }
              }
            },
            arity: 0,
            cachedFragment: null,
            hasRendered: false,
            buildFragment: function buildFragment(dom) {
              var el0 = dom.createDocumentFragment();
              var el1 = dom.createComment("");
              dom.appendChild(el0, el1);
              return el0;
            },
            buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
              var morphs = new Array(1);
              morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
              dom.insertBoundary(fragment, 0);
              dom.insertBoundary(fragment, null);
              return morphs;
            },
            statements: [
              ["block","if",[["get","event.hasEnded",["loc",[null,[1,701],[1,715]]]]],[],0,1,["loc",[null,[1,695],[1,804]]]]
            ],
            locals: [],
            templates: [child0, child1]
          };
        }());
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 392
              },
              "end": {
                "line": 1,
                "column": 872
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
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
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var morphs = new Array(7);
            morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
            morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
            morphs[2] = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
            morphs[3] = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
            morphs[4] = dom.createMorphAt(dom.childAt(element0, [4]),0,0);
            morphs[5] = dom.createMorphAt(dom.childAt(element0, [5]),0,0);
            morphs[6] = dom.createMorphAt(dom.childAt(element0, [6]),0,0);
            return morphs;
          },
          statements: [
            ["block","link-to",["events.show",["get","event.id",["loc",[null,[1,457],[1,465]]]]],[],0,null,["loc",[null,[1,432],[1,493]]]],
            ["content","event.totalAttendees",["loc",[null,[1,502],[1,526]]]],
            ["content","event.numberOfLeads",["loc",[null,[1,535],[1,558]]]],
            ["content","event.numberOfFollows",["loc",[null,[1,567],[1,592]]]],
            ["content","event.numberOfShirtsSold",["loc",[null,[1,601],[1,629]]]],
            ["block","if",[["get","event.isRegistrationOpen",["loc",[null,[1,644],[1,668]]]]],[],1,2,["loc",[null,[1,638],[1,811]]]],
            ["inline","date-range",[["get","event.startsAt",["loc",[null,[1,833],[1,847]]]],["get","event.endsAt",["loc",[null,[1,848],[1,860]]]]],[],["loc",[null,[1,820],[1,862]]]]
          ],
          locals: ["event"],
          templates: [child0, child1, child2]
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 127
            },
            "end": {
              "line": 1,
              "column": 889
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("table");
          dom.setAttribute(el1,"class","responsive");
          var el2 = dom.createElement("tr");
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Name");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          dom.setAttribute(el3,"colspan","3");
          dom.setAttribute(el3,"class","text-center");
          var el4 = dom.createTextNode("Attendees");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Shirts Sold");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Registration Opens");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Date");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("tr");
          var el3 = dom.createElement("th");
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Total");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Leads");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Follows");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Total");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),2,2);
          return morphs;
        },
        statements: [
          ["block","each",[["get","filteredModel",["loc",[null,[1,409],[1,422]]]]],[],0,null,["loc",[null,[1,392],[1,881]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 889
            },
            "end": {
              "line": 1,
              "column": 1022
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("p");
          var el2 = dom.createTextNode("You have not yet hosted an event. Hosting an event is free! Click the 'Host an Event' button below to get get started.");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1029
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Hosted Events");
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","right");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("label");
        var el4 = dom.createTextNode("Show Only My Events");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 1]),0,0);
        morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["inline","input",[],["type","checkbox","checked",["subexpr","@mut",[["get","showMyEvents",["loc",[null,[1,68],[1,80]]]]],[],[]]],["loc",[null,[1,36],[1,82]]]],
        ["block","if",[["get","model",["loc",[null,[1,133],[1,138]]]]],[],0,1,["loc",[null,[1,127],[1,1029]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/dashboard/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 842
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Welcome, ");
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        var el2 = dom.createTextNode("!");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
        morphs[1] = dom.createMorphAt(fragment,2,2,contextualElement);
        return morphs;
      },
      statements: [
        ["content","session.currentUser.name",["loc",[null,[1,13],[1,41]]]],
        ["content","outlet",["loc",[null,[1,51],[1,61]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/dashboard/orders', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 110
              },
              "end": {
                "line": 1,
                "column": 297
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("tr");
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
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
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var element1 = dom.childAt(element0, [1, 0]);
            var morphs = new Array(4);
            morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
            morphs[1] = dom.createAttrMorph(element1, 'href');
            morphs[2] = dom.createMorphAt(element1,0,0);
            morphs[3] = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
            return morphs;
          },
          statements: [
            ["inline","date-with-format",[["get","order.createdAt",["loc",[null,[1,161],[1,176]]]],"LLL"],[],["loc",[null,[1,142],[1,184]]]],
            ["attribute","href",["get","order.hostUrl",["loc",[null,[1,213],[1,226]]]]],
            ["content","order.hostName",["loc",[null,[1,229],[1,247]]]],
            ["inline","to-usd",[["get","order.paidAmount",["loc",[null,[1,269],[1,285]]]]],[],["loc",[null,[1,260],[1,287]]]]
          ],
          locals: ["order"],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 17
            },
            "end": {
              "line": 1,
              "column": 314
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("table");
          dom.setAttribute(el1,"class","responsive");
          var el2 = dom.createElement("tr");
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Date");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Event Name");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("th");
          var el4 = dom.createTextNode("Paid");
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),1,1);
          return morphs;
        },
        statements: [
          ["block","each",[["get","model",["loc",[null,[1,127],[1,132]]]]],[],0,null,["loc",[null,[1,110],[1,306]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 321
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Payments");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["block","if",[["get","model",["loc",[null,[1,23],[1,28]]]]],[],0,null,["loc",[null,[1,17],[1,321]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/dashboard/registered-events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 178
              },
              "end": {
                "line": 1,
                "column": 448
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
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
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var element1 = dom.childAt(element0, [0, 0]);
            var morphs = new Array(6);
            morphs[0] = dom.createAttrMorph(element1, 'href');
            morphs[1] = dom.createMorphAt(element1,0,0);
            morphs[2] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
            morphs[3] = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
            morphs[4] = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
            morphs[5] = dom.createMorphAt(dom.childAt(element0, [4]),0,0);
            return morphs;
          },
          statements: [
            ["attribute","href",["get","event.url",["loc",[null,[1,230],[1,239]]]]],
            ["content","event.name",["loc",[null,[1,242],[1,256]]]],
            ["inline","date-with-format",[["get","event.registeredAt",["loc",[null,[1,288],[1,306]]]],"LLL"],[],["loc",[null,[1,269],[1,314]]]],
            ["content","event.paymentStatus",["loc",[null,[1,323],[1,346]]]],
            ["inline","date-with-format",[["get","event.eventBeginsAt",["loc",[null,[1,374],[1,393]]]],"LLL"],[],["loc",[null,[1,355],[1,401]]]],
            ["content","event.registrationStatus",["loc",[null,[1,410],[1,438]]]]
          ],
          locals: ["event"],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 165
            },
            "end": {
              "line": 1,
              "column": 457
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["block","each",[["get","model",["loc",[null,[1,195],[1,200]]]]],[],0,null,["loc",[null,[1,178],[1,457]]]]
        ],
        locals: [],
        templates: [child0]
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 457
            },
            "end": {
              "line": 1,
              "column": 623
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 663
            },
            "end": {
              "line": 1,
              "column": 746
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("View Upcoming Events");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 764
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("h3");
        var el2 = dom.createTextNode("Registered Events");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("table");
        dom.setAttribute(el1,"class","responsive");
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
        var el5 = dom.createTextNode("Payment");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Event Begins");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("th");
        var el5 = dom.createTextNode("Status");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","text-center");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [1]),1,1);
        morphs[1] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
        return morphs;
      },
      statements: [
        ["block","if",[["get","model",["loc",[null,[1,171],[1,176]]]]],[],0,1,["loc",[null,[1,165],[1,630]]]],
        ["block","link-to",["upcoming-events"],["classNames","button"],2,null,["loc",[null,[1,663],[1,758]]]]
      ],
      locals: [],
      templates: [child0, child1, child2]
    };
  }()));

});
define('aeonvera/templates/event-at-the-door', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 10
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["content","outlet",["loc",[null,[1,0],[1,10]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/event-at-the-door/a-la-carte', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 79
            },
            "end": {
              "line": 1,
              "column": 150
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","sidebar/event-at-the-door-sidebar",[],["model",["subexpr","@mut",[["get","event",["loc",[null,[1,143],[1,148]]]]],[],[]]],["loc",[null,[1,101],[1,150]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 308
            },
            "end": {
              "line": 1,
              "column": 484
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("li");
          var el2 = dom.createElement("a");
          dom.setAttribute(el2,"class","button percent-width-100 secondary");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(" (");
          dom.appendChild(el2, el3);
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(")");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element8 = dom.childAt(fragment, [0, 0]);
          var morphs = new Array(3);
          morphs[0] = dom.createElementMorph(element8);
          morphs[1] = dom.createMorphAt(element8,0,0);
          morphs[2] = dom.createMorphAt(element8,2,2);
          return morphs;
        },
        statements: [
          ["element","action",["addToOrder",["get","item",["loc",[null,[1,370],[1,374]]]]],["on","click"],["loc",[null,[1,348],[1,387]]]],
          ["content","item.name",["loc",[null,[1,431],[1,444]]]],
          ["inline","to-usd",[["get","item.currentPrice",["loc",[null,[1,455],[1,472]]]]],[],["loc",[null,[1,446],[1,474]]]]
        ],
        locals: ["item"],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 580
            },
            "end": {
              "line": 1,
              "column": 753
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("li");
          var el2 = dom.createElement("a");
          dom.setAttribute(el2,"class","button percent-width-100 secondary");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(" (");
          dom.appendChild(el2, el3);
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(")");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element7 = dom.childAt(fragment, [0, 0]);
          var morphs = new Array(3);
          morphs[0] = dom.createElementMorph(element7);
          morphs[1] = dom.createMorphAt(element7,0,0);
          morphs[2] = dom.createMorphAt(element7,2,2);
          return morphs;
        },
        statements: [
          ["element","action",["addToOrder",["get","item",["loc",[null,[1,639],[1,643]]]]],["on","click"],["loc",[null,[1,617],[1,656]]]],
          ["content","item.name",["loc",[null,[1,700],[1,713]]]],
          ["inline","to-usd",[["get","item.currentPrice",["loc",[null,[1,724],[1,741]]]]],[],["loc",[null,[1,715],[1,743]]]]
        ],
        locals: ["item"],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 855
            },
            "end": {
              "line": 1,
              "column": 1034
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("li");
          var el2 = dom.createElement("a");
          dom.setAttribute(el2,"class","button percent-width-100 secondary");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(" (");
          dom.appendChild(el2, el3);
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createTextNode(")");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element6 = dom.childAt(fragment, [0, 0]);
          var morphs = new Array(3);
          morphs[0] = dom.createElementMorph(element6);
          morphs[1] = dom.createMorphAt(element6,0,0);
          morphs[2] = dom.createMorphAt(element6,2,2);
          return morphs;
        },
        statements: [
          ["element","action",["addToOrder",["get","item",["loc",[null,[1,920],[1,924]]]]],["on","click"],["loc",[null,[1,898],[1,937]]]],
          ["content","item.name",["loc",[null,[1,981],[1,994]]]],
          ["inline","to-usd",[["get","item.currentPrice",["loc",[null,[1,1005],[1,1022]]]]],[],["loc",[null,[1,996],[1,1024]]]]
        ],
        locals: ["item"],
        templates: []
      };
    }());
    var child4 = (function() {
      var child0 = (function() {
        var child0 = (function() {
          var child0 = (function() {
            return {
              meta: {
                "revision": "Ember@1.13.7",
                "loc": {
                  "source": null,
                  "start": {
                    "line": 1,
                    "column": 1510
                  },
                  "end": {
                    "line": 1,
                    "column": 1618
                  }
                }
              },
              arity: 0,
              cachedFragment: null,
              hasRendered: false,
              buildFragment: function buildFragment(dom) {
                var el0 = dom.createDocumentFragment();
                var el1 = dom.createComment("");
                dom.appendChild(el0, el1);
                return el0;
              },
              buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
                var morphs = new Array(1);
                morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
                dom.insertBoundary(fragment, 0);
                dom.insertBoundary(fragment, null);
                return morphs;
              },
              statements: [
                ["inline","input",[],["type","text","value",["subexpr","@mut",[["get","item.partnerName",["loc",[null,[1,1573],[1,1589]]]]],[],[]],"placeholder","Partner Name"],["loc",[null,[1,1547],[1,1618]]]]
              ],
              locals: [],
              templates: []
            };
          }());
          var child1 = (function() {
            return {
              meta: {
                "revision": "Ember@1.13.7",
                "loc": {
                  "source": null,
                  "start": {
                    "line": 1,
                    "column": 1625
                  },
                  "end": {
                    "line": 1,
                    "column": 1836
                  }
                }
              },
              arity: 0,
              cachedFragment: null,
              hasRendered: false,
              buildFragment: function buildFragment(dom) {
                var el0 = dom.createDocumentFragment();
                var el1 = dom.createComment("");
                dom.appendChild(el0, el1);
                var el1 = dom.createElement("label");
                var el2 = dom.createTextNode("Lead");
                dom.appendChild(el1, el2);
                dom.appendChild(el0, el1);
                var el1 = dom.createComment("");
                dom.appendChild(el0, el1);
                var el1 = dom.createElement("label");
                var el2 = dom.createTextNode("Follow");
                dom.appendChild(el1, el2);
                dom.appendChild(el0, el1);
                var el1 = dom.createElement("br");
                dom.appendChild(el0, el1);
                return el0;
              },
              buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
                var morphs = new Array(2);
                morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
                morphs[1] = dom.createMorphAt(fragment,2,2,contextualElement);
                dom.insertBoundary(fragment, 0);
                return morphs;
              },
              statements: [
                ["inline","radio-button",[],["value","Lead","groupValue",["subexpr","@mut",[["get","item.danceOrientation",["loc",[null,[1,1705],[1,1726]]]]],[],[]]],["loc",[null,[1,1666],[1,1728]]]],
                ["inline","radio-button",[],["value","Follow","groupValue",["subexpr","@mut",[["get","item.danceOrientation",["loc",[null,[1,1788],[1,1809]]]]],[],[]]],["loc",[null,[1,1747],[1,1811]]]]
              ],
              locals: [],
              templates: []
            };
          }());
          return {
            meta: {
              "revision": "Ember@1.13.7",
              "loc": {
                "source": null,
                "start": {
                  "line": 1,
                  "column": 1484
                },
                "end": {
                  "line": 1,
                  "column": 1843
                }
              }
            },
            arity: 0,
            cachedFragment: null,
            hasRendered: false,
            buildFragment: function buildFragment(dom) {
              var el0 = dom.createDocumentFragment();
              var el1 = dom.createComment("");
              dom.appendChild(el0, el1);
              var el1 = dom.createComment("");
              dom.appendChild(el0, el1);
              return el0;
            },
            buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
              var morphs = new Array(2);
              morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
              morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
              dom.insertBoundary(fragment, 0);
              dom.insertBoundary(fragment, null);
              return morphs;
            },
            statements: [
              ["block","if",[["get","item.lineItem.requiresPartner",["loc",[null,[1,1516],[1,1545]]]]],[],0,null,["loc",[null,[1,1510],[1,1625]]]],
              ["block","if",[["get","item.lineItem.requiresOrientation",["loc",[null,[1,1631],[1,1664]]]]],[],1,null,["loc",[null,[1,1625],[1,1843]]]]
            ],
            locals: [],
            templates: [child0, child1]
          };
        }());
        var child1 = (function() {
          return {
            meta: {
              "revision": "Ember@1.13.7",
              "loc": {
                "source": null,
                "start": {
                  "line": 1,
                  "column": 1850
                },
                "end": {
                  "line": 1,
                  "column": 2025
                }
              }
            },
            arity: 0,
            cachedFragment: null,
            hasRendered: false,
            buildFragment: function buildFragment(dom) {
              var el0 = dom.createDocumentFragment();
              var el1 = dom.createComment("");
              dom.appendChild(el0, el1);
              var el1 = dom.createElement("br");
              dom.appendChild(el0, el1);
              return el0;
            },
            buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
              var morphs = new Array(1);
              morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
              dom.insertBoundary(fragment, 0);
              return morphs;
            },
            statements: [
              ["inline","select-2",[],["content",["subexpr","@mut",[["get","item.lineItem.sizes",["loc",[null,[1,1889],[1,1908]]]]],[],[]],"value",["subexpr","@mut",[["get","item.size",["loc",[null,[1,1915],[1,1924]]]]],[],[]],"placeholder","Select Shirt Size","optionLabelPath","size","allowClear",false,"optionValuePath","size"],["loc",[null,[1,1870],[1,2021]]]]
            ],
            locals: [],
            templates: []
          };
        }());
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 1399
              },
              "end": {
                "line": 1,
                "column": 2110
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("tr");
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            var el2 = dom.createElement("td");
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            var el3 = dom.createElement("br");
            dom.appendChild(el2, el3);
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            var el3 = dom.createComment("");
            dom.appendChild(el2, el3);
            var el3 = dom.createElement("small");
            var el4 = dom.createElement("a");
            var el5 = dom.createTextNode("Remove");
            dom.appendChild(el4, el5);
            dom.appendChild(el3, el4);
            dom.appendChild(el2, el3);
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var element0 = dom.childAt(fragment, [0]);
            var element1 = dom.childAt(element0, [1]);
            var element2 = dom.childAt(element1, [4, 0]);
            var morphs = new Array(5);
            morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
            morphs[1] = dom.createMorphAt(element1,0,0);
            morphs[2] = dom.createMorphAt(element1,2,2);
            morphs[3] = dom.createMorphAt(element1,3,3);
            morphs[4] = dom.createElementMorph(element2);
            return morphs;
          },
          statements: [
            ["inline","to-usd",[["get","item.total",["loc",[null,[1,1446],[1,1456]]]]],[],["loc",[null,[1,1437],[1,1458]]]],
            ["content","item.name",["loc",[null,[1,1467],[1,1480]]]],
            ["block","if",[["get","item.isCompetition",["loc",[null,[1,1490],[1,1508]]]]],[],0,null,["loc",[null,[1,1484],[1,1850]]]],
            ["block","if",[["get","item.isShirt",["loc",[null,[1,1856],[1,1868]]]]],[],1,null,["loc",[null,[1,1850],[1,2032]]]],
            ["element","action",["removeItem",["get","item",["loc",[null,[1,2064],[1,2068]]]]],["on","click"],["loc",[null,[1,2042],[1,2081]]]]
          ],
          locals: ["item"],
          templates: [child0, child1]
        };
      }());
      var child1 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 2421
              },
              "end": {
                "line": 1,
                "column": 2542
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var morphs = new Array(1);
            morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, 0);
            dom.insertBoundary(fragment, null);
            return morphs;
          },
          statements: [
            ["inline","handle-payment",[],["action",["subexpr","@mut",[["get","process",["loc",[null,[1,2514],[1,2521]]]]],[],[]],"model",["subexpr","@mut",[["get","currentOrder",["loc",[null,[1,2528],[1,2540]]]]],[],[]]],["loc",[null,[1,2490],[1,2542]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1054
            },
            "end": {
              "line": 1,
              "column": 2563
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("div");
          var el2 = dom.createElement("h3");
          var el3 = dom.createTextNode("Current Order");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("label");
          var el3 = dom.createTextNode("Optional (except for competitions):");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("table");
          dom.setAttribute(el2,"class","width-of-100 no-border");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("tfoot");
          var el4 = dom.createElement("tr");
          var el5 = dom.createElement("th");
          var el6 = dom.createComment("");
          dom.appendChild(el5, el6);
          dom.appendChild(el4, el5);
          var el5 = dom.createElement("th");
          var el6 = dom.createTextNode("Total");
          dom.appendChild(el5, el6);
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("hr");
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("ul");
          dom.setAttribute(el2,"class","button-group even-2");
          var el3 = dom.createElement("li");
          var el4 = dom.createElement("a");
          dom.setAttribute(el4,"class","button alert");
          var el5 = dom.createTextNode("Cancel");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          var el3 = dom.createElement("li");
          var el4 = dom.createElement("a");
          dom.setAttribute(el4,"href","#");
          dom.setAttribute(el4,"data-reveal-id","a-la-carte-pay-modal");
          dom.setAttribute(el4,"class","button success");
          var el5 = dom.createTextNode("Pay");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element3 = dom.childAt(fragment, [0]);
          var element4 = dom.childAt(element3, [3]);
          var element5 = dom.childAt(element3, [5, 0, 0]);
          var morphs = new Array(6);
          morphs[0] = dom.createAttrMorph(element3, 'class');
          morphs[1] = dom.createMorphAt(element3,2,2);
          morphs[2] = dom.createMorphAt(element4,0,0);
          morphs[3] = dom.createMorphAt(dom.childAt(element4, [1, 0, 0]),0,0);
          morphs[4] = dom.createElementMorph(element5);
          morphs[5] = dom.createMorphAt(fragment,1,1,contextualElement);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["attribute","class",["concat",[["subexpr","-bind-attr-class",[["get","orderContainerClasses",[]],"order-container-classes"],[],[]]]]],
          ["inline","select-2",[],["content",["subexpr","@mut",[["get","model.attendances",["loc",[null,[1,1217],[1,1234]]]]],[],[]],"value",["subexpr","@mut",[["get","currentOrder.attendance",["loc",[null,[1,1241],[1,1264]]]]],[],[]],"placeholder","Assign this order to a registrant","allowClear",true,"optionLabelPath","attendeeName"],["loc",[null,[1,1198],[1,1361]]]],
          ["block","each",[["get","currentItems",["loc",[null,[1,1415],[1,1427]]]]],[],0,null,["loc",[null,[1,1399],[1,2119]]]],
          ["inline","to-usd",[["get","currentOrder.subTotal",["loc",[null,[1,2143],[1,2164]]]]],[],["loc",[null,[1,2134],[1,2166]]]],
          ["element","action",["cancelOrder"],["on","click"],["loc",[null,[1,2249],[1,2284]]]],
          ["block","foundation-modal",[],["title","At la Carte Order","name","a-la-carte-pay"],1,null,["loc",[null,[1,2421],[1,2563]]]]
        ],
        locals: [],
        templates: [child0, child1]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 2576
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row full-width");
        var el2 = dom.createElement("div");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("A la Carte");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","small-block-grid-2 medium-block-grid-3 text-center");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Shirts");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","small-block-grid-2 medium-block-grid-3 text-center");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Competitions");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("ul");
        dom.setAttribute(el3,"class","small-block-grid-2 medium-block-grid-3 text-center");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element9 = dom.childAt(fragment, [0]);
        var element10 = dom.childAt(element9, [0]);
        var element11 = dom.childAt(element9, [1]);
        var morphs = new Array(7);
        morphs[0] = dom.createAttrMorph(element10, 'class');
        morphs[1] = dom.createMorphAt(element10,0,0);
        morphs[2] = dom.createAttrMorph(element11, 'class');
        morphs[3] = dom.createMorphAt(dom.childAt(element11, [1]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element11, [4]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element11, [7]),0,0);
        morphs[6] = dom.createMorphAt(element9,2,2);
        return morphs;
      },
      statements: [
        ["attribute","class",["concat",[["subexpr","-bind-attr-class",[["get","sidebarContainerClasses",[]],"sidebar-container-classes"],[],[]]]]],
        ["block","sidebar-container",[],[],0,null,["loc",[null,[1,79],[1,172]]]],
        ["attribute","class",["concat",[["subexpr","-bind-attr-class",[["get","itemContainerClasses",[]],"item-container-classes"],[],[]]]]],
        ["block","each",[["get","model.lineItems",["loc",[null,[1,324],[1,339]]]]],[],1,null,["loc",[null,[1,308],[1,493]]]],
        ["block","each",[["get","model.shirts",["loc",[null,[1,596],[1,608]]]]],[],2,null,["loc",[null,[1,580],[1,762]]]],
        ["block","each",[["get","model.competitions",["loc",[null,[1,871],[1,889]]]]],[],3,null,["loc",[null,[1,855],[1,1043]]]],
        ["block","if",[["get","buildingAnOrder",["loc",[null,[1,1060],[1,1075]]]]],[],4,null,["loc",[null,[1,1054],[1,2570]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4]
    };
  }()));

});
define('aeonvera/templates/event-at-the-door/checkin', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 159
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row max-width-75rem");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("h3");
        var el4 = dom.createTextNode("Checkin Attendees");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0]),1,1);
        return morphs;
      },
      statements: [
        ["inline","component",["event-at-the-door/checkin-list"],["model",["subexpr","@mut",[["get","model",["loc",[null,[1,140],[1,145]]]]],[],[]]],["loc",[null,[1,89],[1,147]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/event-at-the-door/competition-list', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 66
            },
            "end": {
              "line": 1,
              "column": 137
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","sidebar/event-at-the-door-sidebar",[],["model",["subexpr","@mut",[["get","event",["loc",[null,[1,130],[1,135]]]]],[],[]]],["loc",[null,[1,88],[1,137]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 479
              },
              "end": {
                "line": 1,
                "column": 575
              }
            }
          },
          arity: 1,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("td");
            var el2 = dom.createTextNode("competitionResponse.id");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes() { return []; },
          statements: [

          ],
          locals: ["competitionResponse"],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 246
            },
            "end": {
              "line": 1,
              "column": 600
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("h3");
          var el2 = dom.createComment("");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          var el1 = dom.createElement("span");
          var el2 = dom.createComment("");
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
          var el5 = dom.createTextNode("Package");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          var el4 = dom.createElement("th");
          var el5 = dom.createTextNode("Level");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          var el4 = dom.createElement("th");
          var el5 = dom.createTextNode("Orientation");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          var el4 = dom.createElement("th");
          var el5 = dom.createTextNode("Owe");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          var el4 = dom.createElement("th");
          var el5 = dom.createTextNode("Registered At");
          dom.appendChild(el4, el5);
          dom.appendChild(el3, el4);
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          var el2 = dom.createElement("tbody");
          var el3 = dom.createComment("");
          dom.appendChild(el2, el3);
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(4);
          morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0]),0,0);
          morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
          morphs[2] = dom.createMorphAt(dom.childAt(fragment, [2]),0,0);
          morphs[3] = dom.createMorphAt(dom.childAt(fragment, [3, 1]),0,0);
          return morphs;
        },
        statements: [
          ["content","competition.name",["loc",[null,[1,280],[1,300]]]],
          ["content","eventName",["loc",[null,[1,305],[1,318]]]],
          ["content","eventName",["loc",[null,[1,324],[1,337]]]],
          ["block","each",[["get","competition.competitionResponses",["loc",[null,[1,510],[1,542]]]]],[],0,null,["loc",[null,[1,479],[1,584]]]]
        ],
        locals: ["competition"],
        templates: [child0]
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 621
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row full-width");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-3 medium-4 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-9 medium-8 columns");
        var el3 = dom.createElement("h2");
        var el4 = dom.createTextNode("All Competitions for ");
        dom.appendChild(el3, el4);
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [1]);
        var morphs = new Array(3);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0]),1,1);
        morphs[2] = dom.createMorphAt(element1,1,1);
        return morphs;
      },
      statements: [
        ["block","sidebar-container",[],[],0,null,["loc",[null,[1,66],[1,159]]]],
        ["content","eventName",["loc",[null,[1,228],[1,241]]]],
        ["block","each",[["get","model",["loc",[null,[1,269],[1,274]]]]],[],1,null,["loc",[null,[1,246],[1,609]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/event-at-the-door/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 479
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns medium-8 medium-offset-2 text-center");
        var el3 = dom.createElement("h2");
        var el4 = dom.createComment("");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("p");
        var el4 = dom.createTextNode("This is the command center for behind-the-desk operations during an event. From here you can check people in, register new people, see who's competing, add competitions to a registrant, as well as make a la carte sales.");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(element0,4,4);
        return morphs;
      },
      statements: [
        ["content","model.name",["loc",[null,[1,88],[1,102]]]],
        ["inline","sidebar/event-at-the-door-sidebar",[],["model",["subexpr","@mut",[["get","model",["loc",[null,[1,383],[1,388]]]]],[],[]],"tagName","ul","classNames","small-block-grid-1 medium-block-grid-2 text-center"],["loc",[null,[1,341],[1,467]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 247
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("span");
        var el2 = dom.createTextNode("events");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row full-width");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-3 medium-4 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","sidebar");
        var el4 = dom.createElement("nav");
        var el5 = dom.createElement("ul");
        dom.setAttribute(el5,"class","side-nav");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-9 medium-8 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [1]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0, 0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
        return morphs;
      },
      statements: [
        ["inline","component",[["get","sidebar",["loc",[null,[1,144],[1,151]]]]],["model",["subexpr","@mut",[["get","data",["loc",[null,[1,158],[1,162]]]]],[],[]]],["loc",[null,[1,132],[1,164]]]],
        ["content","outlet",["loc",[null,[1,225],[1,235]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/events/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 66
            },
            "end": {
              "line": 1,
              "column": 124
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","sidebar/event-sidebar",[],["model",["subexpr","@mut",[["get","data",["loc",[null,[1,118],[1,122]]]]],[],[]]],["loc",[null,[1,88],[1,124]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 212
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row full-width");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-3 medium-4 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","large-9 medium-8 columns");
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
        return morphs;
      },
      statements: [
        ["block","sidebar-container",[],[],0,null,["loc",[null,[1,66],[1,146]]]],
        ["content","outlet",["loc",[null,[1,190],[1,200]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/events/show', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 10
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["content","outlet",["loc",[null,[1,0],[1,10]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/events/show/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 834
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("br");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("h3");
        var el2 = dom.createComment("");
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("hr");
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","medium-3 columns");
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","small-12 columns text-center");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Total Registrants");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","small-6 columns text-center");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Leads");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h4");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","small-6 columns text-center");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Follows");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h4");
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
        dom.setAttribute(el4,"class","small-12 columns text-center");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Revenue");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","small-12 columns text-center");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Unpaid");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("h3");
        var el6 = dom.createComment("");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","medium-9 columns");
        var el3 = dom.createElement("label");
        var el4 = dom.createTextNode("Most Recent Registrations");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [3]);
        var element1 = dom.childAt(element0, [0]);
        var element2 = dom.childAt(element1, [1]);
        var morphs = new Array(7);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [1]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0, 0, 1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element2, [0, 1]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(element2, [1, 1]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element1, [3, 0, 1]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element1, [4, 0, 1]),0,0);
        morphs[6] = dom.createMorphAt(dom.childAt(element0, [1]),1,1);
        return morphs;
      },
      statements: [
        ["content","model.name",["loc",[null,[1,8],[1,22]]]],
        ["content","model.totalRegistrants",["loc",[null,[1,173],[1,199]]]],
        ["content","model.numberOfLeads",["loc",[null,[1,298],[1,321]]]],
        ["content","model.numberOfFollows",["loc",[null,[1,399],[1,424]]]],
        ["inline","to-usd",[["get","model.revenue",["loc",[null,[1,539],[1,552]]]]],[],["loc",[null,[1,530],[1,554]]]],
        ["inline","to-usd",[["get","model.unpaid",["loc",[null,[1,664],[1,676]]]]],[],["loc",[null,[1,655],[1,678]]]],
        ["inline","attendance-list",[],["model",["subexpr","@mut",[["get","model.recentRegistrations",["loc",[null,[1,795],[1,820]]]]],[],[]]],["loc",[null,[1,771],[1,822]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/register', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 9
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createTextNode("Register!");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/shared/footer', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 83
            },
            "end": {
              "line": 1,
              "column": 121
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["tos"],[],["loc",[null,[1,109],[1,121]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 142
            },
            "end": {
              "line": 1,
              "column": 188
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["privacy"],[],["loc",[null,[1,172],[1,188]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 540
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [0]);
        var element2 = dom.childAt(element1, [0, 0]);
        var element3 = dom.childAt(element1, [1, 0, 0]);
        var morphs = new Array(6);
        morphs[0] = dom.createMorphAt(dom.childAt(element2, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element2, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element2, [2]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element3, [1]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element0, [1, 0, 0]),0,0);
        return morphs;
      },
      statements: [
        ["block","link-to",["welcome.tos"],[],0,null,["loc",[null,[1,83],[1,133]]]],
        ["block","link-to",["welcome.privacy"],[],1,null,["loc",[null,[1,142],[1,200]]]],
        ["content","links/submit-idea-link",["loc",[null,[1,209],[1,235]]]],
        ["content","links/mail-support-icon-link",["loc",[null,[1,328],[1,360]]]],
        ["content","links/facebook-icon-link",["loc",[null,[1,369],[1,397]]]],
        ["inline","t",["copyright"],[],["loc",[null,[1,496],[1,513]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/upcoming-events', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      var child0 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 382
              },
              "end": {
                "line": 1,
                "column": 431
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createElement("span");
            var el2 = dom.createTextNode("Open");
            dom.appendChild(el1, el2);
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes() { return []; },
          statements: [

          ],
          locals: [],
          templates: []
        };
      }());
      var child1 = (function() {
        return {
          meta: {
            "revision": "Ember@1.13.7",
            "loc": {
              "source": null,
              "start": {
                "line": 1,
                "column": 431
              },
              "end": {
                "line": 1,
                "column": 492
              }
            }
          },
          arity: 0,
          cachedFragment: null,
          hasRendered: false,
          buildFragment: function buildFragment(dom) {
            var el0 = dom.createDocumentFragment();
            var el1 = dom.createComment("");
            dom.appendChild(el0, el1);
            return el0;
          },
          buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
            var morphs = new Array(1);
            morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
            dom.insertBoundary(fragment, 0);
            dom.insertBoundary(fragment, null);
            return morphs;
          },
          statements: [
            ["inline","date-with-format",[["get","event.registrationOpensAt",["loc",[null,[1,458],[1,483]]]],"llll"],[],["loc",[null,[1,439],[1,492]]]]
          ],
          locals: [],
          templates: []
        };
      }());
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 221
            },
            "end": {
              "line": 1,
              "column": 509
            }
          }
        },
        arity: 1,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [0]);
          var element1 = dom.childAt(element0, [0, 0]);
          var morphs = new Array(5);
          morphs[0] = dom.createAttrMorph(element1, 'href');
          morphs[1] = dom.createMorphAt(element1,0,0);
          morphs[2] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
          morphs[3] = dom.createMorphAt(dom.childAt(element0, [2]),0,0);
          morphs[4] = dom.createMorphAt(dom.childAt(element0, [3]),0,0);
          return morphs;
        },
        statements: [
          ["attribute","href",["concat",[["get","event.url",["loc",[null,[1,264],[1,273]]]]]]],
          ["content","event.name",["loc",[null,[1,277],[1,291]]]],
          ["content","event.location",["loc",[null,[1,304],[1,322]]]],
          ["inline","date-range",[["get","event.startsAt",["loc",[null,[1,344],[1,358]]]],["get","event.endsAt",["loc",[null,[1,359],[1,371]]]]],[],["loc",[null,[1,331],[1,373]]]],
          ["block","if",[["get","event.isRegistrationOpen",["loc",[null,[1,388],[1,412]]]]],[],0,1,["loc",[null,[1,382],[1,499]]]]
        ],
        locals: ["event"],
        templates: [child0, child1]
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 534
            },
            "end": {
              "line": 1,
              "column": 595
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Back");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 619
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element2 = dom.childAt(fragment, [0, 0]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element2, [1, 1]),0,0);
        morphs[1] = dom.createMorphAt(element2,2,2);
        return morphs;
      },
      statements: [
        ["block","each",[["get","model",["loc",[null,[1,238],[1,243]]]]],[],0,null,["loc",[null,[1,221],[1,518]]]],
        ["block","link-to",["dashboard"],["classNames","button"],1,null,["loc",[null,[1,534],[1,607]]]]
      ],
      locals: [],
      templates: [child0, child1]
    };
  }()));

});
define('aeonvera/templates/user/edit', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 499
            },
            "end": {
              "line": 1,
              "column": 622
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createElement("span");
          var el2 = dom.createTextNode("Currently waiting on confirmation for ");
          dom.appendChild(el1, el2);
          dom.appendChild(el0, el1);
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,1,1,contextualElement);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["content","session.currentUser.unconfirmedEmail",["loc",[null,[1,582],[1,622]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 2141
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row imageoverlay text-center");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","columns small-12");
        var el3 = dom.createElement("h1");
        var el4 = dom.createTextNode("Edit Account");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        var el1 = dom.createElement("div");
        dom.setAttribute(el1,"class","row");
        var el2 = dom.createElement("div");
        dom.setAttribute(el2,"class","small-12 columns");
        var el3 = dom.createElement("h4");
        var el4 = dom.createTextNode("Identity");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("First Name");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Last Name");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Email");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createComment("");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h4");
        var el4 = dom.createTextNode("Password");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("New Password");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("New Password Confirmation");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Current Password");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("h4");
        var el4 = dom.createTextNode("Other Settings");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("div");
        dom.setAttribute(el3,"class","row");
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"class","medium-4 columns");
        var el5 = dom.createElement("label");
        var el6 = dom.createTextNode("Time Zone");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createComment("");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("button");
        dom.setAttribute(el3,"type","submit");
        dom.setAttribute(el3,"class","primary");
        var el4 = dom.createTextNode("Update");
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("hr");
        dom.appendChild(el2, el3);
        var el3 = dom.createElement("p");
        var el4 = dom.createElement("p");
        var el5 = dom.createTextNode("Unhappy?");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("a");
        dom.setAttribute(el4,"href","#");
        dom.setAttribute(el4,"data-reveal-id","cancelAccount");
        dom.setAttribute(el4,"class","button alert");
        var el5 = dom.createTextNode("Cancel My Account");
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        var el4 = dom.createElement("div");
        dom.setAttribute(el4,"id","cancelAccount");
        dom.setAttribute(el4,"data-reveal","");
        dom.setAttribute(el4,"aria-labelledby","modalTitle");
        dom.setAttribute(el4,"aria-hidden","true");
        dom.setAttribute(el4,"role","dialog");
        dom.setAttribute(el4,"class","reveal-modal medium");
        var el5 = dom.createElement("h2");
        dom.setAttribute(el5,"id","modalTitle");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createTextNode(" Cancel Account");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("p");
        dom.setAttribute(el5,"class","lead");
        var el6 = dom.createTextNode("Are you sure you wish to cancel your account? This is mostly destructive.");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("p");
        dom.setAttribute(el5,"class","lead");
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode("You can reactivate your account later by contacting ");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("a");
        dom.setAttribute(el6,"href","mailto:support@aeonvera.com");
        var el7 = dom.createTextNode("support");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        var el6 = dom.createElement("span");
        var el7 = dom.createTextNode(".");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("div");
        dom.setAttribute(el5,"class","text-center");
        var el6 = dom.createElement("button");
        dom.setAttribute(el6,"class","alert");
        var el7 = dom.createTextNode("I'm sure, cancel my account.");
        dom.appendChild(el6, el7);
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        var el5 = dom.createElement("a");
        dom.setAttribute(el5,"aria-label","Close");
        dom.setAttribute(el5,"class","close-reveal-modal");
        var el6 = dom.createTextNode("×");
        dom.appendChild(el5, el6);
        dom.appendChild(el4, el5);
        dom.appendChild(el3, el4);
        dom.appendChild(el2, el3);
        dom.appendChild(el1, el2);
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [1, 0]);
        var element1 = dom.childAt(element0, [1]);
        var element2 = dom.childAt(element0, [4]);
        var element3 = dom.childAt(element0, [7]);
        var element4 = dom.childAt(element0, [9, 2, 3, 0]);
        var morphs = new Array(10);
        morphs[0] = dom.createMorphAt(dom.childAt(element1, [0]),1,1);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [1]),1,1);
        morphs[2] = dom.createMorphAt(dom.childAt(element1, [2]),1,1);
        morphs[3] = dom.createMorphAt(element0,2,2);
        morphs[4] = dom.createMorphAt(dom.childAt(element2, [0]),1,1);
        morphs[5] = dom.createMorphAt(dom.childAt(element2, [1]),1,1);
        morphs[6] = dom.createMorphAt(dom.childAt(element2, [2]),1,1);
        morphs[7] = dom.createMorphAt(dom.childAt(element0, [6, 0]),1,1);
        morphs[8] = dom.createElementMorph(element3);
        morphs[9] = dom.createElementMorph(element4);
        return morphs;
      },
      statements: [
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.firstName",["loc",[null,[1,255],[1,284]]]]],[],[]]],["loc",[null,[1,241],[1,286]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.lastName",["loc",[null,[1,360],[1,388]]]]],[],[]]],["loc",[null,[1,346],[1,390]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.email",["loc",[null,[1,460],[1,485]]]]],[],[]]],["loc",[null,[1,446],[1,487]]]],
        ["block","if",[["get","pendingConfirmation",["loc",[null,[1,505],[1,524]]]]],[],0,null,["loc",[null,[1,499],[1,629]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.password",["loc",[null,[1,734],[1,762]]]]],[],[]],"type","password"],["loc",[null,[1,720],[1,780]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.passwordConfirmation",["loc",[null,[1,870],[1,910]]]]],[],[]],"type","password"],["loc",[null,[1,856],[1,928]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.currentPassword",["loc",[null,[1,1009],[1,1044]]]]],[],[]],"type","password","placeholder","Only needed for changing your password"],["loc",[null,[1,995],[1,1115]]]],
        ["inline","input",[],["value",["subexpr","@mut",[["get","session.currentUser.timeZone",["loc",[null,[1,1235],[1,1263]]]]],[],[]],"disabled",true],["loc",[null,[1,1221],[1,1279]]]],
        ["element","action",["updateCurrentUser"],["on","click"],["loc",[null,[1,1313],[1,1354]]]],
        ["element","action",["deactivateAccount"],["on","click"],["loc",[null,[1,1961],[1,2002]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/welcome/about', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 28,
            "column": 0
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [2]);
        var element1 = dom.childAt(element0, [12]);
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [1]),1,1);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [3]),1,1);
        morphs[2] = dom.createMorphAt(dom.childAt(element0, [7]),1,1);
        morphs[3] = dom.createMorphAt(dom.childAt(element1, [1]),1,1);
        morphs[4] = dom.createMorphAt(dom.childAt(element1, [5]),1,1);
        return morphs;
      },
      statements: [
        ["inline","t",["appname"],[],["loc",[null,[4,4],[4,21]]]],
        ["inline","t",["subheader"],[],["loc",[null,[7,4],[7,23]]]],
        ["inline","t",["copyright"],[],["loc",[null,[11,4],[11,23]]]],
        ["inline","fa-icon",["facebook"],[],["loc",[null,[16,6],[16,30]]]],
        ["inline","fa-icon",["github"],[],["loc",[null,[20,6],[20,28]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/faq', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 3113
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
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
        var morphs = new Array(20);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element1, [0, 0, 0, 0]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(element2, [0, 0, 0]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element3, [0, 1]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element3, [1, 1]),1,1);
        morphs[6] = dom.createMorphAt(dom.childAt(element3, [2, 1]),1,1);
        morphs[7] = dom.createMorphAt(dom.childAt(element4, [0, 0, 0]),0,0);
        morphs[8] = dom.createMorphAt(dom.childAt(element4, [1, 0]),0,0);
        morphs[9] = dom.createMorphAt(dom.childAt(element5, [0, 0, 0]),0,0);
        morphs[10] = dom.createMorphAt(dom.childAt(element6, [0]),0,0);
        morphs[11] = dom.createMorphAt(dom.childAt(element6, [3]),0,0);
        morphs[12] = dom.createMorphAt(element7,0,0);
        morphs[13] = dom.createMorphAt(element7,2,2);
        morphs[14] = dom.createMorphAt(dom.childAt(element8, [0, 0, 0]),0,0);
        morphs[15] = dom.createMorphAt(dom.childAt(element8, [1, 0]),0,0);
        morphs[16] = dom.createMorphAt(dom.childAt(element9, [0, 0, 0]),0,0);
        morphs[17] = dom.createMorphAt(dom.childAt(element9, [1, 0]),0,0);
        morphs[18] = dom.createMorphAt(dom.childAt(element10, [0, 0, 0]),0,0);
        morphs[19] = dom.createMorphAt(dom.childAt(element10, [1, 0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["faq"],[],["loc",[null,[1,77],[1,88]]]],
        ["inline","t",["faqfull"],[],["loc",[null,[1,115],[1,130]]]],
        ["inline","t",["faqtext.questions.whystripe"],[],["loc",[null,[1,286],[1,321]]]],
        ["inline","t",["faqtext.questions.pricecompare"],[],["loc",[null,[1,1339],[1,1377]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1503],[1,1518]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1745],[1,1760]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1925],[1,1940]]]],
        ["inline","t",["faqtext.questions.name"],[],["loc",[null,[1,2073],[1,2103]]]],
        ["inline","t",["faqtext.answers.name"],[],["loc",[null,[1,2157],[1,2185]]]],
        ["inline","t",["faqtext.questions.pronounce"],[],["loc",[null,[1,2265],[1,2300]]]],
        ["inline","t",["faqtext.answers.pronounce"],[],["loc",[null,[1,2354],[1,2387]]]],
        ["inline","t",["formoreinfo"],[],["loc",[null,[1,2408],[1,2427]]]],
        ["content","how-to-pronounce-ae",["loc",[null,[1,2440],[1,2463]]]],
        ["content","links/aeon-wikipedia-link",["loc",[null,[1,2465],[1,2494]]]],
        ["inline","t",["faqtext.questions.idea"],[],["loc",[null,[1,2574],[1,2604]]]],
        ["inline","t",["faqtext.answers.idea"],[],["loc",[null,[1,2658],[1,2686]]]],
        ["inline","t",["faqtext.questions.howhelp"],[],["loc",[null,[1,2766],[1,2799]]]],
        ["inline","t",["faqtext.answers.howhelp"],[],["loc",[null,[1,2853],[1,2884]]]],
        ["inline","t",["faqtext.questions.butthis"],[],["loc",[null,[1,2964],[1,2997]]]],
        ["inline","t",["faqtext.answers.butthis"],[],["loc",[null,[1,3043],[1,3074]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 590
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(8);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 2]),0,0);
        morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
        morphs[2] = dom.createMorphAt(fragment,2,2,contextualElement);
        morphs[3] = dom.createMorphAt(fragment,3,3,contextualElement);
        morphs[4] = dom.createMorphAt(fragment,4,4,contextualElement);
        morphs[5] = dom.createMorphAt(fragment,5,5,contextualElement);
        morphs[6] = dom.createMorphAt(fragment,6,6,contextualElement);
        morphs[7] = dom.createMorphAt(fragment,7,7,contextualElement);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["inline","t",["createyourevent"],[],["loc",[null,[1,278],[1,301]]]],
        ["inline","render",["welcome/features/registration"],[],["loc",[null,[1,311],[1,353]]]],
        ["inline","render",["welcome/features/reporting"],[],["loc",[null,[1,353],[1,392]]]],
        ["inline","render",["welcome/features/discounts-and-tiers"],[],["loc",[null,[1,392],[1,441]]]],
        ["inline","render",["welcome/features/at-the-door"],[],["loc",[null,[1,441],[1,482]]]],
        ["inline","render",["welcome/features/housing"],[],["loc",[null,[1,482],[1,519]]]],
        ["inline","render",["welcome/features/inventory"],[],["loc",[null,[1,519],[1,558]]]],
        ["inline","render",["welcome/get-started"],[],["loc",[null,[1,558],[1,590]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/at-the-door', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1340
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0, 0]);
        var element1 = dom.childAt(element0, [2]);
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(element1, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [1, 0]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element1, [2, 0]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(element1, [3, 0]),0,0);
        morphs[4] = dom.createMorphAt(dom.childAt(element0, [4]),1,1);
        return morphs;
      },
      statements: [
        ["inline","fa-icon",["hand-o-up"],[],["loc",[null,[1,310],[1,333]]]],
        ["inline","fa-icon",["ticket"],[],["loc",[null,[1,585],[1,605]]]],
        ["inline","fa-icon",["plus-square"],[],["loc",[null,[1,846],[1,871]]]],
        ["inline","fa-icon",["check-square"],[],["loc",[null,[1,1085],[1,1111]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1287],[1,1302]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/discounts-and-tiers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 591
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/housing', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 568
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/inventory', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 479
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/registration', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1093
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0, 1]);
        var morphs = new Array(4);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element0, [2, 0]),0,0);
        morphs[3] = dom.createMorphAt(dom.childAt(element0, [3, 0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","fa-icon",["adjust"],[],["loc",[null,[1,205],[1,225]]]],
        ["inline","fa-icon",["edit"],[],["loc",[null,[1,454],[1,472]]]],
        ["inline","fa-icon",["th-large"],[],["loc",[null,[1,641],[1,663]]]],
        ["inline","fa-icon",["bookmark"],[],["loc",[null,[1,870],[1,892]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/features/reporting', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 985
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0, 0, 2]);
        var morphs = new Array(3);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element0, [2, 0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","fa-icon",["line-chart"],[],["loc",[null,[1,251],[1,275]]]],
        ["inline","fa-icon",["users"],[],["loc",[null,[1,494],[1,513]]]],
        ["inline","fa-icon",["bar-chart"],[],["loc",[null,[1,744],[1,767]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/get-started', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 103
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 1]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["createyourevent"],[],["loc",[null,[1,70],[1,93]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 276
            },
            "end": {
              "line": 1,
              "column": 355
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["buttons.eventcalendar"],[],["loc",[null,[1,326],[1,355]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 621
            },
            "end": {
              "line": 1,
              "column": 695
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["buttons.scenesbycity"],[],["loc",[null,[1,667],[1,695]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 727
            },
            "end": {
              "line": 1,
              "column": 1041
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
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
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var element0 = dom.childAt(fragment, [0, 0]);
          var morphs = new Array(2);
          morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 0]),0,0);
          morphs[1] = dom.createMorphAt(dom.childAt(element0, [1, 0]),0,0);
          return morphs;
        },
        statements: [
          ["inline","t",["buttons.login"],[],["loc",[null,[1,886],[1,907]]]],
          ["inline","t",["buttons.signup"],[],["loc",[null,[1,991],[1,1013]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child3 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1285
            },
            "end": {
              "line": 1,
              "column": 1332
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["features"],[],["loc",[null,[1,1316],[1,1332]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child4 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1434
            },
            "end": {
              "line": 1,
              "column": 1480
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["pricing"],[],["loc",[null,[1,1464],[1,1480]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    var child5 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 1581
            },
            "end": {
              "line": 1,
              "column": 1618
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createComment("");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
          var morphs = new Array(1);
          morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
          dom.insertBoundary(fragment, 0);
          dom.insertBoundary(fragment, null);
          return morphs;
        },
        statements: [
          ["inline","t",["faq"],[],["loc",[null,[1,1607],[1,1618]]]]
        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1679
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
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
        var morphs = new Array(17);
        morphs[0] = dom.createMorphAt(dom.childAt(element1, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [1]),0,0);
        morphs[2] = dom.createMorphAt(dom.childAt(element3, [0]),0,0);
        morphs[3] = dom.createMorphAt(element3,2,2);
        morphs[4] = dom.createMorphAt(dom.childAt(element4, [0]),0,0);
        morphs[5] = dom.createMorphAt(dom.childAt(element4, [2]),0,0);
        morphs[6] = dom.createMorphAt(dom.childAt(element5, [0]),0,0);
        morphs[7] = dom.createMorphAt(element5,2,2);
        morphs[8] = dom.createMorphAt(fragment,4,4,contextualElement);
        morphs[9] = dom.createMorphAt(dom.childAt(element6, [0]),0,0);
        morphs[10] = dom.createMorphAt(dom.childAt(element6, [1, 0]),0,0);
        morphs[11] = dom.createMorphAt(dom.childAt(element8, [0]),0,0);
        morphs[12] = dom.createMorphAt(dom.childAt(element8, [1]),0,0);
        morphs[13] = dom.createMorphAt(dom.childAt(element9, [0]),0,0);
        morphs[14] = dom.createMorphAt(dom.childAt(element9, [1]),0,0);
        morphs[15] = dom.createMorphAt(dom.childAt(element10, [0]),0,0);
        morphs[16] = dom.createMorphAt(dom.childAt(element10, [1]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["appname"],[],["loc",[null,[1,85],[1,100]]]],
        ["inline","t",["subheader"],[],["loc",[null,[1,139],[1,156]]]],
        ["inline","t",["lookingforevent"],[],["loc",[null,[1,244],[1,267]]]],
        ["block","link-to",["upcoming-events"],["classNames","button"],0,null,["loc",[null,[1,276],[1,367]]]],
        ["inline","t",["hostinganevent"],[],["loc",[null,[1,419],[1,441]]]],
        ["inline","t",["buttons.createyourevent"],[],["loc",[null,[1,502],[1,533]]]],
        ["inline","t",["lookingforscene"],[],["loc",[null,[1,589],[1,612]]]],
        ["block","link-to",["communities"],["classNames","button"],1,null,["loc",[null,[1,621],[1,707]]]],
        ["block","unless",[["get","session.isAuthenticated",["loc",[null,[1,737],[1,760]]]]],[],2,null,["loc",[null,[1,727],[1,1052]]]],
        ["inline","t",["whatisheader"],[],["loc",[null,[1,1127],[1,1147]]]],
        ["inline","t",["whatis"],[],["loc",[null,[1,1175],[1,1189]]]],
        ["block","link-to",["welcome.features"],[],3,null,["loc",[null,[1,1285],[1,1344]]]],
        ["inline","t",["featuresinfo"],[],["loc",[null,[1,1355],[1,1375]]]],
        ["block","link-to",["welcome.pricing"],[],4,null,["loc",[null,[1,1434],[1,1492]]]],
        ["inline","t",["pricinginfo"],[],["loc",[null,[1,1503],[1,1522]]]],
        ["block","link-to",["welcome.faq"],[],5,null,["loc",[null,[1,1581],[1,1630]]]],
        ["inline","t",["faqinfo"],[],["loc",[null,[1,1641],[1,1656]]]]
      ],
      locals: [],
      templates: [child0, child1, child2, child3, child4, child5]
    };
  }()));

});
define('aeonvera/templates/welcome/opensource', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1715
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(fragment, [1]);
        var element2 = dom.childAt(element1, [0]);
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1]),1,1);
        morphs[2] = dom.createMorphAt(element2,1,1);
        morphs[3] = dom.createMorphAt(element2,3,3);
        morphs[4] = dom.createMorphAt(dom.childAt(element1, [22]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["opensource"],[],["loc",[null,[1,77],[1,95]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,139],[1,155]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,254],[1,270]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,433],[1,448]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1516],[1,1531]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/pricing', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 400
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 2]),0,0);
        morphs[1] = dom.createMorphAt(fragment,1,1,contextualElement);
        morphs[2] = dom.createMorphAt(fragment,2,2,contextualElement);
        morphs[3] = dom.createMorphAt(fragment,3,3,contextualElement);
        morphs[4] = dom.createMorphAt(fragment,4,4,contextualElement);
        return morphs;
      },
      statements: [
        ["inline","t",["createyourevent"],[],["loc",[null,[1,223],[1,246]]]],
        ["inline","render",["welcome/pricing/free-or-not"],[],["loc",[null,[1,256],[1,296]]]],
        ["content","pricing-preview",["loc",[null,[1,296],[1,315]]]],
        ["inline","render",["welcome/pricing/pricing-features"],[],["loc",[null,[1,315],[1,360]]]],
        ["inline","render",["welcome/get-started"],[],["loc",[null,[1,360],[1,392]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/pricing/free-or-not', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 784
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0, 0, 0]);
        var morphs = new Array(2);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0, 1, 0]),1,1);
        morphs[1] = dom.createMorphAt(dom.childAt(element0, [1, 1]),1,1);
        return morphs;
      },
      statements: [
        ["inline","t",["appname"],[],["loc",[null,[1,337],[1,353]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,714],[1,730]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/pricing/pricing-features', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 1218
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/privacy', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 9681
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [2]);
        var element1 = dom.childAt(element0, [0, 1]);
        var element2 = dom.childAt(element1, [1, 1]);
        var element3 = dom.childAt(element2, [3, 0]);
        var element4 = dom.childAt(element0, [3]);
        var element5 = dom.childAt(element4, [1, 0, 0]);
        var element6 = dom.childAt(element0, [4, 1, 0, 0]);
        var element7 = dom.childAt(element0, [7, 1, 0, 0]);
        var morphs = new Array(14);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [0, 0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0, 0]),1,1);
        morphs[2] = dom.createMorphAt(dom.childAt(element2, [1, 0]),1,1);
        morphs[3] = dom.createMorphAt(element3,1,1);
        morphs[4] = dom.createMorphAt(element3,3,3);
        morphs[5] = dom.createMorphAt(dom.childAt(element4, [0]),1,1);
        morphs[6] = dom.createMorphAt(element5,1,1);
        morphs[7] = dom.createMorphAt(element5,3,3);
        morphs[8] = dom.createMorphAt(element5,5,5);
        morphs[9] = dom.createMorphAt(element6,1,1);
        morphs[10] = dom.createMorphAt(element6,3,3);
        morphs[11] = dom.createMorphAt(element7,1,1);
        morphs[12] = dom.createMorphAt(element7,3,3);
        morphs[13] = dom.createMorphAt(dom.childAt(fragment, [6, 3]),1,1);
        return morphs;
      },
      statements: [
        ["inline","t",["appname"],[],["loc",[null,[1,77],[1,92]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,710],[1,725]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1405],[1,1420]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,1962],[1,1977]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,2073],[1,2088]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5073],[1,5088]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5133],[1,5148]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5168],[1,5183]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5297],[1,5312]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5573],[1,5588]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,5599],[1,5614]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,9027],[1,9042]]]],
        ["content","mali-support-link",["loc",[null,[1,9072],[1,9093]]]],
        ["inline","t",["appname"],[],["loc",[null,[1,9550],[1,9565]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/tos', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 236
            },
            "end": {
              "line": 1,
              "column": 284
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("recent updates");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child1 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 331
            },
            "end": {
              "line": 1,
              "column": 386
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Non-Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    var child2 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 411
            },
            "end": {
              "line": 1,
              "column": 458
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 573
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var element0 = dom.childAt(fragment, [0]);
        var element1 = dom.childAt(element0, [2, 0]);
        var element2 = dom.childAt(element1, [1, 0]);
        var morphs = new Array(5);
        morphs[0] = dom.createMorphAt(dom.childAt(element0, [0]),0,0);
        morphs[1] = dom.createMorphAt(dom.childAt(element1, [0, 1, 0]),0,0);
        morphs[2] = dom.createMorphAt(element2,0,0);
        morphs[3] = dom.createMorphAt(element2,2,2);
        morphs[4] = dom.createMorphAt(dom.childAt(fragment, [1, 0]),0,0);
        return morphs;
      },
      statements: [
        ["inline","t",["appname"],[],["loc",[null,[1,76],[1,91]]]],
        ["block","link-to",["welcome.tos.updates"],[],0,null,["loc",[null,[1,236],[1,296]]]],
        ["block","link-to",["welcome.tos.non-organizers"],[],1,null,["loc",[null,[1,331],[1,398]]]],
        ["block","link-to",["welcome.tos.organizers"],[],2,null,["loc",[null,[1,411],[1,470]]]],
        ["content","outlet",["loc",[null,[1,551],[1,561]]]]
      ],
      locals: [],
      templates: [child0, child1, child2]
    };
  }()));

});
define('aeonvera/templates/welcome/tos/index', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 35
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
        var el0 = dom.createDocumentFragment();
        var el1 = dom.createComment("");
        dom.appendChild(el0, el1);
        return el0;
      },
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(fragment,0,0,contextualElement);
        dom.insertBoundary(fragment, 0);
        dom.insertBoundary(fragment, null);
        return morphs;
      },
      statements: [
        ["inline","render",["welcome.tos.organizers"],[],["loc",[null,[1,0],[1,35]]]]
      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/tos/non-organizers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    var child0 = (function() {
      return {
        meta: {
          "revision": "Ember@1.13.7",
          "loc": {
            "source": null,
            "start": {
              "line": 1,
              "column": 361
            },
            "end": {
              "line": 1,
              "column": 408
            }
          }
        },
        arity: 0,
        cachedFragment: null,
        hasRendered: false,
        buildFragment: function buildFragment(dom) {
          var el0 = dom.createDocumentFragment();
          var el1 = dom.createTextNode("Organizers");
          dom.appendChild(el0, el1);
          return el0;
        },
        buildRenderNodes: function buildRenderNodes() { return []; },
        statements: [

        ],
        locals: [],
        templates: []
      };
    }());
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 475
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes(dom, fragment, contextualElement) {
        var morphs = new Array(1);
        morphs[0] = dom.createMorphAt(dom.childAt(fragment, [3]),1,1);
        return morphs;
      },
      statements: [
        ["block","link-to",["welcome.tos.organizers"],[],0,null,["loc",[null,[1,361],[1,420]]]]
      ],
      locals: [],
      templates: [child0]
    };
  }()));

});
define('aeonvera/templates/welcome/tos/organizers', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 2670
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
    };
  }()));

});
define('aeonvera/templates/welcome/tos/updates', ['exports'], function (exports) {

  'use strict';

  exports['default'] = Ember.HTMLBars.template((function() {
    return {
      meta: {
        "revision": "Ember@1.13.7",
        "loc": {
          "source": null,
          "start": {
            "line": 1,
            "column": 0
          },
          "end": {
            "line": 1,
            "column": 161
          }
        }
      },
      arity: 0,
      cachedFragment: null,
      hasRendered: false,
      buildFragment: function buildFragment(dom) {
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
      buildRenderNodes: function buildRenderNodes() { return []; },
      statements: [

      ],
      locals: [],
      templates: []
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
define('aeonvera/tests/components/attendance-list.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/attendance-list.js should pass jshint', function() { 
    ok(true, 'components/attendance-list.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/error-field-wrapper.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/error-field-wrapper.js should pass jshint', function() { 
    ok(true, 'components/error-field-wrapper.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/event-at-the-door/checkin-attendance.jshint', function () {

  'use strict';

  module('JSHint - components/event-at-the-door');
  test('components/event-at-the-door/checkin-attendance.js should pass jshint', function() { 
    ok(true, 'components/event-at-the-door/checkin-attendance.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/event-at-the-door/checkin-list.jshint', function () {

  'use strict';

  module('JSHint - components/event-at-the-door');
  test('components/event-at-the-door/checkin-list.js should pass jshint', function() { 
    ok(true, 'components/event-at-the-door/checkin-list.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/fixed-top-nav.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/fixed-top-nav.js should pass jshint', function() { 
    ok(true, 'components/fixed-top-nav.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/foundation-modal.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/foundation-modal.js should pass jshint', function() { 
    ok(true, 'components/foundation-modal.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/handle-payment.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/handle-payment.js should pass jshint', function() { 
    ok(true, 'components/handle-payment.js should pass jshint.'); 
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
define('aeonvera/tests/components/links/submit-idea-link.jshint', function () {

  'use strict';

  module('JSHint - components/links');
  test('components/links/submit-idea-link.js should pass jshint', function() { 
    ok(true, 'components/links/submit-idea-link.js should pass jshint.'); 
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
define('aeonvera/tests/components/sidebar-container.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/sidebar-container.js should pass jshint', function() { 
    ok(true, 'components/sidebar-container.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/sidebar/dashboard-sidebar.jshint', function () {

  'use strict';

  module('JSHint - components/sidebar');
  test('components/sidebar/dashboard-sidebar.js should pass jshint', function() { 
    ok(true, 'components/sidebar/dashboard-sidebar.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/sidebar/event-at-the-door-sidebar.jshint', function () {

  'use strict';

  module('JSHint - components/sidebar');
  test('components/sidebar/event-at-the-door-sidebar.js should pass jshint', function() { 
    ok(true, 'components/sidebar/event-at-the-door-sidebar.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/sidebar/event-sidebar.jshint', function () {

  'use strict';

  module('JSHint - components/sidebar');
  test('components/sidebar/event-sidebar.js should pass jshint', function() { 
    ok(true, 'components/sidebar/event-sidebar.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/sign-up-modal.jshint', function () {

  'use strict';

  module('JSHint - components');
  test('components/sign-up-modal.js should pass jshint', function() { 
    ok(true, 'components/sign-up-modal.js should pass jshint.'); 
  });

});
define('aeonvera/tests/components/stripe/checkout-button.jshint', function () {

  'use strict';

  module('JSHint - components/stripe');
  test('components/stripe/checkout-button.js should pass jshint', function() { 
    ok(true, 'components/stripe/checkout-button.js should pass jshint.'); 
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
define('aeonvera/tests/controllers/dashboard.jshint', function () {

  'use strict';

  module('JSHint - controllers');
  test('controllers/dashboard.js should pass jshint', function() { 
    ok(true, 'controllers/dashboard.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/dashboard/hosted-events.jshint', function () {

  'use strict';

  module('JSHint - controllers/dashboard');
  test('controllers/dashboard/hosted-events.js should pass jshint', function() { 
    ok(true, 'controllers/dashboard/hosted-events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/event-at-the-door/a-la-carte.jshint', function () {

  'use strict';

  module('JSHint - controllers/event-at-the-door');
  test('controllers/event-at-the-door/a-la-carte.js should pass jshint', function() { 
    ok(true, 'controllers/event-at-the-door/a-la-carte.js should pass jshint.'); 
  });

});
define('aeonvera/tests/controllers/events/index.jshint', function () {

  'use strict';

  module('JSHint - controllers/events');
  test('controllers/events/index.js should pass jshint', function() { 
    ok(true, 'controllers/events/index.js should pass jshint.'); 
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
define('aeonvera/tests/helpers/ember-i18n/test-helpers', ['ember'], function (Ember) {

  'use strict';

  Ember['default'].Test.registerHelper('t', function (app, key, interpolations) {
    var i18n = app.__container__.lookup('service:i18n');
    return i18n.t(key, interpolations);
  });

  // example usage: expectTranslation('.header', 'welcome_message');
  Ember['default'].Test.registerHelper('expectTranslation', function (app, element, key, interpolations) {
    var text = app.testHelpers.t(key, interpolations);

    assertTranslation(element, key, text);
  });

  var assertTranslation = (function () {
    if (typeof QUnit !== 'undefined' && typeof ok === 'function') {
      return function (element, key, text) {
        ok(find(element + ':contains(' + text + ')').length, 'Found translation key ' + key + ' in ' + element);
      };
    } else if (typeof expect === 'function') {
      return function (element, key, text) {
        var found = !!find(element + ':contains(' + text + ')').length;
        expect(found).to.equal(true);
      };
    } else {
      return function () {
        throw new Error('ember-i18n could not find a compatible test framework');
      };
    }
  })();

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
define('aeonvera/tests/helpers/to-usd.jshint', function () {

  'use strict';

  module('JSHint - helpers');
  test('helpers/to-usd.js should pass jshint', function() { 
    ok(true, 'helpers/to-usd.js should pass jshint.'); 
  });

});
define('aeonvera/tests/initializers/current-user.jshint', function () {

  'use strict';

  module('JSHint - initializers');
  test('initializers/current-user.js should pass jshint', function() { 
    ok(true, 'initializers/current-user.js should pass jshint.'); 
  });

});
define('aeonvera/tests/initializers/error-handler.jshint', function () {

  'use strict';

  module('JSHint - initializers');
  test('initializers/error-handler.js should pass jshint', function() { 
    ok(true, 'initializers/error-handler.js should pass jshint.'); 
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
define('aeonvera/tests/integration/components/dashboard/attended-events-test', ['ember-qunit', 'htmlbars-inline-precompile'], function (ember_qunit, hbs) {

  'use strict';

  function _taggedTemplateLiteral(strings, raw) { return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

  ember_qunit.moduleForComponent('dashboard/attended-events', 'Integration | Component | dashboard/attended events', {
    integration: true
  });

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.render(hbs['default'](_taggedTemplateLiteral(['{{dashboard/attended-events}}'], ['{{dashboard/attended-events}}'])));

    assert.equal(this.$().text().trim(), '');

    // Template block usage:
    this.render(hbs['default'](_taggedTemplateLiteral(['\n    {{#dashboard/attended-events}}\n      template block text\n    {{/dashboard/attended-events}}\n  '], ['\n    {{#dashboard/attended-events}}\n      template block text\n    {{/dashboard/attended-events}}\n  '])));

    assert.equal(this.$().text().trim(), 'template block text');
  });

});
define('aeonvera/tests/integration/components/dashboard/attended-events-test.jshint', function () {

  'use strict';

  module('JSHint - integration/components/dashboard');
  test('integration/components/dashboard/attended-events-test.js should pass jshint', function() { 
    ok(true, 'integration/components/dashboard/attended-events-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/integration/components/dashboard/hosted-events-test', ['ember-qunit', 'htmlbars-inline-precompile'], function (ember_qunit, hbs) {

  'use strict';

  function _taggedTemplateLiteral(strings, raw) { return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

  ember_qunit.moduleForComponent('dashboard/hosted-events', 'Integration | Component | dashboard/hosted events', {
    integration: true
  });

  ember_qunit.test('it renders', function (assert) {
    assert.expect(2);

    // Set any properties with this.set('myProperty', 'value');
    // Handle any actions with this.on('myAction', function(val) { ... });

    this.render(hbs['default'](_taggedTemplateLiteral(['{{dashboard/hosted-events}}'], ['{{dashboard/hosted-events}}'])));

    assert.equal(this.$().text().trim(), '');

    // Template block usage:
    this.render(hbs['default'](_taggedTemplateLiteral(['\n    {{#dashboard/hosted-events}}\n      template block text\n    {{/dashboard/hosted-events}}\n  '], ['\n    {{#dashboard/hosted-events}}\n      template block text\n    {{/dashboard/hosted-events}}\n  '])));

    assert.equal(this.$().text().trim(), 'template block text');
  });

});
define('aeonvera/tests/integration/components/dashboard/hosted-events-test.jshint', function () {

  'use strict';

  module('JSHint - integration/components/dashboard');
  test('integration/components/dashboard/hosted-events-test.js should pass jshint', function() { 
    ok(true, 'integration/components/dashboard/hosted-events-test.js should pass jshint.'); 
  });

});
define('aeonvera/tests/locales/en/translations.jshint', function () {

  'use strict';

  module('JSHint - locales/en');
  test('locales/en/translations.js should pass jshint', function() { 
    ok(true, 'locales/en/translations.js should pass jshint.'); 
  });

});
define('aeonvera/tests/mixins/authenticated-ui.jshint', function () {

  'use strict';

  module('JSHint - mixins');
  test('mixins/authenticated-ui.js should pass jshint', function() { 
    ok(true, 'mixins/authenticated-ui.js should pass jshint.'); 
  });

});
define('aeonvera/tests/mixins/models/buyable.jshint', function () {

  'use strict';

  module('JSHint - mixins/models');
  test('mixins/models/buyable.js should pass jshint', function() { 
    ok(true, 'mixins/models/buyable.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/attendance.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/attendance.js should pass jshint', function() { 
    ok(true, 'models/attendance.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/community.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/community.js should pass jshint', function() { 
    ok(true, 'models/community.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/competition-response.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/competition-response.js should pass jshint', function() { 
    ok(true, 'models/competition-response.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/competition.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/competition.js should pass jshint', function() { 
    ok(true, 'models/competition.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/event-attendance.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/event-attendance.js should pass jshint', function() { 
    ok(true, 'models/event-attendance.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/event-summary.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/event-summary.js should pass jshint', function() { 
    ok(true, 'models/event-summary.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/event.js should pass jshint', function() { 
    ok(true, 'models/event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/host.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/host.js should pass jshint', function() { 
    ok(true, 'models/host.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/hosted-event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/hosted-event.js should pass jshint', function() { 
    ok(true, 'models/hosted-event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/integration.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/integration.js should pass jshint', function() { 
    ok(true, 'models/integration.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/level.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/level.js should pass jshint', function() { 
    ok(true, 'models/level.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/line-item.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/line-item.js should pass jshint', function() { 
    ok(true, 'models/line-item.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/order-line-item.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/order-line-item.js should pass jshint', function() { 
    ok(true, 'models/order-line-item.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/order.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/order.js should pass jshint', function() { 
    ok(true, 'models/order.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/package.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/package.js should pass jshint', function() { 
    ok(true, 'models/package.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/recent-registration.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/recent-registration.js should pass jshint', function() { 
    ok(true, 'models/recent-registration.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/registered-event.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/registered-event.js should pass jshint', function() { 
    ok(true, 'models/registered-event.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/shirt.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/shirt.js should pass jshint', function() { 
    ok(true, 'models/shirt.js should pass jshint.'); 
  });

});
define('aeonvera/tests/models/unpaid-order.jshint', function () {

  'use strict';

  module('JSHint - models');
  test('models/unpaid-order.js should pass jshint', function() { 
    ok(true, 'models/unpaid-order.js should pass jshint.'); 
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
define('aeonvera/tests/routes/dashboard/hosted-events.jshint', function () {

  'use strict';

  module('JSHint - routes/dashboard');
  test('routes/dashboard/hosted-events.js should pass jshint', function() { 
    ok(true, 'routes/dashboard/hosted-events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/dashboard/orders.jshint', function () {

  'use strict';

  module('JSHint - routes/dashboard');
  test('routes/dashboard/orders.js should pass jshint', function() { 
    ok(true, 'routes/dashboard/orders.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/dashboard/registered-events.jshint', function () {

  'use strict';

  module('JSHint - routes/dashboard');
  test('routes/dashboard/registered-events.js should pass jshint', function() { 
    ok(true, 'routes/dashboard/registered-events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/event-at-the-door.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/event-at-the-door.js should pass jshint', function() { 
    ok(true, 'routes/event-at-the-door.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/event-at-the-door/a-la-carte.jshint', function () {

  'use strict';

  module('JSHint - routes/event-at-the-door');
  test('routes/event-at-the-door/a-la-carte.js should pass jshint', function() { 
    ok(true, 'routes/event-at-the-door/a-la-carte.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/event-at-the-door/checkin.jshint', function () {

  'use strict';

  module('JSHint - routes/event-at-the-door');
  test('routes/event-at-the-door/checkin.js should pass jshint', function() { 
    ok(true, 'routes/event-at-the-door/checkin.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/event-at-the-door/competition-list.jshint', function () {

  'use strict';

  module('JSHint - routes/event-at-the-door');
  test('routes/event-at-the-door/competition-list.js should pass jshint', function() { 
    ok(true, 'routes/event-at-the-door/competition-list.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/event-at-the-door/index.jshint', function () {

  'use strict';

  module('JSHint - routes/event-at-the-door');
  test('routes/event-at-the-door/index.js should pass jshint', function() { 
    ok(true, 'routes/event-at-the-door/index.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/events.jshint', function () {

  'use strict';

  module('JSHint - routes');
  test('routes/events.js should pass jshint', function() { 
    ok(true, 'routes/events.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/events/index.jshint', function () {

  'use strict';

  module('JSHint - routes/events');
  test('routes/events/index.js should pass jshint', function() { 
    ok(true, 'routes/events/index.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/events/show.jshint', function () {

  'use strict';

  module('JSHint - routes/events');
  test('routes/events/show.js should pass jshint', function() { 
    ok(true, 'routes/events/show.js should pass jshint.'); 
  });

});
define('aeonvera/tests/routes/events/show/index.jshint', function () {

  'use strict';

  module('JSHint - routes/events/show');
  test('routes/events/show/index.js should pass jshint', function() { 
    ok(true, 'routes/events/show/index.js should pass jshint.'); 
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
define('aeonvera/tests/routes/user/edit.jshint', function () {

  'use strict';

  module('JSHint - routes/user');
  test('routes/user/edit.js should pass jshint', function() { 
    ok(true, 'routes/user/edit.js should pass jshint.'); 
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
define('aeonvera/tests/unit/routes/hosted-events-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:hosted-events', 'Unit | Route | hosted events', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/hosted-events-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/hosted-events-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/hosted-events-test.js should pass jshint.'); 
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
define('aeonvera/tests/unit/routes/orders-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:orders', 'Unit | Route | orders', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/orders-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/orders-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/orders-test.js should pass jshint.'); 
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
define('aeonvera/tests/unit/routes/registered-events-test', ['ember-qunit'], function (ember_qunit) {

  'use strict';

  ember_qunit.moduleFor('route:registered-events', 'Unit | Route | registered events', {});

  ember_qunit.test('it exists', function (assert) {
    var route = this.subject();
    assert.ok(route);
  });

  // Specify the other units that are required for this test.
  // needs: ['controller:foo']

});
define('aeonvera/tests/unit/routes/registered-events-test.jshint', function () {

  'use strict';

  module('JSHint - unit/routes');
  test('unit/routes/registered-events-test.js should pass jshint', function() { 
    ok(true, 'unit/routes/registered-events-test.js should pass jshint.'); 
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
define('aeonvera/utils/i18n/compile-template', ['exports', 'ember-i18n/utils/i18n/compile-template'], function (exports, compile_template) {

	'use strict';



	exports['default'] = compile_template['default'];

});
define('aeonvera/utils/i18n/missing-message', ['exports', 'ember-i18n/utils/i18n/missing-message'], function (exports, missing_message) {

	'use strict';



	exports['default'] = missing_message['default'];

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
  require("aeonvera/app")["default"].create({"defaultLocale":"en","LOG_TRANSITIONS":true,"name":"aeonvera","version":"0.0.0.57cfbad3"});
}

/* jshint ignore:end */
//# sourceMappingURL=aeonvera.map