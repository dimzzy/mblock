Signal services send data via UDP protocol. Each packet is an array of int32_t integers and has the following structure:

[0] 0x60, 0x0d, 0xf0, 0x0d aka 'GOODFOOD'
[1] signal type: 0x10 for motion, 0x20 for location, etc.
[2] length of the payload (rest of the packet)
[3...] payload and its content depends on signal type

Motion: payload contains three integers which represent x, y and z components of device's acceleration.
Palyload size is thus 3. Values are multiplied by 1000.

Location: payload contains three integers which represent latitude, longitude and altitude of the device.
Palyload size is thus 3. Values are multiplied by 1000.

Byte order for iOS devices is little-endian.
