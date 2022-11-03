#!/bin/sh
echo "daily clock manager scheduled task start"
cd /backend
MIX_ENV=prod mix run ./cron_task/CronTask.ex
echo "daily clock manager scheduled task end"