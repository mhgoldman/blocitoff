jQuery.fn.hideSubmit = function() {
	this.find('input[type=submit]').hide();
	return this;
}

$(document).on("page:change", function() {
	$('.complete-task-form').hideSubmit();
});

(function() {
	function setupCreateHandlers() {

		function createTodo(event) {
			event.preventDefault();

			var apiEmail = $("meta[name=api_email]").attr('content');
			var apiToken = $("meta[name=api_token]").attr('content');

			var list_id = window.location.pathname.split('/')[2];

			var descriptionField = $("#todo_description");
			var description = descriptionField.val();

			var jsonStr = JSON.stringify({ "todo": { "description": description } });

			function showSuccessNotification(data) {
	  		toastr.info("Your new TODO was saved");

				var tableRow = '<tr class="todo-list-row" id="todo_' + data.todo.id + '" data-todo-id="' + data.todo.id +'">'
					+ '<td>'
					+ data.todo.description
					+ '</td>'
					+ '<td>'
					+ data.todo.days_left
					+ '</td>'
					+ '<td>'					
					+ '<form accept-charset="UTF-8" action="/lists/' + list_id + '/todos/' + data.todo.id + '" class="complete-task-form" method="post">'
					+ '<div style="display:none"><input name="utf8" type="hidden" value="✓"><input name="_method" type="hidden" value="delete"></div>'
					+ '<input class="complete-task-chk" data-destroy-todo-checkbox="true" id="completed_todo_' + data.todo.id +'" name="completed" type="checkbox" value="1">'
					+ '<input class="complete-task-btn" name="commit" type="submit" value="complete" style="display: none;">'
					+ '</form>'
					+ '</td>'
					+ '</tr>';
				var todosTable = $("#todos_table");
				todosTable.append(tableRow);
				todosTable.show();

				var noTodosMsg = $("#no_todos_msg");
				noTodosMsg.hide();

				descriptionField.val("");	  		
			}

			function showErrorNotification(ex) {
	  		toastr.error("Error! " + jQuery.parseJSON(ex.responseText).errors);				
	  		$("#todos_table tbody tr:last-child").remove();
			}

			var extraOptions = { type: "POST", url: "/api/lists/" + list_id + "/todos", data: jsonStr, success: showSuccessNotification, error: showErrorNotification };
			var ajaxOptions = blocitoff.api.buildOptions(extraOptions);

			$.ajax(ajaxOptions);
		};

		$(document).on("click", "[data-create-todo-button]", createTodo);
	};

	$(document).on("page:change", setupCreateHandlers);

})();

(function() {
	function setupDeleteHandlers() {

		function deleteTodo(event) {
			event.preventDefault();

			var apiEmail = $("meta[name=api_email]").attr('content');
			var apiToken = $("meta[name=api_token]").attr('content');

			var todo_id = $(this).closest('tr').attr('data-todo-id');
			var row_element_id = '#' + $(this).closest('tr').attr('id');

			var list_id = window.location.pathname.split('/')[2];

			function showSuccessNotification(data) {
		  	toastr.info("Your TODO was deleted");
				
				$(row_element_id).fadeOut(400, function() {
					this.remove();

					if ($('#todos_table .todo-list-row').length === 0)
					{
						$('#no_todos_msg').show();
						$('#todos_table').hide();
					}				
				});
			}

			function showErrorNotification(ex) {
		  	toastr.error("Error! " + jQuery.parseJSON(ex.responseText).errors);
			}

			var extraOptions = {	type: "DELETE", url: "/api/lists/" + list_id + "/todos/" + todo_id, success: showSuccessNotification, error: showErrorNotification };
			var ajaxOptions = blocitoff.api.buildOptions(extraOptions);

			$.ajax(ajaxOptions);
		};

		$(document).on("click", "[data-destroy-todo-checkbox]", deleteTodo);
	};

	$(document).on("page:change", setupDeleteHandlers);

})();