jQuery.fn.submitOnCheck = function() {
	this.find('input[type=checkbox]').click(function() {
				$(this.form).submit();
	});

	this.find('input[type=submit]').hide();

	return this;
}

$(document).on("page:change", function() {
	$('.complete-task-form').submitOnCheck();
});