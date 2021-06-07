extends Node

const PATH := "user://kanji.json"

var kanji_arr : Array setget rewrite_kanji_arr, get_kanji_arr
var date_helper


func _init():
	date_helper = preload("res://scripts/DateHelper.gd").new()
	load_kanji_arr()


func get_kanji_arr() -> Array:
	return kanji_arr


func get_sorted_kanji_arr(amount: int = 0) -> Array:
	var sorted = kanji_arr.duplicate(false)
	sorted.sort_custom(self, "_kanji_weight_comparison")
	if amount > 0:
		return sorted.slice(0, amount - 1)
	return sorted


func rewrite_kanji_arr(new_arr: Array) -> void:
	kanji_arr = new_arr


func load_kanji_arr() -> void:
	var json := read_file()
	var json_parse_result = JSON.parse(json).result
	kanji_arr = json_parse_result if json_parse_result != null else []
	update_weights()


func save_kanji_arr(arr: Array = []) -> bool:
	var json_text := JSON.print(kanji_arr) if arr == [] else JSON.print(arr)
	return write_file(json_text)


func add_kanji(kanji) -> void:
	kanji_arr.append(kanji)


func search(query: String) -> Array:
	var results := []
	query = query.to_lower()
	for kanji in kanji_arr:
		if kanji["Kanji"] == query or _meaning_starts_with(kanji["Meaning"], query):
			results.append(kanji)
	return results


func create_json_kanji_data(kanji: String, meanings: String) -> Dictionary:
	return {
		"Kanji": kanji,
		"Meaning": meanings,
		"LastReview": "0001-01-01T00:00:00",
		"LastMistake": "0001-01-01T00:00:00",
		"Appearances": 0,
		"Correct": 0,
		"Wrong": 0,
		"Weight": 1000.0,
		"CorrectPercentage": 0.0,
	}


func write_file(data: String) -> bool:
	var file := File.new()
	# Check if file exists and can be written in
	var response = file.open(PATH, File.WRITE)
	if not(response == OK or response == ERR_FILE_NOT_FOUND):
		return false
	file.store_string(data)
	file.close()
	return true


func read_file() -> String:
	var file := File.new()
	# Check if file exists and can be read
	if file.open(PATH, File.READ) != OK:
		return ""
	var content := file.get_as_text()
	file.close()
	return content


func update_weights() -> void:
	for i in range(kanji_arr.size()):
		kanji_arr[i]["Weight"] = _calculate_weight(kanji_arr[i])


func update_kanji_with_correct(kanji: Dictionary) -> void:
	kanji["Correct"] += 1
	kanji["LastReview"] = date_helper.date_to_str(OS.get_datetime())
	kanji["Appearances"] += 1
	kanji["CorrectPercentage"] = 100 * kanji["Correct"] / kanji["Appearances"]
	kanji["Weight"] = _calculate_weight(kanji)


func update_kanji_with_wrong(kanji: Dictionary) -> void:
	kanji["Wrong"] += 1
	kanji["LastReview"] = date_helper.date_to_str(OS.get_datetime())
	kanji["LastMistake"] = date_helper.date_to_str(OS.get_datetime())
	kanji["Appearances"] += 1
	kanji["CorrectPercentage"] = 100 * kanji["Correct"] / kanji["Appearances"]
	kanji["Weight"] = _calculate_weight(kanji)


func _meaning_starts_with(meaning_text: String, text: String) -> bool:
	var meanings := meaning_text.split(", ", false)
	for meaning in meanings:
		if meaning.to_lower().begins_with(text):
			return true
	return false


func _calculate_weight(kanji: Dictionary) -> float:
	# Calculate helper variables
	var days_since_last_mistake : int = date_helper.days_since(kanji["LastMistake"])
	var days_since_last_review : int = date_helper.days_since(kanji["LastReview"])
	var appearance_weight : float = \
			100 if kanji["Appearances"] == 0 else 100 / kanji["Appearances"]
	var wrongness_percentage : float = \
			100 * kanji["Wrong"] / kanji["Appearances"] if kanji["Appearances"] > 0 else 0
	# Calculate weight
	return 100 / max(days_since_last_mistake, 1000) * 2 + \
			days_since_last_review * 1.5 + \
			wrongness_percentage * 2 + \
			appearance_weight


func _kanji_weight_comparison(a, b) -> bool:
	# Descending weight comparison
	return a["Weight"] > b["Weight"]
