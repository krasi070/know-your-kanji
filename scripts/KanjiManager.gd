extends Node

const PATH := "res://data/kanji.json"

var kanji_arr : Array setget ,get_kanji_arr


func _init():
	load_kanji_arr()


func get_kanji_arr() -> Array:
	return kanji_arr


func get_sorted_kanji_arr() -> Array:
	var sorted = kanji_arr.duplicate(true)
	sorted.sort_custom(self, "kanji_weight_comparison")
	return sorted


func load_kanji_arr() -> void:
	var json := read_file()
	kanji_arr = JSON.parse(json).result


func add_kanji(kanji) -> void:
	kanji_arr.append(kanji)


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
	if file.open(PATH, File.WRITE) != OK:
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


func kanji_weight_comparison(a, b) -> bool:
	# Descending weight comparison
	return a["Weight"] > b["Weight"]
	
