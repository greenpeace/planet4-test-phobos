#!/bin/sh

# PLANET-4782
# List existing deprecated keys
echo "Usage of '_campaign_page_template' meta key..."
wp db query 'SELECT wp.*, wp2.meta_key as theme_key, wp2.meta_value as theme_value
    FROM wp_postmeta wp
    LEFT JOIN wp_postmeta wp2 ON (
      wp.post_id = wp2.post_id
      AND wp2.meta_key = "theme"
    )
    WHERE wp.meta_key="_campaign_page_template";'

# Convert deprecated keys to new keys if possible
echo "Replacing key with 'theme'"
wp db query 'UPDATE wp_postmeta
    SET meta_key = "theme"
    WHERE meta_key="_campaign_page_template"
      AND post_id NOT IN (
          SELECT * FROM(
            SELECT post_id
            FROM wp_postmeta wpp
            WHERE meta_key="theme"
          ) AS e
      );'

# Delete left-over duplicates
echo "Deleting leftovers"
wp db query 'DELETE FROM wp_postmeta WHERE meta_key="_campaign_page_template";'

echo "Done."
