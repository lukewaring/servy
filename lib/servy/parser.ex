defmodule Servy.Parser do
  def parse(request) do
    [method, path, _] =      
        request
        |> String.split("\n") # request passed as first arg to split/2
        |> List.first
        |> String.split(" ")

    %{  method: method, 
        path: path, 
        resp_body: "", 
        status: nil 
     }

    # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
  end
end
