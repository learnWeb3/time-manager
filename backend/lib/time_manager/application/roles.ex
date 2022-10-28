# defmodule TimeManager.Application.Role do
#   @enforce_keys [:name, :id]
#   defstruct [:name, :id]
# end

# defmodule TimeManager.Application.RoleHelper do
#   def get_user_roles do
#     manager_role = %Role{name: "manager", id: 1}
#     admin_role = %Role{name: "admin", id: 2}
#     employee_role = %Role{name: "employee", id: 3}
#     roles = [admin_role, manager_role, employee_role]
#     roles
#   end

#   def find_role_by_id(role_id) do
#     available_roles = get_user_roles()
#     Enum.find(available_roles, fn role -> Map.get(role, "id", nil) == role_id end)
#   end

#   def find_role_by_name(role_name) do
#     available_roles = get_user_roles()
#     Enum.find(available_roles, fn role -> Map.get(role, "name", nil) == role_name end)
#   end
# end
