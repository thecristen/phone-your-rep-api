# frozen_string_literal: true
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Drop schema and tables and rebuild the database'
task :pyr_db_setup do
  if Rails.env.development?
    `rm db/schema.rb`
    `rails db:drop`
    `rails db:create`
  end
  `rails db:gis:setup`
  `rails db:migrate`
  `rails db:seed`
  `ruby lib/shapefiles.rb`
  `ruby lib/add_photos.rb`
  `ruby lib/add_v_cards.rb`
  `ruby lib/import_qr_codes.rb`
end
