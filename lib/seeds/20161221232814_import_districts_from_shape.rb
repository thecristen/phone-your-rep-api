# frozen_string_literal: true
# class ImportDistrictsFromShape < ActiveRecord::Migration[5.0]
#   def up
#     from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326 #{Rails.root.join('lib', 'shapefiles', 'us_congress_districts_122116', 'cb_2015_us_cd114_500k.shp')} districts_ref`
#
#     District.transaction do
#       execute from_shp_sql
#
#       execute <<-SQL
#           insert into districts(code, state_code, full_code, geom)
#             select CD114FP, STATEFP, GEOID, geom from districts_ref
#       SQL
#
#       d# rop_table :districts_ref
#     end
#   end
#
#   def down
#     District.delete_all
#   end
# end
