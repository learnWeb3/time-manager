defmodule TimeManager.Plugs.RoleGuard do
  alias TimeManager.Plugs.Auth
  alias TimeManager.Application

  def init(roles), do: roles

  def call(%Plug.Conn{} = conn, roles) do
    try do
      token = Auth.extract_token(conn.req_headers)
      decoded = Application.verify_token(token)
      user_id = Map.get(decoded, "sub", nil)
      user = Application.get_user!(user_id)

      IO.inspect(roles)
      IO.inspect(user.role)

      if not Enum.member?(roles, user.role) do
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
end
