#! /bin/sh

rm -rf ./priv/repo/migrations
rm -rf ./priv/test_repo
rm -rf ./priv/resource_snapshots
MIX_ENV=test mix ash.codegen --dev
MIX_ENV=test mix ash.reset
