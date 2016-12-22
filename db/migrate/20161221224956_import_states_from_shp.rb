class ImportStatesFromShp < ActiveRecord::Migration[5.0]
  def up
    from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326 #{Rails.root.join('lib', 'shapefiles', 'cb_2015_us_state_500k.shp')} states_ref`

    State.transaction do
      execute from_shp_sql

      execute <<-SQL
          insert into states(state_code, name, abbr, geom)
            select STATEFP, NAME, STUSPS, geom from states_ref
      SQL

      drop_table :states_ref
    end

  end

  def down
    State.delete_all
  end
end
