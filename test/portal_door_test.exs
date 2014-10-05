defmodule PortalDoorTest do
  use ExUnit.Case

  test "Create a Door by atom" do
    assert {:ok, door} = Portal.Door.start_link(:orange) 
    assert is_pid(door)
  end
end
