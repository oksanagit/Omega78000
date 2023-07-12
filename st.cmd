#!/epics/devel/support/modbus/bin/linux-x86_64/modbusApp
< envPaths
< /epics/common/mobile4-netsetup.cmd

dbLoadDatabase("/epics/devel/support/modbus/dbd/modbusApp.dbd")
modbusApp_registerRecordDeviceDriver(pdbbase)
# Use the following commands for serial RTU or ASCII
#drvAsynSerialPortConfigure(const char *portName,
#                           const char *ttyName,
#                           unsigned int priority,
#                           int noAutoConnect,
#                           int noProcessEos);
##drvAsynSerialPortConfigure("CN78x", "/dev/omega9000", 0, 0, 0)
drvAsynSerialPortConfigure("CN78x", "/dev/ttyUSB0", 0, 0, 0)
asynSetOption("CN78x",0,"baud","9600")
asynSetOption("CN78x",0,"parity","odd")
asynSetOption("CN78x",0,"bits","7")
asynSetOption("CN78x",0,"stop","2")



# Use the following commands for serial ASCII
asynOctetSetOutputEos("CN78x",0,"\r\n")
asynOctetSetInputEos("CN78x",0,"\r\n")
# Note: non-zero write delay (last parameter) may be needed.
modbusInterposeConfig("CN78x",2,1000,0)

drvModbusAsynConfigure("CN78x_Word_In",     "CN78x", 1, 3, 4096, 8,    0,  100, "Omega")
drvModbusAsynConfigure("CN78x_Word_In_SP",  "CN78x", 1, 3, 4097, 8,    0,  100, "Omega")
drvModbusAsynConfigure("CN78x_Word_Out",     "CN78x", 1, 6, 4097, 8,    0,  100, "Omega")

# Enable ASYN_TRACEIO_HEX on modbus server
asynSetTraceIOMask("CN78x",0,4)
# Enable all debugging on modbus server
# asynSetTraceMask("CN78x",0,255)
# Dump up to 512 bytes in asynTrace
asynSetTraceIOTruncateSize("CN78x",0,512)

dbLoadTemplate("CN78x.substitutions")
dbLoadDatabase("CN78x_calc.db")

iocInit


