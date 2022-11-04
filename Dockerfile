FROM --platform=linux/amd64 node:alpine as time_manager_front

WORKDIR /front

COPY /front/package*.json .

RUN npm i -g @quasar/cli
RUN npm i --no-audit --loglevel verbose

COPY /front/ ./

RUN npm run build

FROM --platform=linux/amd64 elixir:alpine as time_manager_back

RUN apk add --no-cache build-base make
RUN apk add --update apk-cron && rm -rf /var/cache/apk/*

COPY /backend/ /backend/

COPY --from=time_manager_front /front/dist/spa /backend/priv/static/

# move to backend directory
WORKDIR /backend

# Initial setup
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

# Compile assets
RUN MIX_ENV=prod DATABASE_URL=${DATABASE_URL} SECRET_KEY_BASE=${SECRET_KEY_BASE} mix assets.deploy

# copy cron tasks
COPY /cron_tasks /cron_tasks/
COPY /entry.sh /entry.sh
RUN chmod 755 /cron_tasks/daily_clock_manager.sh /entry.sh
RUN touch /var/log/script.log
RUN /usr/bin/crontab /cron_tasks/crontab.txt

ENTRYPOINT ["/entry.sh"]