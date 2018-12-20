CH341's serial port mode supports WINDOWS 98/ME/2000/XP/Vista/Linux, and provides related drivers. The
CH341's USB to serial port supports most common serial port monitoring and debugging tools.

Driver installation method:
1. Standard INF file installation method
    WINDOWS prompts to find new hardware, specify the driver directory DRIVER, automatically install the driver,
    if WINDOWS does not prompt to find new hardware, then in the hardware list of the device manager,
    select the question mark USB device, update the driver and specify the directory.
2. Use the driver installation tool to
    directly install/upgrade/uninstall drivers using the CH341SER.EXE installation package,
    which is more suitable for end users.

CH341 serial port usage method:
    CH341 realizes USB to serial port, and the use of logic function is the same as that of ordinary computer serial port.
    The difference with the ordinary computer serial port:
      CH341 provides the emulation serial port, so it does not support the pure hardware operation of the serial port itself, such as I/O operation, the
      ordinary computer serial port is a static device, and the CH341 serial port is a dynamic device, which is theoretically disconnected at any time. ,
      CH341 additional features (described below): read external serial EEPROM, supporting higher baud.
    The "module debugging" tool is provided. After starting, the "type" is selected as "manual input and send". After the
      serial port is opened, it can be used for input/output monitoring and transceiver debugging of CH341 serial port or common serial port.

Note:
    CH341 serial USB plug and play devices, the process is using CH341 serial port for data transmission,
    which can not be turned off (OFF means is removed from the USB socket CH341 or CH341 is power off),
    but also That is to say, the CH341 serial port must be unplugged from the USB socket after the application closes the serial port.

    If the CH341 serial device is disconnected from the USB socket while the application is using the CH341 serial port,
    the application should close the CH341 serial port and exit as soon as possible (close and exit may take several seconds).

    If an error occurs during the CH341 serial communication, it is very likely that the CH341 serial port has been physically disconnected.
    Therefore, after detecting an error, it is recommended to turn off the CH341 serial port and wait a second for two seconds before re-opening the serial communication.

    The device event notification method can be used to know the connection and disconnection of the CH341 serial device in time,
    so that the serial port application can open and close the CH341 serial port in time.
    The serial port dynamic link library CH341PT.DLL provides an API to monitor the CH341 serial port plug and play events, and
    can search and identify the CH341 serial port. For details, please refer to the CH341PT.H file.

    If the communication baud rate is high, it is recommended to set a larger buffer. Especially under WINDOWS 98/ME, the
    thread scheduling capability and USB real-time performance are worse than WINDOWS 2000/XP. If the serial port receive buffer is small,
    then the communication is in communication. When the baud rate is high, receiving a large amount of data will cause the serial buffer to overflow and discard the data.

    Since the underlying USB is composed of multiple bytes and then inserted into each 1mS frame for transmission,
    it is possible to actually split the two bytes that are directly connected to the serial port into two USB packets or even
    two USBs. In the frame, in the worst case, these two bytes may be separated by 1mS or even 2mS in time.

************************************************** *****************************

If rate control (flow control) is required, it is recommended not to use MODEM signal control because it is less efficient It is
recommended to use CH341's TEN# and RDY# to achieve pure hardware rate control, where TEN# is input and RDY# is output.
When TEN# input is low, CH341 is allowed to send data from serial port. When high level, CH341 will suspend transmission. Data,
when RDY# output is low, CH341 can receive serial port data, high level indicates that CH341 is busy and cannot receive.

If the computer and the microcontroller are not busy, or the baud rate is below 115200bps, the rate control is usually not needed.
If the baud rate is higher or the computer and the MCU are busy, it is necessary to consider using TEN# and RDY# for rate control.

When CH341 is used for serial port, its hardware is the simplest. Only three wires are needed: GND, TXD, RXD, which
can be directly connected to the MCU. The baud rate is supported from 50bps to 2Mbps. For example, MCS51 MCU:
   CH341 pin MCS51 MCU pin
      GND < => GND
      TXD <=> RXD
      RXD <=> When TXD
      TEN is connected to GND

and connected to the MCU, the TEN# pin of CH341 is usually grounded directly, and CH341 is always allowed to send data.
If the budget MCU may not have time to receive serial data, then TEN# should be connected to the I/O pin of.
the MCUWhen the MCU is not busy, the TEN# of CH341 is set low by the MCU, allowing CH341 to send data from the serial port.
When the MCU is busy, the M341 will be CH510. The TEN# is set to a high level, and the CH341 will suspend the data from the serial port

. The TNOW pin of the CH341 is a transceiving state, which can be used for transceiving and switching of half-duplex communication, such as RS485 transmission and reception switching.

************************************************** *****************************
How to identify the CH341 serial port, how to know the CH341 serial port number COM?

When installing the CH341 serial port driver for the first time, The CH341 serial port number is automatically assigned by WINDOWS (usually distributed from COM3). After the
installation is completed, you can modify its serial port number by clicking its properties in the device management. Since the application cannot know theCH341 beforehand
actual serial port number of the, you must use some special methods to identify the CH341 serial port before you can use it.

In the WINDOWS 98/ME system, the CH341 serial port number is related to the current hardware resource configuration. The default is to automatically allocate resources.
  After the current actual serial port number, you can select the CH341 resource configuration in the serial port attribute to specify the serial port number.
In WINDOWS 2000/XP system, the CH341 serial port number is related to the current USB port. It is assigned by the first installation.
  WINDOWS memorizes the serial port number of each USB port CH341. You can specify the serial port number through the advanced option in the serial port properties.

The simpler but very laborious method is to modify the registry or point its properties after installing the CH341 serial port for the first time. Manually change
the serial port number of the CH341 to COM5, avoiding the common COM1 to COM4. This method is simple but possible. conflict.

The conventional identification method is to use the software query method:
   try to open the serial port name one by one. After opening successfully, the special serial stringand received through the serial port to identify the CH341 serial port.
   is sentThe method starts from “COM1”, and then “COM2” tries to open the serial port one by one. If a serial port is successfully opened,
   a special string "CH341Ser?" is sent to the serial port at a baud rate of 300 bps. If theiswithin about 200 milliseconds
   response character "W"received, the serial port is the currently connected CH341. Serial port. The software design method is:
   open each serial port in turn from COM1, if it fails to open the serial port, skip it (the serial port does not exist or is in use),
   if it is successfully opened, set the serial port baud rate to 300, and then write ASCII to the serial port. The string "$CH341Ser?",
   pay attention to capitalization. A total of 10 characters are written at a time. If the serial port is a normal serial port, there is usually no return.
   If the serial port is a CH341 serial port, the application will receive an ASCII character. "W" to identify CH341.
   For example, use the serial port monitoring/debugging tool software demo:
     select the baud rate of the serial port to 300bps (some tool software must re-open the serial port after selecting the baud rate), and
     issue the feature string for 10 ASCII codes: $CH341Ser ?
     after sending successfully, serial no ordinary return, and CH341 will return a serial ASCII code: W

is recommended CH341PT.DLL dynamic libraries, applications can directly call the appropriate API DLL CH341 serial identification,
   fast identification speed, high efficiency. Note that CH341PT.DLL is defined as an optional installation in the INF, the default is installed

********************************** ***********************************************
About reading The external serial EEPROM

CH341 can be connected to an I2C interface device, such as the commonly used 24-series serial nonvolatile memory EEPROM, which
supports 24C01A, 24C02, 24C04, 24C08, 24C16, etc., and timing compatible devices. The
24 series EEPROM can be used. It is used to configure the CH341 and can also be used to save important data during power outages.
For example, the identification information such as the product serial number is saved, and the application can read out the function for identifying the product.
If you need to support 24C64, 24C256, 24C512 and larger EEPROM, please refer to the CH341 evaluation board data.

The application can read and write the 24-series EEPROM connected to the CH341 by serial port. The method is:
  set the CH341 serial port baud rate to 300, and then write the serial port with a 4-byte
  command packet. The first byte of the command packet must be @, address character, the corresponding hexadecimal number is 40H,
  the second byte of the command packet is the device address of the 24 series EEPROM, bit 0 is the direction flag, 0 is write, 1 is read,
  the third word of the command packet The section is the unit address of the 24 series EEPROM.
  The fourth byte of the command packet is a data to be written to the 24 series EEPROM. If it is a read operation, it is designated as 00H.
  If it is a write operation, the command is successfully sent, indicating that the write is successful. For the EEPROM,necessary to delay 10mS tonext operation.
  it isperform theIf it is a read operation, after the command is successfully sent, one byte of data can be received from the serial port, that is, the read data is,

for example, CH341 is connected to 24C0X, A2=A1=A0. = GND, the baud rate of the emulation serial port is selected as 300bps, which
can be demonstrated by the serial port monitoring/debugging tool software:
1. Issue the command packet for 4 hexadecimal data: 40 A1 01 00
   will address the address of 01C in 24C0X Data readout, can Receive one byte of data from the serial port
2. Issue the command packet, which is 4 hexadecimal data: 40 A0 2A 69
   Write one byte of data 69H to the unit of address 2AH in 24C0X, usually wait 10mS Perform the next operation
3. Issue the command packet for 4 hexadecimal data: 40 A5 E7 00
   Read the data of address 02E7H in 24C0X, and receive one byte of data from the serial port.
   Note that only 24C08 and 24C16 There is a data unit with address 02E7H

****************************************** *************************************
About support for non-standard baud rate or higher communication port Rate

For some non-standard baud rate or high-speed wave rate that cannot be set by conventional methods, the CH341 driver provides a special method. The
application can indirectly set the serial port baud rate of the CH341 by writing data in the serial port by
  setting CH341. The serial port baud rate is 300, and then the serial port is written with the ASCII code string command.
  The first byte of the command packet must be #, well character, the corresponding hexadecimal number is 23H, and
  the middle of the command packet is no more than 7. Porter Rate, such as string 9600 or 921600, etc.,
  the tail byte of the command packet must be _, underscore, the corresponding hexadecimal number is 5FH,
  that is, the baud rate to be set is placed as a string in # Between the character and the _ character, as a command packet,
  sent to the CH341 serial port at 300bps, it will be interpreted by the CH341 driver as modifying the baud rate of the CH341,
  and will not be actually sent as data from the serial port. After successful return, the
  CH341 actually works at the specified new baud rate. Of course, the computer system and serial port control still think it is working at 300bps.
  If you need to change the baud rate again in this way, you should first use the conventional method to convert the CH341. The baud rate is set to 300bps.

For example, use the serial port monitoring/debugging tool software to demonstrate:
1. Select the baud rate of the CH341 serial port to 300bps (some tool software must re-open the serial port after selecting the baud rate),
   issue the string command packet, which is 6 ASCII codes. Data: #9600_
   After successful transmission, CH341 will actually work at 9600bps
2. Select the baud rate of CH341 serial port as 300bps (some tool software must re-open the serial port after selecting the baud rate),
   issue string command packet, which is 8 ASCII code data: #460800_
   After successful transmission, CH341 will actually work at 460800bps
3. Select the baud rate of CH341 serial port as 300bps (some tool software must re-open the serial port after selecting the baud rate),
   issue string command packet , for 9 ASCII code data: #1000000_
   After successful transmission, CH341 will actually work at 1000000bps

CH341 serial port supports 50bps to 2Mbps baud rate, when the application requests CH341 to change the serial communication baud rate,
CH341 driver will be baud baud rate divisor is converted, and then modify the interior of the CH341 baud rate divisor registers,
theset communication baud-rate real CH341 Is provided on the inside of the CH341 baud rate divisor registers,
since the internal reference CH341 serial bit clock is 48/8 = 6MHz (or 12MHz), and only supports integer divisor baud rate,
the baud rate so specified should Considering the actual conversion error, the calculation method when the baud rate is greater than 19200 bps is:
    X = 6000000 The value after dividing by the baud rate
    Y = X The valueafter rounding
    error= ( Y - X ) / X The

following is commonly used for CH341 support. The baud rate, unspecified reference bit clock is 6MHz, the unspecified error is less than 0.16%
    921600 (12MHz), 460800, 307200 (12MHz),
    230400, 153600, 128000 (0.27%), 115200,
    76800, 57600, 56000, 38400, 33600,
    28800, 19200, 14400, 9600, 7200,
    4800, 3600, 2400, 1800, 1200,
    900, 600, 300, 150, 134.5,
    110, 100, 75, 50, 2000000,
    1500000, 1200000, 1000000, 750000, 500000,
    375000, 250000, 200000, 187500, 100000,
    93750, 75000, 50000, 25000, 10000
Other baud rates As long as the error is less than 2.5%, CH341 can support, and the error of both ends should be considered when calculating the error. .
However, for reliable communication, it is recommended not to use a baud rate with an error greater than 1%.

************************************************** *****************************
USB device driver and emulation serial port driver

CH341 serial port hardware default driver is emulation serial port driver ,
i.e. more than a serial port on the computer end and the lower end of the CH341 crew use serial communication.
The computer-side application realizes USB data transmission by operating the simulation serial port, and its usage is the same as that of the ordinary serial port.

If you don't want to emulate the serial port on the computer side, you can use the USB device driver,is,
thata USB device is added to the computer, but the CH341 chip still uses serial communication on the lower computer.
The computer-side application implements USB data transmission by calling the API provided by the DLL.
Its usage is similar to that of the CH341 parallel port, CH372, CH375, and can refer to the source program of the related application.

The USB device driver of the CH341 serial port hardware is identical to the USB device driver CH341PAR of the parallel port hardware. The
only difference is that the PID in the driver installation information file INF is different (refer to the comment line description in the INF of CH341PAR).

************************************************** *****************************

