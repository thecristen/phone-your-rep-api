# frozen_string_literal: true
namespace :db do
  namespace :pyr do
    desc 'Drop schema and tables, rebuild and seed the database'
    task :setup do
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
    task setup_alert: [:setup] do
      `say -v Fiona "Bring me a cold one, I'm exhausted"`
    end
  end
end
