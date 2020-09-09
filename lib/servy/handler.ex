defmodule Servy.Handler do
    def handle(request) do
        request
        |> parse
        |> route
        |> format_response

        # conv = parse(request)
        # conv = route(conv)
        # format_response(conv)
    end

    def parse(request) do
        [method, path, _] =         
            request
            |> String.split("\n") # request passed as first arg to split/2
            |> List.first
            String.split(" ")

        %{ method: method, path: path, resp_body: "" }

        # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
    end
    
    def route(conv) do
        # TODO: Create a new map that also has the response body:
        conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
    end
    
    def format_response(conv) do
        # TODO: Use values in the map to create an HTTP response string:
        """
        HTTP/1.1 200 OK
        Content-Type: text/html
        Content-Length: 20
    
        Bears, Lions, Tigers
        """
    end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
