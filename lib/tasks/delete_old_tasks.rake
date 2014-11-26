namespace :blocitoff do
	task :delete_old_tasks => :environment do
		Todo.delete_old_tasks
	end
end