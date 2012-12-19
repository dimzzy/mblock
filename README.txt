Signal services send data via UDP protocol. Each packet has the following structure:

- Bytes 0-3 are 0x60, 0x0d, 0xf0, 0x0d aka 'GOODFOOD'
- Byte 4 is signal type: 0x0a for motion, 0x0b for location
- Bytes 5 and 6 is an uint16_t integer which is the length of the payload (rest of the packet)
- Bytes from 7 is a payload and its content depends on signal type

Motion: payload contains three int32_t integers which represent x, y and z components of device's acceleration.
Palyload size is thus sizeof(int32_t) * 3. Values are multiplied by 1000.

Location: payload contains three int32_t integers which represent latitude, longitude and altitude of the device.
Palyload size is thus sizeof(int32_t) * 3. Values are multiplied by 1000.

Byte order for iOS devices is little-endian.
