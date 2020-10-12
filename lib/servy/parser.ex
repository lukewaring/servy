defmodule Servy.Parser do
  
  alias Servy.Conv
  
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = parse_params(params_string)

    # First approach:
    # [method, path, _] =
    #   top
    #   # request passed as first arg to split/2
    #   |> String.split("\n")
    #   |> List.first()
    #   |> String.split(" ")

    %Conv{ 
      method: method,
      path: path,
      params: params
    }

    # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
  end

  def parse_params(params_string) do 
    params_string |> String.trim |> URI.decode_query
  end
end
