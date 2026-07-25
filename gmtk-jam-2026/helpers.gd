extends Node
class_name FormatHelpers

static func money_str(number: int, include_dollar = true) -> String:
	var num_str := str(abs(number))
	var result := ""
	var length := num_str.length()
	
	for i in range(length):
		if i > 0 and (length - i) % 3 == 0:
			result += ","
		result += num_str[i]
	
	if include_dollar:
		return "$%s" % result
	
	return result
