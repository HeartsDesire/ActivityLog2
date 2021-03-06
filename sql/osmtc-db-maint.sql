-- OSM Tile cache database maintenance queries
--
-- This file is part of ActivityLog2, an fitness activity tracker
-- Copyright (C) 2015 Alex Harsanyi (AlexHarsanyi@gmail.com)
--
-- This program is free software: you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option)
-- any later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-- more details.


-- avg_age is in days, old_tiles are tiles older than 60 days (will be
-- redownloaded), new tiles are tiles newer than 5 days.

select TC1.zoom_level as zoom_level,
       count(*) as tile_count,
       round(avg((strftime('%s', datetime('now', 'utc')) - TC1.timestamp) / (24 * 3600))) as avg_age,
       (select count(*)
          from TILE_CACHE TC2
         where TC2.zoom_level = TC1.zoom_level
           and TC2.timestamp < strftime('%s', datetime('now', '-60 days'))) as old_tiles,
       (select count(*)
          from TILE_CACHE TC3
         where TC3.zoom_level = TC1.zoom_level
           and TC3.timestamp > strftime('%s', datetime('now', '-5 days'))) as new_tiles
  from TILE_CACHE TC1
 group by TC1.zoom_level
 order by TC1.zoom_level;

-- Local Variables:
-- sql-product: sqlite
-- End:
