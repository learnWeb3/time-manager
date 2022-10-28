defmodule JWTMissingTokenError do
  defexception message:
                 "Invalid or missing JWT token, you must be logged in to access this resource"
end

defmodule RoleMismatchError do
  defexception message:
                 "you do not have the rights to perform this action, please contact your administrator if you think you should"
end

defmodule NotFoundError do
  defexception message: "ressource not found"
end

defmodule UniqueConstraintError do
  defexception message: "ressource already exists"
end

defmodule ValidationError do
  defexception message: "invalid parameters: "
end
