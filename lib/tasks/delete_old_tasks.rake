namespace :blocitoff do
	task :delete_old_tasks => :environment do
		Todo.all.select {|t| t.expired?}.each {|t| t.delete}
	end
end