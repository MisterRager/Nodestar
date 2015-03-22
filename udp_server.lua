dofile('apa102.lua')

udp_server = {
    output = nil,
    message = nil,
    port = 65506,
    brightness = 0xed,
}
udp_server.__index = udp_server

function udp_server:new()
    local self = setmetatable({}, udp_server)

    return self
end

function udp_server:packet_callback(data)
    --print(self.message)
    apa102.write(self.brightness, data)
end

function udp_server:start()
    print("Starting UDP nodestar server")
    apa102.init()

    svr=net.createServer(net.UDP)   
    svr:on("receive", function(socket, data)
        self:receive_data(socket, data)
    end)
    svr:listen(self.port) 
    
    tmr.alarm(0, 1, 1, function()
        self:process_loop()
    end)
end

function udp_server:receive_data(socket, data, packet_callback) 
    self.message = "Got "..string.len(data).." bytes"
    self.output = data
    socket:send(string.char(0xac))
end

function udp_server:process_loop()
    out = self.output
    self.output = nil

    if nil ~= out then
        tmr.wdclr()
        self:packet_callback(out)
    end
end
