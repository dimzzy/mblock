Signal services send data via UDP protocol. Each packet is an array of int32_t integers and has the following structure:

[0] 0x60, 0x0d, 0xf0, 0x0d aka 'GOODFOOD'
[1] timestamp (milliseconds from midnight of Jan 1, 1970)
[1] signal type: 0x10 for motion, 0x20 for location, 0x30 for proximity.
[2] length of the payload (rest of the packet)
[3...] payload and its content depends on signal type

Motion: payload contains three integers which represent roll, pitch and yaw of the device's orientation (Euler angles)
followed by x, y and z components of device's acceleration. Palyload size is thus 6. Values are multiplied by 1000.
Packets are sent at the specified frequency.

Location: payload contains three integers which represent latitude, longitude and altitude of the device.
Palyload size is thus 3. Values are multiplied by 1000. Packets are sent as location is changed or corrected.

Proximity: payload contains one integer which is 1 if device is next to face and 0 otherwise. Packet is sent only when
it changes.

Byte order for iOS devices is little-endian.



TODO

- Use block groups
- Group new blocks by groups
- Allow several top blocks in workspace
- Show when block generates signal
- Move start/stop button to the bottom bar
- Show status at the bottom (running, stopped, failed to start)

- Allow to add nested group blocks
- Add integrator block
- Add block to rearrange signal data
- Add scope block
- Add block which calculates constant error
- Enforce block uniquess
- Support UDP broadcast

- Support audio in
- Support audio out

- Allow to generate target project
- Allow to generate UI
