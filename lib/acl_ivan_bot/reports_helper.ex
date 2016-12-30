defmodule AclIvanBot.ReportsHelper do
  @moduledoc """
  Helper methods for report handling
  """

  @doc """
  Fetches `user` by its id
  Returns `user.profile.first_name` or `user.name` in case `user.profile.first_name` is not present

  ## Examples

    iex> AclIvanBot.ReportsHelper.fetch_name(%{"U32" => %{ profile: %{ first_name: 'Ivan' }}}, "U32")
    "IVAN"

    iex> AclIvanBot.ReportsHelper.fetch_name(%{"U33" => %{ name: 'Petr' }}, "U33")
    "PETR"

  """
  @spec fetch_name(map(), String.t) :: String.t
  def fetch_name(users, user_id) do
    users
    |> get_in([user_id, :profile, :first_name])
    |> to_string
    |> case do
        "" -> get_in(users, [user_id, :name])
        name -> name
      end
    |> to_string
    |> String.upcase
  end
end
