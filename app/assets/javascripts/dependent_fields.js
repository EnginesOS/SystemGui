$(document).ready(function() {

	// $(function () {
// 		
	// });

	$(".dependent_field").each(function() {
		dependent_field = $(this);
		dependor_field_id = dependent_field.data("dependsonid");
		dependor_field_id_selector = "#" + dependor_field_id;
		dependor_field_regex = dependent_field.data("dependsonregex");
		dependent_field_class = ("dependent_field_for_" + dependor_field_id);
		dependent_field.addClass(dependent_field_class);
		dependor_field = $(dependor_field_id_selector);
		if (dependor_field.length > 0) {
			dependor_field.addClass("dependor_field");
			// dependor_field.prop('checked', true);
			dependor_field.attr('data-dependentfieldclass', dependent_field_class);
			dependor_field.attr('data-dependorfieldregex', dependor_field_regex);
			toggle_dependent_field(dependor_field);
			dependor_field.change( function() {
				toggle_dependent_field(dependor_field);
			});
		};

		function toggle_dependent_field(dependor_field) {
			dependent_field_class = dependor_field.attr('data-dependentfieldclass');
			dependor_field_regex = RegExp(dependor_field.attr('data-dependorfieldregex'));
			if (dependor_field.prop('type') == 'checkbox') {
				dependor_field_value = ( dependor_field.prop('checked').toString().match(dependor_field_regex) );
			};
			if (dependor_field_value) {
				$("." + dependent_field_class).show();
			} else {
				$("." + dependent_field_class).hide();
			};
		};

	});

});