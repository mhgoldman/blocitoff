$(document).on("page:change", function() {
	$('.editable').editable({
		placement: 'bottom',
		ajaxOptions: {
			dataType: 'script'
		}
	});
});