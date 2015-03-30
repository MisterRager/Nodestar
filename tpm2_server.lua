tpm2_server = {
    output = nil,
    message = nil,
    port = 65506,
    brightness = 5, --max 31, min 0
    lock = 0,
}
tpm2_server.__index = tpm2_server

function tpm2_server:new()
    local self = setmetatable({}, tpm2_server)
    return self
end

function tpm2_server:start()
    print("Starting TPM2.net nodestar server")
    spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 0)
    spi.apa102_brightness( self.brightness )

    svr=net.createServer(net.UDP)
    svr:on("receive", function(socket, data)
        self:receive_data(socket, data)
    end)
    svr:listen(self.port)

    tmr.alarm(0, 100, 1, function()
        self:process_loop()
    end)
end

function tpm2_server:receive_data(socket, data, packet_callback)
    if self.lock ~= 1 and data:byte(2) == 218 then
        self.lock = 1
        --len = data:len()
        
        buffsize = data:byte(3) * 256 + data:byte(4)
        self.output = data:sub(7,6 + buffsize)
        
        self.lock = 0
        socket:send(string.char(0xac))
    end
end

function tpm2_server:process_loop()
    if 0 == self.lock and nil ~= self.output then
        self.lock = 1
        spi.apa102_send(self.output)    
        tmr.wdclr()
        self.lock = 0
    end
end

function tpm2_server:set_brightness( brt )
    self.brightness = brt
    spi.apa102_brightness( brt )
end
