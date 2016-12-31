defmodule AclIvanBot.ReportsHelper do
  @moduledoc ~S"""
  Helper methods for report handling
  """

  @doc ~S"""
  Fetches `user` by its id

  Returns `user.profile.first_name` or `user.name` in case `user.profile.first_name` is not present
  Returns empty string if no user has been found

  ## Examples

    iex> AclIvanBot.ReportsHelper.fetch_name(%{"1" => %{ profile: %{ first_name: 'Ivan' }}}, "1")
    "IVAN"

    iex> AclIvanBot.ReportsHelper.fetch_name(%{"2" => %{ name: 'Petr' }}, "2")
    "PETR"

    iex> AclIvanBot.ReportsHelper.fetch_name(%{}, "3")
    ""

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
