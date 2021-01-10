# PasswdWordcnt

count common word usages in passwords from [duyetdev/bruteforce-database](https://github.com/duyetdev/bruteforce-database)

for demonstrating [Enum](https://hexdocs.pm/elixir/Enum.html), [Stream](https://hexdocs.pm/elixir/Stream.html) and [Flow](https://github.com/elixir-lang/flow)

## Run

```
git clone this_repo
cd this_repo
mix deps.get
iex -S mix

PasswdWordcnt.run("priv/pws-test.txt")
^C^C

curl -L 'https://github.com/duyet/bruteforce-database/raw/master/38650-password-sktorrent.txt' > priv/38650-password-sktorrent.txt
# or other password list file at your choice

iex -S mix

PasswdWordcnt.benchmark("priv/38650-password-sktorrent.txt")
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

