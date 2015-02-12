apa102 = {APA102_INITIALIZED = false}
	
function apa102.init()
	if (apa102.APA102_INITIALIZED == false) then
		pin=8 
		spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 0);
		gpio.mode(pin, gpio.OUTPUT)
		apa102.APA102_INITIALIZED = true
	end
end

function apa102.write(brightness, data)
	local led_count = string.len(data) / 3
	local output_buffer = {}
	local i = 0
	local bright_char = string.char(brightness)

	print("LED count is "..led_count)

	while #output_buffer < led_count do
		table.insert(
			output_buffer,
			bright_char..string.sub(
				data,
				i * 3 + 1, 
				(i * 3) + 3
			)
		)
		i = i + 1
	end

	return spi.send(
		1,
		string.rep(
			string.char(0x00),
			4
		)..table.concat(
			output_buffer
		)..string.rep(
			string.char(0xff),
			led_count * 2
		)
	)
end
