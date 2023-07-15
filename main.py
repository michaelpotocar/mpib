from ib_insync import *
ib = IB()

f = open("ignore/ip", "r")
ip = f.read()

f = open("ignore/port", "r")
port = int(f.read())

ib.connect(ip, port, clientId=1)

msft_option_contract = Option('MSFT', '20230721', 350, 'C', 'SMART')
ib.qualifyContracts(msft_option_contract)
# details = ib.reqContractDetails(msft_option_contract)
msft_option_order = MarketOrder('BUY', 1)
msft_option_trade = ib.placeOrder(msft_option_contract, msft_option_order)

msft = Stock('MSFT', 'SMART', 'USD')
ib.qualifyContracts(msft)
chains = ib.reqSecDefOptParams(msft.symbol, '', msft.secType, msft.conId)

time.sleep(0)
# bars = ib.reqHistoricalData(
#     msft_option_contract, endDateTime='', durationStr='1 D',
#     barSizeSetting='1 hour', whatToShow='MIDPOINT', useRTH=True)

# df = util.df (bars)
# print(df)

ib.disconnect()