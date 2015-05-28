// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require aeonvera
//= require jquery
//= require jquery.turbolinks
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require foundation
//= require responsive-tables
//= require lib/extensions
//= require lib/jquery.extensions
//= require custom.modernizr
//= require select2/select2
//= require jquery-ui-timepicker-addon
//= require stripe/v2
//= require stripe/checkout
//= require recurring_select
//= require select2
//= require jquery-te-1.4.0.min
//= cocoon

$(function() {
	AeonVera.initWindowObservers();

	/*
		table filter
	*/
	// $( "form.table-filter input").unbind('paste keyup');
	$("form.table-filter input").bind("paste keyup", function(event) {
		var filterTarget = $(this).data("class");
		var table = $("table." + filterTarget);
		var filterText = $(this).val().toLowerCase();
		table.find("tbody").find("tr").filter(function() {
			$(this).show();
			return $(this).text().toLowerCase().indexOf(filterText) == -1;
		}).hide();
	});

	// $( "form.table-filter").unbind("submit")
	$("form.table-filter").submit(function() {
		return false;
	});

	$('button#collect-check-number').click(function(e) {
		var target = $(e.target);
		var checkNumberDialog = target.closest('li').find('.check-number-form');
		var form = checkNumberDialog.find('form');
		var submitForm = function() {
			form.submit();
			checkNumberDialog.dialog("close");
		}
		checkNumberDialog.dialog({
			autoOpen: false,
			modal: true,
			buttons: {
				"Mark as Paid by Check": submitForm
			}
		});
		checkNumberDialog.dialog("open");
	});

	if ($('.alert-box').length >= 0) {
		setTimeout(function() {
			$('.alert-box .close').click();
		}, 5000);
	}
});
$(function() {
	Foundation.global.namespace = '';
	$(document).foundation();
});
$(function() {
	$(document).foundation();
});


function setEditorOn(id) {
	$(id).jqte({
		b: true,
		i: true,
		u: true,
		ol: true,
		ul: true,
		sub: true,
		sub: true,
		outdent: true,
		indent: true,
		left: true,
		right: true,
		center: true,
		strike: true,
		link: true,
		remove: true,
		color: true,
		fsize: true,
		source: false,
		format: false
	});
}
