$VERBOSE=nil
require 'socket'
server = TCPServer.open(8080)
$clients=Hash.new

#Method for assigning colors to clients
def colorise(colorn)
	case colorn
	when -1
		return "\033[0m"
	when 0
		return "\033[34m"
	when 1
		return "\033[32m" 
	when 2
		return "\033[33m"
	when 3
		return "\033[31m"
	when 4
		return "\033[35m"
	else return "\033[36m"
	end
end

#Method for throwing list of registered users
def list(client,i)
	$clients.each do |name,soc|
		client.puts("\033[1m "+colorise(5)+"*"+name+colorise(i)+"\033[22m")
	end
end

#Send group messages to all clients except the one which is sending and in case the message is list it will list all the active users. 
def message(client,msg,i)
	loop {
		cur=client.gets
		if cur.chomp == 'list'
		list(client,i)
		else
		new=colorise(-1)+msg+colorise(i)+": "+cur.chomp
		$clients.each do |name,soc|
			if soc[0] != client
			soc[0].puts(new+colorise(soc[1]))
			end
		    end
		end
	}
end

i=-1
loop {
	Thread.start(server.accept) do |client|
		client.puts colorise(5)+"\033[1mHello there, Enter your name"
		msg=client.gets.chomp
		i+=1
		client.puts "Hi "+msg+"! People up are listening\033[22m"+colorise(-1) 
		$clients.update(msg => [client,i])
		client.puts(colorise(i))
		puts msg+" connected. Socket ID : "+client.to_s 
		message(client,msg,i)	
	end
}
