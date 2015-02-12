This is a simple library for writing pixels out to the apa102 over spi on the nodemcu platform. It seems to be capable of pushing data out to 150 pixels, at least.

Usage:

```
apa102.init()
apa102.write(0xff, string.chr(0x00, 0x00, 0xff))
```

`apa102.init()` sets the spi up for sending
`apa102.write(int brightness, string bytes)` sends out bgr pixels to the apa102 strip, applying a global brightness. The brightness has 5 bits of precision - the three preceding bits have to all be set high (1's). This function interleaves the global brightness value with the color data and pushes it out over spi
