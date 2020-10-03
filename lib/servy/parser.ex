defmodule Servy.Parser do
  
  alias Servy.Conv
  
  def parse(request) do
    [method, path, _] =
      request
      # request passed as first arg to split/2
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{ 
      method: method,
      path: path,
    }

    # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
  end
end
