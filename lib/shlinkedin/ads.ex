defmodule Shlinkedin.Ads do
  @moduledoc """
  The Ads context.
  """

  import Ecto.Query, warn: false
  alias Shlinkedin.Repo

  alias Shlinkedin.Ads.{Ad, AdLike, Click}
  alias Shlinkedin.Profiles.{Profile, ProfileNotifier}

  @doc """
  Returns the list of ads.

  ## Examples

      iex> list_ads()
      [%Ad{}, ...]

  """
  def list_ads do
    Repo.all(Ad)
  end

  def count_profile_ads(%Profile{} = profile) do
    Repo.aggregate(from(a in Ad, where: a.profile_id == ^profile.id), :count)
  end

  def list_profile_ads(%Profile{} = profile) do
    Repo.all(from a in Ad, where: a.profile_id == ^profile.id, preload: [:adlikes, :profile])
  end

  def list_unique_ad_clicks(%Profile{} = profile) do
    Repo.all(
      from a in Ad,
        where: a.profile_id == ^profile.id,
        join: c in Click,
        on: a.id == c.ad_id,
        group_by: [c.profile_id, c.ad_id],
        select: %{profile_id: c.profile_id, ad_id: c.ad_id}
    )
  end

  def list_unique_ad_clicks(%Profile{} = profile, start_date) do
    Repo.all(
      from a in Ad,
        where: a.profile_id == ^profile.id,
        join: c in Click,
        on: a.id == c.ad_id,
        where: c.inserted_at >= ^start_date,
        group_by: [c.profile_id, c.ad_id],
        select: %{profile_id: c.profile_id, ad_id: c.ad_id}
    )
  end

  def get_random_ads(num) do
    Repo.all(
      from a in Ad,
        limit: ^num,
        order_by: fragment("RANDOM()"),
        preload: :profile,
        preload: :adlikes
    )
  end

  def get_random_ad() do
    Repo.one(
      from a in Ad,
        limit: 1,
        order_by: fragment("RANDOM()"),
        preload: :profile,
        preload: :adlikes,
        where: a.removed == false
    )
  end

  def get_ad_preload_profile!(id) do
    Repo.one(
      from a in Ad, where: a.id == ^id, preload: :profile, preload: :clicks, preload: [:adlikes]
    )
  end

  @doc """
  Gets a single ad.

  Raises `Ecto.NoResultsError` if the Ad does not exist.

  ## Examples

      iex> get_ad!(123)
      %Ad{}

      iex> get_ad!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ad!(id), do: Repo.get!(Ad, id)

  @doc """
  Creates a ad.

  ## Examples

      iex> create_ad(%{field: value})
      {:ok, %Ad{}}

      iex> create_ad(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ad(%Profile{} = profile, %Ad{} = ad, attrs \\ %{}, after_save \\ &{:ok, &1}) do
    ad = %{ad | profile_id: profile.id}

    ad
    |> Ad.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  def create_ad_click(%Ad{profile: ad_profile} = ad, %Profile{} = profile, attrs \\ %{}) do
    %Click{ad_id: ad.id, profile_id: profile.id}
    |> Click.changeset(attrs)
    |> Repo.insert()
    |> ProfileNotifier.observer(:ad_click, profile, ad_profile)
  end

  @doc """
  Checks if like on ad count is currently zero, which
  means that the adlike about to be added is first.
  """
  def is_first_like_on_ad?(%Profile{} = profile, %Ad{} = ad) do
    Repo.one(
      from l in AdLike,
        where: l.ad_id == ^ad.id and l.profile_id == ^profile.id,
        select: count(l.profile_id)
    ) == 0
  end

  def delete_like(%Profile{} = profile, %Ad{} = ad) do
    Repo.one(from l in AdLike, where: l.ad_id == ^ad.id and l.profile_id == ^profile.id)
    |> Repo.delete()

    # could be optimized
    # ad = get_article_preload_votes!(article.id)

    # broadcast({:ok, article}, :article_updated)
  end

  def get_like_on_ad(%Profile{} = profile, %Ad{} = ad) do
    Repo.one(
      from l in AdLike,
        where: l.ad_id == ^ad.id and l.profile_id == ^profile.id,
        select: l.like_type
    )
  end

  def create_like(%Profile{} = profile, %Ad{} = ad, like_type) do
    {:ok, _like} =
      %AdLike{
        profile_id: profile.id,
        ad_id: ad.id,
        like_type: like_type
      }
      |> Repo.insert()
      |> ProfileNotifier.observer(:ad_like, profile, ad.profile)
  end

  @doc """
  Updates a ad

  ## Examples

      iex> update_ad(ad, %{field: new_value})
      {:ok, %Ad{}}

      iex> update_ad(ad, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ad(%Profile{} = profile, %Ad{} = ad, attrs, after_save \\ &{:ok, &1}) do
    case profile.id == ad.profile_id or profile.admin do
      true ->
        ad
        |> Ad.changeset(attrs)
        |> after_save(after_save)
        |> Repo.update()

      false ->
        {:error, "You can only edit your own ads!"}
    end
  end

  @doc """
  Deletes a ad.

  ## Examples

      iex> delete_ad(ad)
      {:ok, %Ad{}}

      iex> delete_ad(ad)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ad(%Ad{} = ad) do
    Repo.delete(ad)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ad changes.

  ## Examples

      iex> change_ad(ad)
      %Ecto.Changeset{data: %Ad{}}

  """
  def change_ad(%Ad{} = ad, attrs \\ %{}) do
    Ad.changeset(ad, attrs)
  end

  defp after_save({:ok, ad}, func) do
    {:ok, _ad} = func.(ad)
  end

  defp after_save(error, _func), do: error
end
