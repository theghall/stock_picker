#!/usr/bin/ruby
# 
# stock_picker.rb
#
# Picks best day to buy and sell from a list of prices
#
# 20170202	GH	Created
# 20170203	GH	Solved
#

def min_hash(prices)
	  prices_copy = prices.dup
		min_price = prices_copy.min
		min_price_indices =  prices_copy.each_index.select{|i| prices_copy[i] == min_price}

		# Need to get min day that is not the last day
		if min_price_indices.length == 1 && min_price_indices[0] == prices_copy.length - 1
			prices_copy.pop
			min_hash(prices_copy)
		else
	    min_hash =  { "min_price"=> min_price, "min_price_indices" => min_price_indices}
		end
end

def max_hash(prices)
	prices_copy = prices.dup

	max_price = prices_copy.max
	max_price_indices =  prices_copy.each_index.select{|i| prices_copy[i] == max_price}
	
	# Need to get max day that is not the first day
	if max_price_indices.length == 1 && max_price_indices[0] == 0
		prices_copy.shift
		max_hash(prices_copy)
	else
    max_hash =  { "max_price" => max_price, "max_price_indices" => max_price_indices}
	end

end

def print_profit_days(prices, min_hash, max_hash)

	optimal_days = []
	other_days = []
	optimal_diff = prices.length + 1 

	min_hash_arr = min_hash["min_price_indices"]
	max_hash_arr = max_hash["max_price_indices"]

	max_hash_arr_len = max_hash_arr.length

	# pair up min/max days into optimal days (shortest time to profit)
	# and other days where there are duplicate highs and lows
	# otherwise there will be only one set of days where there is only
	# one unique low and one unique high
	min_hash_arr.each do |min_day|
		found_sell_day = false

		max_day_index = 0

		while !found_sell_day && max_day_index < max_hash_arr.length do
			max_day = max_hash_arr[max_day_index]

			if max_day > min_day

				day_diff = max_day - min_day

				if day_diff < optimal_diff
					optimal_diff = day_diff

					if !optimal_days.empty?
						other_days += optimal_days
						optimal_days = []
					end

					optimal_days << min_day
					optimal_days << max_day
				else

					other_days << min_day
					other_days << max_day
				end

				found_sell_day = true
			end

			max_day_index += 1
		end
	end				

	if !optimal_days.empty? then
		opt_buy_date = optimal_days[0]
		opt_sell_date = optimal_days[1]
		opt_buy_price = prices[opt_buy_date]
		opt_sell_price = prices[opt_sell_date]

		puts "For quickest profit buy on day #{opt_buy_date+1} at $#{opt_buy_price}/share and sell on day #{opt_sell_date+1} at $#{opt_sell_price}/share"

		if !other_days.empty?

			puts "\nOther days to buy/sell"

			index = 0

			while index < other_days.length do
				buy_date = other_days[index]
				buy_price = prices[buy_date]
				sell_date = other_days[index+1]
				sell_price = prices[sell_date]
	
				puts "Buy on day #{buy_date+1} at $#{buy_price}/share and sell on day #{sell_date+1} at $#{sell_price}/share"

				index += 2
			end
		end
	end
end

def stock_picker(prices)

	min_hash = min_hash(prices)
	max_hash = max_hash(prices)

	if min_hash["min_price"] == max_hash["max_price"] 
		puts "The stock price does not rise in the given period."
	else
			print_profit_days(prices, min_hash, max_hash)
	end

end

def valid_stock_arr?(array)
	# if any non-numeric characters excper for ',' or a zero stock value then its not valid 
	!(array =~ /[^0-9 ,]/) && !(array =~ /^0[ ,]/) && !(array =~ /[ ,]0[ ,]/)  && !(array =~ /[,]0$/)
end

valid_input = false

while !valid_input do
	puts "Enter a list of comma delimited stock prices:"
	stock_prices = gets.chomp

	valid_input = valid_stock_arr?(stock_prices)
	puts "Please enter a comma delimited list of whole numbers.\n\n" if !valid_input

end

stock_prices = stock_prices.split(",").map(&:to_i)
stock_picker(stock_prices)


