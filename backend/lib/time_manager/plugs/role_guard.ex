defmodule TimeManager.Plugs.RoleGuard do
  alias TimeManager.Plugs.Auth
  alias TimeManager.Application

  def init(default), do: default

  def call(%Plug.Conn{} = conn, default) do
    try do
      token = Auth.extract_token(conn.req_headers)
      decoded = Application.verify_token(token)
      user_id = Map.get(decoded, "sub", nil)
      user = Application.get_user!(user_id)

      if user.role !== default do
        raise RoleMismatchError
      end

      conn
    rescue
      e ->
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:unauthorized)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  # def call(conn, default) do

  # end
end
