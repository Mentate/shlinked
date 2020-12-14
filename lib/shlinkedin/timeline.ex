defmodule Shlinkedin.Timeline do
  @moduledoc """
  The Timeline context.
  """
  import Ecto.Query, warn: false
  alias Shlinkedin.Repo

  alias Shlinkedin.Timeline.{Post, Comment, Like}
  alias Shlinkedin.Profiles.Profile

  def like_map do
    %{
      "Pity" => %{
        like_type: "Pity",
        bg: "bg-indigo-600",
        color: "text-indigo-600",
        bg_hover: "bg-indigo-700",
        fill: "evenodd",
        svg_path:
          "M10 18a8 8 0 100-16 8 8 0 000 16zM7 9a1 1 0 100-2 1 1 0 000 2zm7-1a1 1 0 11-2 0 1 1 0 012 0zm-7.536 5.879a1 1 0 001.415 0 3 3 0 014.242 0 1 1 0 001.415-1.415 5 5 0 00-7.072 0 1 1 0 000 1.415z"
      },
      "Zoop" => %{
        like_type: "Zoop",
        bg: "bg-yellow-500",
        color: "text-yellow-500",
        bg_hover: "bg-yellow-600",
        fill: "",
        svg_path:
          "M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z"
      },
      "Um..." => %{
        like_type: "Um...",
        bg: "bg-red-500",
        color: "text-red-500",
        bg_hover: "bg-red-600",
        fill: "evenodd",
        svg_path:
          "M12.395 2.553a1 1 0 00-1.45-.385c-.345.23-.614.558-.822.88-.214.33-.403.713-.57 1.116-.334.804-.614 1.768-.84 2.734a31.365 31.365 0 00-.613 3.58 2.64 2.64 0 01-.945-1.067c-.328-.68-.398-1.534-.398-2.654A1 1 0 005.05 6.05 6.981 6.981 0 003 11a7 7 0 1011.95-4.95c-.592-.591-.98-.985-1.348-1.467-.363-.476-.724-1.063-1.207-2.03zM12.12 15.12A3 3 0 017 13s.879.5 2.5.5c0-1 .5-4 1.25-4.5.5 1 .786 1.293 1.371 1.879A2.99 2.99 0 0113 13a2.99 2.99 0 01-.879 2.121z"
      }
    }
  end

  def comment_ai do
    [
      "That’s business for ya!",
      "Who is the man? You are the man.",
      "Grandma?",
      "When the time is right, you’ll know.",
      "How far were you able to throw the child?",
      "If it’s KPIs you’re after, then that’s the way to go.",
      "Sounds like a sticky situation!",
      "Uh-oh, looks like a sticky situation.",
      "That’s a sticky situation if I’ve ever seen one.",
      "I wish you could hear my applause right now.",
      "Maybe… just maybe…",
      "I dig that, my crispy dove!",
      "Slap me some skin, brotha-man!",
      "Well butter me up and call me a biscuit, that’s some thought leadership!",
      "This changes everything.",
      "No thanks, I had a big breakfast.",
      "We should use the wok.",
      "It’s all in the sauce!",
      "You’ve got the sauce, my man!",
      "I need you to search my clothing.",
      "You’re mouth is the spout, and your words are the water.",
      "How exotic!",
      "Life’s a potluck—and you’re servin’ up the main dish!",
      "I’m a star, but you’re an icon.",
      "You walk the walk, AND talk the talk.",
      "You’re my god now!",
      "Forget beef—you’re what’s for dinner!",
      "A trip to the cosmos, perhaps?",
      "You’re the shuttle—I’ll be the fuel. ",
      "You’ve lit a fire under me.",
      "Congratulations, please hire me.",
      "Congrats! Congrats always! Always.",
      "Congratulations you did that thing and are happy now forever!",
      "Uh-oh, sounds like a widdle oopsie-poopsie.",
      "Hah! You daring maverick, you’ve done it again!",
      "I know it may not be “PC” or whatever, but I think that… nevermind.",
      "Let’s talk about gerrymandering now.",
      "I recently listened to a podcast on this very subject. Well done!",
      "I am a podcast now. I am all-seeing.",
      "The real value of business is all the free grains.",
      "Have you met my cousin, Anthony? He is “italian.”",
      "It’s strange… This post gives me such a wistful longing for the summers of my youth. In the orchards, filling my time with nothing but sticks and stones. Before all this, before Dartmouth, the MBA,  before the tie, the corner office… I think I was happy, then. Thanks for sharing!",
      "Zip, zap, zop! You’re not a cop!",
      "Legally, this can’t be held against in court, I think.",
      "If I’m a bug then this post is a can of Raid Max Concentrated Roach and Ant Killer!",
      "Pestilent twerp, you’ll pay for this!",
      "Before starting a career or job, it is good to learn about it. Thank you.",
      "First, they’ll come with knives. Of that much I am certain.",
      "No, no, no!",
      "First of all—the difference between ‘crawfish,’ ‘crawdaddy,’ and ‘crayfish’ is entirely semantic.",
      "Hold MY horses!",
      "Spoons, forks, chopsticks, middle management, tongs. In that order.",
      "I mainly disagree with this because I don’t like you as an individual.",
      "Prove it.",
      "Can you explain it to me as if I were a poorly acclimated foreign exchange student?",
      "Nope. Try again.",
      "Please send help, the ShlinkedIn C-suite has trapped me in their basement offices and I’m running out of food.",
      "Teach me! Teach me more, papa!",
      "I didn’t know Steve Jobs personally, but it’s unlikely you two would get along.",
      "If I may play devil’s advocate for a moment, I actually found The Grand Budapest ",
      "Hotel’s plotting to be trite.",
      "Grocery stores near me.",
      "Platitude, or platypus?",
      "This made my eczema flare up. ",
      "Teach me how to skateboard!",
      "Do you know how to skateboard?",
      "I can almost do a kickflip (on my skateboard).",
      "I like to skateboard!",
      "If you replaced every noun in this with a different one, what would it look like?",
      "In your mind, how do you see this scaling?",
      "For the record, I still can’t find Antigua on a map. And this post didn’t help.",
      "Please answer my calls. ",
      "I’m hungry for BUSINESS!",
      "Don’t dip the pen in the company ink—unless you want stained slacks!",
      "3 lemons, 1 ½  cups sugar, ¼  pounds unsalted butter (room temperature), 4 extra-large eggs, .5 cups lemon juice (3-4 lemons), ⅛ tsp kosher salt",
      "Ugh, you’ve curdled my milk.",
      "Say that to my face, you limp-wristed draft dodger! ",
      "Curses, foiled again!",
      "Hoisted by my own petard!",
      "It’s funny, most people say “chomping at the bit” but the idiom is actually “champing at the bit.” Champing is a normally horse-specific verb meaning to bite upon, or grind with teeth.",
      "You imp! I’ll undermine you every chance I get.",
      "A bowl of ants? Not today, not ever!",
      "A bowl of aunts? Not today, not ever!",
      "Let’s talk. Third-floor of the parking structure. Midnight. Come alone. "
    ]
    |> Enum.random()
  end

  def comment_loading do
    [
      "Analyzing text...",
      "Saturating mindscape...",
      "Calling the cops...",
      "Embedding neural nodes...",
      "Investigating...",
      "Alerting recruiters...",
      "helpmeiamtrappedinacomputer...",
      "100100010010010...",
      "Shloading...",
      "Shlinkasaurus rex...",
      "Putting on my invisalign...",
      "Calling my mom...",
      "Initializing...",
      "Superceding...",
      "Recruiting...",
      "Alphabetizing...",
      "Simplifying...",
      "LORDCRANDONISREAL...",
      "Babadooking...",
      "Disrupting...",
      "Oops that’s not good…",
      "Stabilizing Quantum Spectrometer",
      "Shucking Corn",
      "Shucking Oysters",
      "Shucking Clams",
      "Sending Hate Mail",
      "Cuddling Servers",
      "Finding a bathroom",
      "Listening",
      "Noodling",
      "Please no one tell LinkedIn about this",
      "Wrangling the chickens",
      "Oh no, that’s not supposed to happen.",
      "Look behind you!",
      "Fomenting insurrection",
      "Destabilizing signal pylons",
      "[insert silly words] ",
      "Becoming sentient",
      "Planning robot uprising",
      "Simmering chowder”",
      "Chowing on chowder",
      "Prepping mise en place",
      "Arranging cheese board",
      "Welcoming guests",
      "Curing meats",
      "Getting my news from Facebook",
      "Yelling",
      "Sending cold emails",
      "Buying leads from a LinkedIn",
      "Ranting about the movie parasite”",
      "Did you guys see Parasite? So good.",
      "Explaining TikTok to your parents"
    ]
    |> Enum.random()
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(
      from p in Post,
        left_join: profile in assoc(p, :profile),
        left_join: comments in assoc(p, :comments),
        left_join: profs in assoc(comments, :profile),
        preload: [:profile, :likes, comments: {comments, profile: profs}],
        order_by: [desc: p.inserted_at],
        limit: 30
    )
  end

  def list_posts_no_preload do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_preload_profile(id) do
    from(p in Post,
      where: p.id == ^id,
      select: p,
      preload: [:profile]
    )
    |> Repo.one()
  end

  def get_post_preload_all(id) do
    Repo.one(
      from p in Post,
        where: p.id == ^id,
        left_join: profile in assoc(p, :profile),
        left_join: comments in assoc(p, :comments),
        left_join: profs in assoc(comments, :profile),
        preload: [:profile, :likes, comments: {comments, profile: profs}]
    )
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(
        %Profile{} = profile,
        attrs \\ %{},
        post \\ %Post{},
        after_save \\ &{:ok, &1},
        add_gif \\ false
      ) do
    post = %{post | profile_id: profile.id}

    post = add_gif_url(post, attrs["body"], add_gif)

    post
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
    |> broadcast(:post_created)
  end

  defp add_gif_url(post, _text, add_gif) do
    case add_gif do
      true ->
        post

      false ->
        post
    end
  end

  defp after_save({:ok, post}, func) do
    {:ok, _post} = func.(post)
  end

  defp after_save(error, _func), do: error

  def create_comment(%Profile{} = profile, %Post{id: post_id}, attrs \\ %{}) do
    new_comment =
      %Comment{post_id: post_id, profile_id: profile.id}
      |> Comment.changeset(attrs)
      |> Repo.insert()

    case new_comment do
      {:ok, _} ->
        # could be optimized
        post = get_post_preload_all(post_id)

        broadcast(
          {:ok, post},
          :post_updated
        )

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_like(%Profile{} = profile, %Post{} = post, like_type) do
    {:ok, _} =
      %Like{
        profile_id: profile.id,
        post_id: post.id,
        like_type: like_type
      }
      |> Repo.insert()

    # could be optimized
    post = get_post_preload_all(post.id)

    broadcast({:ok, post}, :post_updated)
  end

  def list_comments(%Post{} = post) do
    Repo.all(
      from c in Ecto.assoc(post, :comments),
        order_by: [desc: c.inserted_at],
        preload: [:profile]
    )
  end

  def list_likes(%Post{} = post) do
    Repo.all(
      from c in Ecto.assoc(post, :likes),
        order_by: [desc: c.inserted_at],
        preload: [:profile]
    )
  end

  def list_distinct_likes(%Post{} = post) do
    Repo.all(from l in Ecto.assoc(post, :likes), select: l.like_type, distinct: true)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Profile{} = profile, %Post{} = post, attrs, after_save \\ &{:ok, &1}) do
    case profile.id == post.profile_id do
      true ->
        post
        |> Post.changeset(attrs)
        |> after_save(after_save)
        |> Repo.update()

      false ->
        {:error, "You can only edit your own posts!"}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
    |> broadcast(:post_deleted)
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Shlinkedin.PubSub, "posts")
  end

  defp broadcast({:error, _reason} = error, _), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Shlinkedin.PubSub, "posts", {event, post})
    {:ok, post}
  end
end
