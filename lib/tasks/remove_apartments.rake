namespace :db do
  desc "clear all apartments"
  task :clear => :environment do
    Apartment.all.each {|a| a.destroy}
  end
end