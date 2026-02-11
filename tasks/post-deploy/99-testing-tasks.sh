#!/bin/bash

echo "Allow plain login for testing..."
wp option patch delete planet4_features enforce_sso || true

echo "Sync ElasticPress..."
wp elasticpress sync --setup --force --yes || true
