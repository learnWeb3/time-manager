#!/bin/sh
set -e
/usr/sbin/crond -f -l 8 &
MIX_ENV=prod mix ecto.migrate &
MIX_ENV=prod mix run ./priv/repo/seeds.exs &
MIX_ENV=prod PORT=4000 mix phx.server