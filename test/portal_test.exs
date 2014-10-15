defmodule PortalTest do
  use ExUnit.Case

  #  setup do
  #    {:ok, _} =  Portal.shoot(:orange)
  #    {:ok, _} =  Portal.shoot(:blue)
  #
  #    on_exit fn ->
  #      for portal <- [:orange, :blue], Process.whereis(portal) do
  #        Process.exit(Process.whereis(portal), :shutdown)
  #      end
  #    end
  #  end

  test "Portal can create Doors" do
    #Process.exit(Process.whereis(:orange), :shutdown)
    {:ok, door} =  Portal.shoot(:new_door)
    assert [] = Portal.Door.get(:new_door)
  end

  test "Portal can create transfers" do
    {:ok, _} =  Portal.shoot(:orange)
    {:ok, _} =  Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])

    assert portal.__struct__ == Portal
    assert Portal.Door.get(:orange) == [4, 3, 2, 1]
    assert Portal.Door.get(:blue) == []
  end

  test "Portal can transfer data to the right" do
    {:ok, _} =  Portal.shoot(:orange)
    {:ok, _} =  Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])

    Portal.push_right portal
    Portal.Door.get(:orange) == [3, 2, 1]
    Portal.Door.get(:blue) == [4]
  end

end
