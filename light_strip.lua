dofile("apa102.lua")

rainbow_pattern = string.char(
	0x00, 0x00, 0xff,
	0x00, 0xaa, 0xdd,
	0x00, 0xdd, 0xaa,
	0x00, 0xff, 0x00,
	0xaa, 0xdd, 0x00,
	0xdd, 0xaa, 0x00,
	0xff, 0x00, 0x00,
	0xdd, 0x00, 0xaa,
	0xaa, 0x00, 0xdd
)

rainbow_count = string.len(rainbow_pattern)
led_count = 150

rainbows = (led_count * 3) / rainbow_count
partial_rainbows = rainbows % 1

apa102.init()

pattern = string.rep(
	rainbow_pattern,
	rainbows - partial_rainbows
)..string.sub(
	rainbow_pattern,
	1,
	partial_rainbows * rainbow_count
)

print(
	apa102.write(
		0xf0,
		pattern
	)
)
