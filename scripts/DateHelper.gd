extends Node


func str_to_date(date_str: String) -> Dictionary:
	var date_and_time := date_str.split("T", false)
	var ymd_data := date_and_time[0].split("-", false)
	return {
		"day": int(ymd_data[2]),
		"month": int(ymd_data[1]),
		"year": int(ymd_data[0]),
	}


func date_to_str(date: Dictionary) -> String:
	# This format is used in other versions of this program
	return "%04d-%02d-%02dT00:00:00+2:00" % [date["year"], date["month"], date["day"]]


func days_since(date: String) -> int:
	var today_date := OS.get_datetime()
	return date_to_days(today_date) - date_to_days(str_to_date(date))


func date_to_days(date: Dictionary) -> int:
	# Not exact! Roughly is good enough for this program
	var years_to_days : float = date["year"] * 365.25
	var months_to_days := months_to_days(date["month"])
	var total_days : float = years_to_days + months_to_days + date["day"]
	return int(total_days)
	
	
func months_to_days(month: int) -> int:
	# Not exact! Roughly is good enough for this program
	var days := 0
	for i in range(1, month + 1):
		match i:
			1, 3, 5, 7, 8, 10, 12:
				days += 31
			4, 6, 9, 11:
				days += 30
			2:
				days += 28
	return days
