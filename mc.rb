require 'socket'
server = TCPSocket.open('localhost',8080)
request=Thread.new do 
	loop do
		msg = server.gets.chomp
		puts msg
	end
end
res=Thread.new do
	loop do
		msg = gets.chomp
		server.puts(msg)
	end
end

request.join
res.join
