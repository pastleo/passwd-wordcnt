defmodule PasswdWordcnt do

  def benchmark(pw_file, word_file) do
    start_time = :os.system_time(:seconds)
    run(pw_file, word_file)
    IO.puts("took #{:os.system_time(:seconds) - start_time} seconds")
  end

  def run(pw_file, word_file) do
    File.stream!(word_file, read_ahead: 100_000)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.flat_map(&tidy/1)
    |> Flow.map(&cnt_word(&1, pw_file))
    |> Flow.group_by(&elem(&1, 1))
    |> Flow.map(fn {word_length, words} ->
      Enum.sort_by(words, &elem(&1, 2), &>=/2)
      |> Enum.take(5)
      |> (&{word_length, &1}).()
    end)
    |> Enum.to_list()
    |> Enum.sort_by(&elem(&1, 0), &>=/2)
    |> show_result()
  end

  defp cnt_word(word, pw_file) do
    File.stream!(pw_file, read_ahead: 100_000)
    |> Enum.flat_map(&tidy/1)
    |> Enum.map(&pw_containing(&1, word))
    |> Enum.reduce(0, &+/2)
    |> inspect_status(word)
    |> (&{word, String.length(word), &1}).()
  end

  defp pw_containing(pw, word) do
    String.contains?(pw, word)
    |> case do
      true -> 1
      false -> 0
    end
  end

  defp tidy(""), do: []
  defp tidy("\n"), do: []
  defp tidy(word) do
    if String.printable?(word) do
      String.trim(word)
      |> String.downcase()
      |> List.wrap()
    else
      []
    end
  end

  defp inspect_status(cnt, word) do
    IO.write("#{IO.ANSI.clear_line}\r#{word}: #{cnt}")
    cnt
  end

  defp show_result(result) do
    IO.puts("\n === result ===")
    Enum.each(result, fn{word_length, ranking} ->
      IO.puts("[ length #{word_length} group ]")
      Enum.each(ranking, fn{word, _, cnt} ->
        IO.puts("#{word}: #{cnt}")
      end)
    end)
  end
end
