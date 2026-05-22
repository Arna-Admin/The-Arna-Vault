#!/bin/bash

# 1. Execute the RSS Generation Engine using direct interpreter routing
bash ./generate_rss.sh

# 2. Stage the newly compiled distribution channels for tracking
git add feed.xml

echo "Status: System ready for broadcast push."
