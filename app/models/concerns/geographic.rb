# frozen_string_literal: true
module Geographic
  module ClassMethods
    def containing_latlon(lat, lon)
      ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
      where("ST_Intersects(geom, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
    end

    def containing_point(point)
      ewkb = EWKB.generate(point.projection)
      where("ST_Intersects(geom, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
    end
  end

  module InstanceMethods
    def contains?(point)
      point.within?(geom)
    end
  end
end
