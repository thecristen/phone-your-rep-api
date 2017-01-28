# frozen_string_literal: true
namespace :pyr do
  desc 'Drop schema and tables and rebuild the database'
  task :db_setup do
    if Rails.env.development?
      `rm db/schema.rb`
      `rails db:drop`
      `rails db:create`
    end
    `rails db:gis:setup`
    `rails db:migrate`
    `rails db:seed`
    `ruby lib/shapefiles.rb`
    `ruby lib/zctas.rb`
    `ruby lib/add_photos.rb`
    `ruby lib/add_v_cards.rb`
    `ruby lib/import_qr_codes.rb`
  end

  desc 'Rebuild the database with an alert at completion for MacOS'
  task db_setup_alert: [:db_setup] do
    `say -v Monica "Bring me a cold wun, ay'm exhausted"`
  end
end
