# PasswdWordcnt

count common word usages in passwords from [duyetdev/bruteforce-database](https://github.com/duyetdev/bruteforce-database)

Just for testing [Flow](https://github.com/elixir-lang/flow)

## Run

```
git clone this_repo
cd this_repo
mix deps.get
iex -S mix

PasswdWordcnt.run("priv/test-pws.txt", "priv/test-words.txt")
^C^C

cd priv
git clone https://github.com/duyetdev/bruteforce-database.git
cd ..
iex -S mix

PasswdWordcnt.benchmark("priv/bruteforce-database/38650-password-sktorrent.txt", "priv/999-common-words.txt")
PasswdWordcnt.benchmark("priv/bruteforce-database/2151220-passwords.txt", "priv/999-common-words.txt")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `passwd_wordcnt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:passwd_wordcnt, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/passwd_wordcnt](https://hexdocs.pm/passwd_wordcnt).

