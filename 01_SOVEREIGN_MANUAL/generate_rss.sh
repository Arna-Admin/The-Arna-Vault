#!/bin/bash

# Configuration Parameters
DOMAIN="https://arna-admin.github.io/The-Arna-Vault"
OUTPUT="feed.xml"

# Initialize RSS XML Structure
cat << FEED_HEAD > $OUTPUT
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
  <title>Sovereign Technical Manual</title>
  <link>$DOMAIN</link>
  <description>Immutable data ledger regarding structural geography, mechanics, and systemic logic.</description>
  <language>en-us</language>
FEED_HEAD

# Loop through all available Markdown nodes, excluding standard index layouts
for file in *.md; do
  if [ "$file" != "index.md" ] && [ -f "$file" ]; then
    # Format URLs cleanly for standard web browsers
    URL_ENCODED=$(echo "$file" | sed 's/ /%20/g')
    TITLE=$(echo "$file" | sed 's/\.md//')
    
    cat << ITEM_BLOCK >> $OUTPUT
    <item>
      <title>$TITLE</title>
      <link>$DOMAIN/$URL_ENCODED</link>
      <guid>$DOMAIN/$URL_ENCODED</guid>
      <description>Technical Manual Module Node: $TITLE</description>
    </item>
ITEM_BLOCK
  fi
done

# Close XML tags
cat << FEED_FOOT >> $OUTPUT
</channel>
</rss>
FEED_FOOT

echo "Status: RSS generation complete -> $OUTPUT"
