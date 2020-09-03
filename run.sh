#!/usr/bin/env bash

mkdir -p data

# Get Amazon AWS IP ranges
wget -O data/aws.json https://ip-ranges.amazonaws.com/ip-ranges.json
cat data/aws.json | jq -r '.prefixes[] | select(.region=="us-gov-east-1" or .region=="us-gov-west-1") | .ip_prefix' > ranges-aws.txt

# Get Microsoft Azure IP ranges
# Download link: https://www.microsoft.com/en-us/download/confirmation.aspx?id=57063
wget -O data/azure.json https://download.microsoft.com/download/6/4/D/64DB03BF-895B-4173-A8B1-BA4AD5D4DF22/ServiceTags_AzureGovernment_20200824.json
cat data/azure.json | jq -r '.values[] | .properties.addressPrefixes[]' > ranges-azure.txt
# for labels containing "DoD" only
cat data/azure.json | jq -r '.values[] | select(.name | test("dod"; "i")) | .properties.addressPrefixes[]' > ranges-azure-dod.txt
