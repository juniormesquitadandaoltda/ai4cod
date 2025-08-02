#!/bin/sh

set -e

# echo '<?xml version="1.0" encoding="UTF-8"?>' > public/sitemap.xml
# echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> public/sitemap.xml

# echo '  <url>\n    <loc>https://ai4cod.com</loc>\n  </url>' >> public/sitemap.xml

# JSON=$(curl -s https://ai4cod.com/data)
# echo $JSON | jq -r '.models[] | "  <url>\n    <loc>https://" + .subdomain + ".ai4cod.com</loc>\n  </url>"' >> public/sitemap.xml

# echo '</urlset>' >> public/sitemap.xml

NODE_ENV=development npm install $@
