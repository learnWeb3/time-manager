# TimeManager (backend)

## API documentation

https://documenter.getpostman.com/view/13953520/2s8YCjDXs6

## Quick start

### On a local development machine

#### It is your first project installation

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Run the seed file for you to have an admin user with `MIX_ENV="dev" mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


#### It is not the first project installation

To start your Phoenix server:

  * Reset the database with `mix ecto.reset`
  * Run the seed file for you to have an admin user with `MIX_ENV="dev" mix run priv/repo/seeds.exs`
  * Check your migration status with `mix phx.routes`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Using docker

To start the application:

  * Check that your docker desktop is up and running
  * Open a terminal and place yourself under the root project directory
  * Build the project image using `docker compose build`
  * Run the project containers using `docker compose up -d`
  * Seed the databased if required eg: first start up using `docker exec -it <backend container id > /bin/sh` and then    using the seed script and the following command `MIX_ENV=prod mix run ./priv/repo/seeds.exs` this will seed the admin user

### Admin user credentials 

Credentials 

  * email: "admin@yopmail.com"
  * password: "foobar"

### Roles

  * admin" => 1
  * manager => 2
  * employee" => 3

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
