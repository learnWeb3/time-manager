defmodule TimeManager.Plugs.RequireParams do
  alias TimeManager.Plugs.Auth
  alias TimeManager.Application

  def init(required_params), do: required_params

  def call(%Plug.Conn{} = conn, required_params) do
    try do
      errors = validate_map(conn.params, required_params)
      errors_string = Enum.join(errors, ", ")

      if Kernel.length(errors) > 0 do
        raise ValidationError,
          message: "Missing required parameters: " <> Enum.join(errors, ", ")
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

  def validate_map(params, required_params, errors \\ []) do
    errors =
      Enum.map(required_params, fn {k, v} ->
        if is_nil(Map.get(params, k, nil)) do
          "missing required #{k} parameter"
        else
          if is_map(params[k]) do
            errors ++ validate_map(params[k], required_params[k], errors)
          else
            nil
          end
        end
      end)

    List.flatten(errors) |> Enum.filter(fn error -> not is_nil(error) end)
  end
end
