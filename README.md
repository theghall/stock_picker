This pretends to know the stock prices over a period of time.  It will pick the quickest route to profit if there
is one (It will catch the case if the price does not rise over the period. This went a little beyond what the project
asked for as it does not just find the first pair of days to buy/sell, but also handles if there is more than one day with
the max price. So, for 1,7,1,1,7  the output will be:

For quickest profit buy on day 1 at $1/share and sell on day 2 at $7/share

Other days to buy/sell
Buy on day 3 at $1/share and sell on day 5 at $7/share (should not report this but I need to move on)
Buy on day 4 at $1/share and sell on day 5 at $7/share

When run it will ask you to input a comma-delimited list of stock prices.  
