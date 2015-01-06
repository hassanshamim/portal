defmodule PortalTest do
  use ExUnit.Case

  setup_all do
    {:ok, _} =  Portal.shoot(:orange)
    {:ok, _} =  Portal.shoot(:blue)
    :ok
  end

  setup do
    on_exit fn ->
      for portal <- [:orange, :blue] do
        case Process.whereis(portal) do
          nil -> nil
          pid -> Process.exit(pid, :shutdown)
        end
      end
    end
  end

  test "Portal can create Doors" do
    assert [] = Portal.Door.get(:orange)
  end

  test "Portal can create transfers" do
  #    {:ok, _} =  Portal.shoot(:orange)
  #    {:ok, _} =  Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])

    assert portal.__struct__ == Portal
    assert Portal.Door.get(:orange) == [4, 3, 2, 1]
    assert Portal.Door.get(:blue) == []
  end

  test "Portal can transfer data to the right" do
  #    {:ok, _} =  Portal.shoot(:orange)
  #    {:ok, _} =  Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1, 2, 3, 4])

    Portal.push_right portal

    assert Portal.Door.get(:orange) == [3, 2, 1]
    assert Portal.Door.get(:blue) == [4]
  end

end
