#!/bin/sh
/usr/sbin/crond -f -l 8
MIX_ENV=prod mix ecto.migrate && MIX_ENV=prod && PORT=4000 MIX_ENV=prod mix phx.server