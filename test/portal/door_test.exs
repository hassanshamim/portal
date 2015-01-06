defmodule PortalDoorTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, door} = Portal.Door.start_link(:orange)

    on_exit  fn ->
      case Process.whereis(:orange) do
        nil -> nil
        pid -> Process.exit(pid, :shutdown)
      end
    end

    {:ok, [door: door, color: :orange] }
  end

  test "Create a Door by atom" do
    {:ok, door} = Portal.Door.start_link(:purple)
    assert is_pid(door)
  end

  test "Door can be retrieved by pid or atom", %{door: door, color: color} do
    assert Portal.Door.get(door)
    assert Portal.Door.get(color)
  end

  test "Nonexistant Door cannot be retrieved" do
    assert catch_exit Portal.Door.get(:NonExistant)
  end

  test "Door starts with empty list", %{color: color} do
    assert [] == Portal.Door.get(color)
  end

  test "Door acts as stack", %{door: door, color: color} do
    for n <- [1, 2, 3, 4], do: Portal.Door.push(door, n)

    assert [4, 3, 2, 1] = Portal.Door.get(color)
  end

  test "Door can remove last added values", %{door: door} do
    for n <- [1, 2, 3, 4], do: Portal.Door.push(door, n)

    assert {:ok, 4} = Portal.Door.pop(door)
  end

  test "Can't pop an empty door", %{door: door} do
    assert :error = Portal.Door.pop(door)
  end
end
