--[[
APA102 control helpers

Use these to push pixels to apa102 (dotstar) lights over SPI on the nodemcu platform.

Alan Rager
Feb 11, 2015
--]]

apa102 = {}
	
--Initialize for writing spi
function apa102.init()
	-- Thanks, elevation: http://www.esp8266.com/viewtopic.php?p=8959#p8959
	-- Posted Feb 04, 2015, lifted Feb 11, 2015
	spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, 0);
end

--[[
	Write out a string of bytes to the apa102 lights
	@param number brightness - a single byte of data to write; 3 bits high, then 5 bits of brightness to set globally
	@param string data - a string of bytes in bgr order to write to the light strip
--]]
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
