from ib_insync import *
ib = IB()

f = open("ignore/ip", "r")
ip = f.read()

f = open("ignore/port", "r")
port = int(f.read())

ib.connect(ip, 4001, clientId=1)

contract = Stock('AMD', 'SMART', 'USD')

bars = ib.reqHistoricalData(
    contract, endDateTime='', durationStr='30 D',
    barSizeSetting='1 hour', whatToShow='MIDPOINT', useRTH=True)

# convert to pandas dataframe:
df = util.df (bars)
print(df)