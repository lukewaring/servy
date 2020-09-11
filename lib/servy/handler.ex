defmodule Servy.Handler do
    def handle(request) do
        request
        |> parse
        |> log
        |> route
        |> format_response

        # conv = parse(request)
        # conv = route(conv)
        # format_response(conv)
    end

    def log(conv), do: IO.inspect conv # IO.inspect prints *and* returns the inspected data structure

    def parse(request) do
        [method, path, _] =      
            request
            |> String.split("\n") # request passed as first arg to split/2
            |> List.first
            |> String.split(" ")

        %{ method: method, path: path, resp_body: "" }

        # [method, path, _] = ["GET", "/wildthings", "HTTP/1.1"]
    end
    
    def route(conv) do
        route(conv, conv.method, conv.path)
        
        # conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
    end

    def route(conv, "GET", "/wildthings") do 
        %{ conv | resp_body: "Bears, Lions, Tigers" }
    end

    def route(conv, "GET", "/bears") do 
        %{ conv | resp_body: "Teddy Smokey, Paddington" }
    end
    
    def format_response(conv) do
        """
        HTTP/1.1 200 OK
        Content-Type: text/html
        Content-Length: #{byte_size(conv.resp_body)}
    
        #{conv.resp_body}
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

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
