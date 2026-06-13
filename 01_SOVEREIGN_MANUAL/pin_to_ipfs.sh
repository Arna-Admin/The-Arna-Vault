#!/bin/bash

JWT_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiI4Y2RkZDljNC01MzE3LTRmY2YtOTE5OC1lYTYwZjVjOTFkOWYiLCJlbWFpbCI6ImFybmFhZG1pbkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJGUkExIn0seyJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MSwiaWQiOiJOWUMxIn1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiZWUyNWRkNTA4ODIzMzNiMjVlZjYiLCJzY29wZWRLZXlTZWNyZXQiOiI0ZTJhMzJmMmUwODUyMzkwNTg0Yzc4OWY0NGMzNTUwMzA3YWRmMGU2YzFlN2ExM2Y0OGQ5OTJiODJkOTdhZmYxIiwiZXhwIjoxODEwOTkxMjk2fQ.NJEU3yzSfzELGoSXYE2TBy7hf5qZ9X7s3qpP7WFjkWw"
STREAM_NAME="Sovereign_Technical_Manual_Stream"

echo "Status: Initializing automated IPFS pinning protocol..."

RESPONSE=$(curl -s -X POST "https://api.pinata.cloud/pinning/pinFileToIPFS" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -F "file=@feed.xml" \
  -F "pinataMetadata={\"name\": \"$STREAM_NAME\"}")

IPFS_HASH=$(echo "$RESPONSE" | jq -r '.IpfsHash // empty')

if [ -n "$IPFS_HASH" ] && [ "$IPFS_HASH" != "null" ]; then
  echo "=========================================================="
  echo "DECENTRALIZED BROADCAST ENGINE SUCCESSFUL"
  echo "IPFS Hash: $IPFS_HASH"
  echo "Gateway Link: https://gateway.pinata.cloud/ipfs/$IPFS_HASH"
  echo "=========================================================="
else
  echo "Error: Transmission failed."
  echo "Raw Node Response: $RESPONSE"
fi
