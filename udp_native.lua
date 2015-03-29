
n_udp_server = {
    output = nil,
    message = nil,
    port = 65506,
    brightness = 31, --max 31, min 0
}
n_udp_server.__index = n_udp_server

function n_udp_server:new()
    local self = setmetatable({}, n_udp_server)

    return self
end

function n_udp_server:packet_callback(data)
    --print(self.message)
    spi.apa102_send(1, data)
end

function n_udp_server:start()
    print("Starting UDP nodestar server")
    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 0);

    svr=net.createServer(net.UDP)   
    svr:on("receive", function(socket, data)
        self:receive_data(socket, data)
    end)
    svr:listen(self.port) 
    
    tmr.alarm(0, 2, 1, function()
        self:process_loop()
    end)
end

function n_udp_server:receive_data(socket, data, packet_callback) 
    self.message = "Got "..string.len(data).." bytes"
    self.output = data
    socket:send(string.char(0xac))
end

function n_udp_server:process_loop()
    out = self.output
    self.output = nil

    if nil ~= out then
        self:packet_callback(out)
        tmr.wdclr()
    end
end
