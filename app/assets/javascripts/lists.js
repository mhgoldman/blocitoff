$(document).on("page:change", function() {
	$('.editable').editable({
		mode: 'inline',
		success: function(response, newValue) {
	    toastr.info('Your list was updated');
		},
		error: function(response, newValue) {
			toastr.error('Error! ' + jQuery.parseJSON(response.responseText).errors);
    }
	});
});

(function() {
	function setupCreateHandlers() {

		function createList(event) {
			event.preventDefault();

			var apiEmail = $("meta[name=api_email]").attr('content');
			var apiToken = $("meta[name=api_token]").attr('content');

			var nameField = $("#list_name");
			var name = nameField.val();

			var permsField = $("#list_permissions");
			var perms = permsField.val();

			var jsonStr = JSON.stringify({ "list": { "name": name, "permissions": perms } });

			var ajaxOptions = {
				type: "POST", url: "/api/lists", dataType: "json", contentType: "application/json; charset=utf-8",
				headers: { "X-User-Email": apiEmail, "X-User-Token": apiToken },
				data: jsonStr
			};

			function showSuccessNotification(data) {
	  		toastr.info("Your new list was saved");

				var tableRow = '<tr class="list-list-row" id="list_' + data.list.id + '" data-list-id="' + data.list.id +'">'
					+ '<td><a href="/lists/' + data.list.id +'">' + data.list.name + '</a></td>'
					+ '<td>' + data.list.permissions +  '</td>'
					+ '<td>'
					+ '<form class="button_to" method="post" action="/lists/' + data.list.id + '"><div><input name="_method" type="hidden" value="delete"><button class="btn btn-danger" data-destroy-list-button="true" type="submit" id="destroy_list_' + data.list.id + '">'
					+ '<i class="glyphicon glyphicon-trash"></i>'
					+ '</button></div></form>'
					+ '</td>'
					+ '</tr>';
				var listsTable = $("#lists_table");
				listsTable.append(tableRow);
				listsTable.show();

				var noListsMsg = $("#no_lists_msg");
				noListsMsg.hide();

				permsField.val("private").attr("selected", "selected");
				nameField.val("");	  		
			}

			function showErrorNotification(ex) {
	  		toastr.error("Error! " + jQuery.parseJSON(ex.responseText).errors);				
	  		$("#lists_table tbody tr:last-child").remove();
			}

			ajaxOptions.success = showSuccessNotification;
			ajaxOptions.error = showErrorNotification;


			$.ajax(ajaxOptions);
		};

		$(document).on("click", "[data-create-list-button]", createList);
	};

	$(document).on("page:change", setupCreateHandlers);

})();

(function() {
	function setupDeleteHandlers() {

		function deleteList(event) {
			event.preventDefault();

			var apiEmail = $("meta[name=api_email]").attr('content');
			var apiToken = $("meta[name=api_token]").attr('content');

			list_id = $(this).closest('tr').attr('data-list-id');
			row_element_id = '#' + $(this).closest('tr').attr('id');

			var ajaxOptions = {
				type: "DELETE", url: "/api/lists/" + list_id, dataType: "json", contentType: "application/json; charset=utf-8",
				headers: { "X-User-Email": apiEmail, "X-User-Token": apiToken }
			};

			function showSuccessNotification(data) {
		  	toastr.info("Your list was deleted");
				
				$(row_element_id).fadeOut(400, function() {
					this.remove();

					if ($('#lists_table .list-list-row').length === 0)
					{
						$('#no_lists_msg').show();
						$('#lists_table').hide();
					}				
				});
			}

			function showErrorNotification(ex) {
		  	toastr.error("Error! " + jQuery.parseJSON(ex.responseText).errors);
			}

			ajaxOptions.success = showSuccessNotification;
			ajaxOptions.error = showErrorNotification;


			$.ajax(ajaxOptions);
		};

		$(document).on("click", "[data-destroy-list-button]", deleteList);
	};

	$(document).on("page:change", setupDeleteHandlers);

})();
