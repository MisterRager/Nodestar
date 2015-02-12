function create_server(port, type, callback)
    --type = net.TCP or net.UDP
    srv=net.createServer(type) 
    srv:on("receive", callback)
    srv:listen(port)
end

dofile('apa102.lua')

apa102.init()

content = ""

create_server(80, net.UDP, function(conn) 
    conn:on("receive",function(conn,payload) 
        --print("Number of received bytes: "..string.len(payload)) 
        --apa102.write(0xf0, payload)
        content = payload
    end)
end)

tmr.alarm(0, 20, 1, function()
    if string.len(content) > 0 then
        print("Writing out "..string.len(content).."bits")
        apa102.write(0xf0, content)
        content = ""
    end
end)
