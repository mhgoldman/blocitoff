jQuery.fn.submitOnCheck = function() {
	this.find('input[type=checkbox]').click(function() {
				$(this.form).submit();
	});

	this.find('input[type=submit]').hide();
}

$(function() {
	$('.complete-task-form').submitOnCheck();
});