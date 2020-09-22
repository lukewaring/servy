defmodule Servy.Parser do
  def parse(request) do
    [method, path, _] =
      request
      # request passed as first arg to split/2
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}

    # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
  end
end
