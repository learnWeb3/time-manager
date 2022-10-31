defmodule TimeManager.Plugs.AuthorizeParams do
  alias TimeManager.Plugs.Auth
  alias TimeManager.Application

  def init(authorized_params), do: authorized_params

  def call(%Plug.Conn{} = conn, authorized_params) do
    try do
      errors = validate_map(conn.params, authorized_params)
      errors_string = Enum.join(errors, ", ")

      if Kernel.length(errors) > 0 do
        raise ValidationError,
          message: "Unauthorized key parameters: " <> errors_string
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

  def validate_map(params, authorized_params, errors \\ []) do
    errors =
      Enum.map(params, fn {k, v} ->
        if is_nil(Map.get(authorized_params, k, nil)) do
          "unauthorized #{k} parameter"
        else
          if is_map(params[k]) do
            errors ++ validate_map(params[k], authorized_params[k], errors)
          else
            nil
          end
        end
      end)

    List.flatten(errors) |> Enum.filter(fn error -> not is_nil(error) end)
  end
end
