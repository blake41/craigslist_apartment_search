namespace :db do
  desc "run script to update apartments in db"
  task :populate => :environment do
    search = Search.new(2000,3000)
    search.run
    search.persist
  end
end