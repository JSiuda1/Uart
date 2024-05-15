import serial

with serial.Serial('/dev/ttyUSB1', 115200, timeout=1) as ser:
    tx_val = 0
    while True:
        print(f"Wyslano: 0x{tx_val:02x}")
        ser.write(tx_val.to_bytes())
        tx_val = tx_val + 1
        if tx_val > 15:
            tx_val = 0

        rx = ser.read()
        if rx:
            print(f"Odebrano: 0x{int.from_bytes(rx):02x}")