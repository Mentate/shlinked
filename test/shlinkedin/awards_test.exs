defmodule Shlinkedin.AwardsTest do
  use Shlinkedin.DataCase

  alias Shlinkedin.Awards

  describe "award_types" do
    alias Shlinkedin.Awards.AwardType

    @valid_attrs %{bg: "some bg", bg_hover: "some bg_hover", color: "some color", description: "some description", emoji: "some emoji", fill: "some fill", image_format: "some image_format", name: "some name", svg_path: "some svg_path"}
    @update_attrs %{bg: "some updated bg", bg_hover: "some updated bg_hover", color: "some updated color", description: "some updated description", emoji: "some updated emoji", fill: "some updated fill", image_format: "some updated image_format", name: "some updated name", svg_path: "some updated svg_path"}
    @invalid_attrs %{bg: nil, bg_hover: nil, color: nil, description: nil, emoji: nil, fill: nil, image_format: nil, name: nil, svg_path: nil}

    def award_type_fixture(attrs \\ %{}) do
      {:ok, award_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Awards.create_award_type()

      award_type
    end

    test "list_award_types/0 returns all award_types" do
      award_type = award_type_fixture()
      assert Awards.list_award_types() == [award_type]
    end

    test "get_award_type!/1 returns the award_type with given id" do
      award_type = award_type_fixture()
      assert Awards.get_award_type!(award_type.id) == award_type
    end

    test "create_award_type/1 with valid data creates a award_type" do
      assert {:ok, %AwardType{} = award_type} = Awards.create_award_type(@valid_attrs)
      assert award_type.bg == "some bg"
      assert award_type.bg_hover == "some bg_hover"
      assert award_type.color == "some color"
      assert award_type.description == "some description"
      assert award_type.emoji == "some emoji"
      assert award_type.fill == "some fill"
      assert award_type.image_format == "some image_format"
      assert award_type.name == "some name"
      assert award_type.svg_path == "some svg_path"
    end

    test "create_award_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Awards.create_award_type(@invalid_attrs)
    end

    test "update_award_type/2 with valid data updates the award_type" do
      award_type = award_type_fixture()
      assert {:ok, %AwardType{} = award_type} = Awards.update_award_type(award_type, @update_attrs)
      assert award_type.bg == "some updated bg"
      assert award_type.bg_hover == "some updated bg_hover"
      assert award_type.color == "some updated color"
      assert award_type.description == "some updated description"
      assert award_type.emoji == "some updated emoji"
      assert award_type.fill == "some updated fill"
      assert award_type.image_format == "some updated image_format"
      assert award_type.name == "some updated name"
      assert award_type.svg_path == "some updated svg_path"
    end

    test "update_award_type/2 with invalid data returns error changeset" do
      award_type = award_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Awards.update_award_type(award_type, @invalid_attrs)
      assert award_type == Awards.get_award_type!(award_type.id)
    end

    test "delete_award_type/1 deletes the award_type" do
      award_type = award_type_fixture()
      assert {:ok, %AwardType{}} = Awards.delete_award_type(award_type)
      assert_raise Ecto.NoResultsError, fn -> Awards.get_award_type!(award_type.id) end
    end

    test "change_award_type/1 returns a award_type changeset" do
      award_type = award_type_fixture()
      assert %Ecto.Changeset{} = Awards.change_award_type(award_type)
    end
  end
end
