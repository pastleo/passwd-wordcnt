defmodule PasswdWordcnt do
  @default_common_words_file "priv/999-common-words.txt"

  def benchmark(pw_list_file, common_words_file \\ @default_common_words_file) do
    start_time = :os.system_time(:seconds)
    run(pw_list_file, common_words_file)
    IO.puts("took #{:os.system_time(:seconds) - start_time} seconds")
  end

  def run(pw_list_file, common_words_file \\ @default_common_words_file) do
    File.read!(pw_list_file)
    |> String.split("\n")
    |> Enum.flat_map(&tidy/1)
    |> word_cnts(common_words_file)
    |> show_result()
  end

  defp word_cnts(passwds, common_words_file) do
    File.stream!(common_words_file)
    |> Stream.flat_map(&tidy/1)
    |> Stream.map(&passwds_containing_cnt(&1, passwds))
  end

  defp passwds_containing_cnt(word, passwds) do
    Enum.reduce(passwds, 0, fn pw, cnt ->
      String.contains?(pw, word)
      |> case do
        true -> cnt + 1
        false -> cnt
      end
    end)
    |> inspect_status(word)
    |> (&{word, &1}).()
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
    IO.write("#{IO.ANSI.clear_line}\rRunning... #{word}: #{cnt}")
    cnt
  end

  defp show_result(result) do
    IO.write("#{IO.ANSI.clear_line}\r")
    IO.puts("╭──────────────────────────╮")
    IO.puts("│      showing result      │")
    IO.puts("╰──────────────────────────╯")

    Enum.to_list(result)
    |> Enum.map(fn {word, cnt} ->
      {word, cnt, String.length(word)}
    end)
    |> Enum.filter(&(elem(&1, 2) >= 3))
    |> Enum.group_by(&elem(&1, 2))
    |> Enum.to_list()
    |> Enum.filter(fn {_, words} ->
      Enum.map(words, &elem(&1, 1))
      |> Enum.sum()
      |> (&(&1 > 0)).()
    end)
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.each(fn {word_length, words} ->
      IO.puts(" * length #{word_length} group")

      Enum.sort_by(words, &elem(&1, 1), :desc)
      |> Enum.take(5)
      |> Enum.each(fn{word, cnt, _} ->
        IO.puts(" |   #{word}: #{cnt}")
      end)
    end)
  end
end
