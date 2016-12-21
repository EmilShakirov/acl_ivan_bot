defmodule Alice.Handlers.Standup do
  use Alice.Router
  use Timex

  alias Alice.Conn
  alias Alice.StateBackends

  command ~r/\breport\b/i, :get_daily_report
  command ~r/\bstandup\b/i, :standup
  route ~r/\bstandup\b/i, :standup

  def get_daily_report(conn = %Conn{slack: %{users: users}}) do
    conn
    |> get_state(timestamp(), %{})
    |> Map.to_list()
    |> Enum.map(
      fn({user, report}) ->
        name = users
                |> Map.get(user)
                |> Map.get(:profile)
                |> Map.get(:real_name_normalized, users[user].name)

        """
        *#{name}*
        #{String.replace(report, ~r/<|>/, "")}
        """
      end
    )
    |> Enum.join("\n")
    |> reply(conn)
  end

  def notify do
    """
    _Please stand up_
    """
    |> Slack.send_message(Application.get_env(:alice, :room))
  end

  def standup(conn = %Conn{message: %{user: user, text: report}}) do
    conn = put_state(conn, timestamp(), update_report(conn, report, user))

    conn
    |> report_thank
    |> reply(conn)
  end

  defp format_report(report) do
    report
    |> String.replace("standup\n", "")
    |> String.replace(~r/<|>/, "")
  end

  defp report_thank(conn) do
    "Thank you for your report, #{Conn.at_reply_user(conn)}"
  end

  defp timestamp do
    Timex.format!(Timex.today, "%y%m%d", :strftime)
  end

  defp update_report(conn, report, user_id) do
    get_state(conn, timestamp(), %{})
    |> Map.put(user_id, format_report(report))
  end
end
