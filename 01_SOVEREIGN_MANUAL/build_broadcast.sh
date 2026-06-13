#!/bin/bash

# 1. Compile the local RSS syndication tree
bash ./generate_rss.sh

# 2. Execute the Termux-to-IPFS direct network upload
bash ./pin_to_ipfs.sh

echo "Status: Dual-channel deployment sequence completed."
