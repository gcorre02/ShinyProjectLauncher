library(stats)
library(tseries)
library(stockPortfolio)

sp500Tickers = as.matrix((read.csv("~/sp500list.csv"))$Sym[-354])[,1]
ticker = sp500Tickers
#this takes a while, hence why it shouldnt be done often, max once at the beginning of the test session´1
acquiredStocks = getReturns(ticker, freq = "day", get = c("overlapOnly"), end = "2014-07-20", start = "2012-01-01")
