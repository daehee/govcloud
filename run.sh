#!/usr/bin/env bash

mkdir -p data

# Get Amazon AWS IP ranges
wget -O data/aws.json https://ip-ranges.amazonaws.com/ip-ranges.json
cat data/aws.json | jq -r '.prefixes[] | select(.region=="us-gov-east-1" or .region=="us-gov-west-1") | .ip_prefix' | sort -u > ranges-aws.txt

# Get Microsoft Azure IP ranges
# Download link: https://www.microsoft.com/en-us/download/confirmation.aspx?id=57063
# Extract dynamic download URL: https://stackoverflow.com/a/53939113
AZURE_RANGES_URL=$(curl -Lfs 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=57063' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"' | grep "download.microsoft.com/download/" | grep -m 1 -Eo '(http|https)://[^"]+')
wget -O data/azure.json $AZURE_RANGES_URL
cat data/azure.json | jq -r '.values[] | .properties.addressPrefixes[]' | grep -oP '^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$' | sort -u > ranges-azure.txt
# for labels containing "DoD" only
cat data/azure.json | jq -r '.values[] | select(.name | test("dod"; "i")) | .properties.addressPrefixes[]' | grep -oP '^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$' | sort -u > ranges-azure-dod.txt
