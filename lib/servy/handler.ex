defmodule Servy.Handler do

    @moduledoc "Handles HTTP requests."

    @pages_path Path.expand("../../pages", __DIR__)

    @doc "Transforms the request into a response."
    def handle(request) do
        request
        |> parse
        |> rewrite_path
        |> log
        |> route
        |> track   
        |> format_response

        # conv = parse(request)
        # conv = route(conv)
        # format_response(conv)
    end

    @doc "Logs 404 requests."
    def track(%{ status: 404, path: path } = conv) do
        IO.puts "Warning: #{path} is on the loose!"
        conv
    end

    def track(conv), do: conv

    def rewrite_path(%{ path: "wildlife" } = conv) do 
        %{ conv | path: "/wildthings" }
    end

    def rewrite_path(conv), do: conv

    def log(conv), do: IO.inspect conv # IO.inspect prints *and* returns the inspected data structure

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
    
    # def route(conv) do
    #     route(conv, conv.method, conv.path)
        
    #     # conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
    # end
    
    # def route(conv, "GET", "/wildthings") do 
    #     %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
    # end

    def route(%{ method: "GET", path: "/wildthings" } = conv) do 
        %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
    end
    
    def route(%{ method: "GET", path: "/bears" } = conv) do 
        %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
    end
    
    def route(%{ method: "GET", path: "/bears/new" } = conv) do
        @pages_path
        |> Path.join("form.html")
        |> File.read
        |> handle_file(conv)
    end

    def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
        %{ conv | status: 200, resp_body: "Bear #{id}" }
    end

    # def route(%{ method: "DELETE", path: "/bears/" <> _id } = conv) do
    #     %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!" }
    # end

    def route(%{ method: "GET", path: "/about" } = conv) do
        @pages_path
        |> Path.join("about.html")
        |> File.read
        |> handle_file(conv)
        
        # pages_path = Path.expand("../../pages", __DIR__)
        # file = Path.join(pages_path, "about.html")

        # case File.read(file) do
        #     {:ok, content} ->
        #         %{ conv | status: 200, resp_body: content}

        #     {:error, :enoent} ->
        #         %{ conv | status: 404, resp_body: "File not found!" }

        #     {:error, reason} ->
        #         %{ conv | status: 500, resp_body: "File error: #{reason}" }
        # end
    end
    
    def route(%{ path: path } = conv) do
        %{ conv | status: 404, resp_body: "No #{path} here!" }
    end

    def handle_file({:ok, content}, conv) do 
        %{ conv | status: 200, resp_body: content}
    end

    def handle_file({:error, :enoent}, conv) do 
        %{ conv | status: 404, resp_body: "File not found!"}
    end

    def handle_file({:error, reason}, conv) do 
        %{ conv | status: 500, resp_body: "File error: #{reason}"}
    end
    
    def format_response(conv) do
        """
        HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
        Content-Type: text/html
        Content-Length: #{byte_size(conv.resp_body)}
    
        #{conv.resp_body}
        """
    end

    defp status_reason(code) do
        %{
            200 => "OK",
            201 => "Created",
            401 => "Unauthorized",
            403 => "Forbidden",
            404 => "Not Found",
            500 => "Internal Server Error"
        } [code]
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

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

# request = """
# DELETE /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)

# IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
