extends VBoxContainer

const PATH := "res://data/kanji.json"

var kanji_input
var meaninings_input


func _ready():
	kanji_input = $InputPanel/InputContainer/KanjiInputRow/LineEdit
	meaninings_input = $InputPanel/InputContainer/MeaningsInputRow/LineEdit
	$AddButton.connect("button_up", self, "_on_AddButton_button_up")


func _on_AddButton_button_up() -> void:
	# Check if the kanji input is valid
	var kanji = kanji_input.text
	if kanji == "":
		open_dialog("Error", "The kanji field has been left empty!")
		return
	# Check if the meanings input is valid
	var meanings = meaninings_input.text
	if meanings == "":
		open_dialog("Error", "The meanings field has been left empty!")
		return
	# Show success message if successful
	if add_kanji(kanji, meanings):
		open_dialog("Success", "%s has been successfully added!" % kanji)
		kanji_input.text = ""
		meaninings_input.text = ""
		return
	# Show error message if an error occurred
	open_dialog(
			"Error", 
			"Could not add kanji %s with meanings: %s" % [kanji, meanings])
	
	
func add_kanji(kanji: String, meanings: String) -> bool:
	# Get the data from the file and add the new kanji
	var json_text = read_file(PATH)
	var json : Array = JSON.parse(json_text).result
	var kanji_json_data := create_json_kanji_data(kanji, meanings)
	json.append(kanji_json_data)
	# Convert json into string and save it into the file
	var new_json_text := JSON.print(json)
	return write_file(PATH, new_json_text)


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


func write_file(path: String, data: String) -> bool:
	var file := File.new()
	# Check if file exists and can be written in
	if file.open(path, File.WRITE) != OK:
		return false
	file.store_string(data)
	file.close()
	return true


func read_file(path: String) -> String:
	var file := File.new()
	# Check if file exists and can be read
	if file.open(path, File.READ) != OK:
		return ""
	var content := file.get_as_text()
	file.close()
	return content


func open_dialog(title: String, msg: String) -> void:
	$MessageDialog.window_title = title
	$MessageDialog/MessageLabel.text = msg
	$MessageDialog.popup()
