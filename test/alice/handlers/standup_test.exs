defmodule FakeSlack do
  def send_message(text, :channel, %{}) do
    send(self, {:msg, text})
  end
end


defmodule Alice.Handlers.StandupTest do
  @user_id "U123456"
  @report """
  *Projects:*


  *IVAN:*
  report



  *Results:*

  Team didn't send any reports yet



  *Risks:*

  Team didn't send any reports yet


  """

  use ExUnit.Case, async: true
  alias Alice.Handlers.Standup
  alias Alice.Conn
  import AclIvanBot.DateHelper

  def conn do
    %Alice.Conn{
      message: %{user: @user_id, text: "test", channel: :channel, captures: ["projects"]},
      slack: %{users: %{@user_id => %{name: "Ivan"}}},
      state: %{today => %{"projects" => %{@user_id => "report"}}}
    }
  end

  def guide do
    EEx.eval_file("templates/guide.eex")
  end

  test "guide/1" do
    Standup.guide(conn)

    assert_received {:msg, guide}
  end

  test "daily_report/1" do
    Standup.daily_report(conn)

    assert_received {:msg, @report}
  end
end
