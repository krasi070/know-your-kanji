extends VBoxContainer

var kanji_manager

onready var kanji_input := $InputPanel/CenterContainer/InputContainer/KanjiInputField/LineEdit
onready var meaninings_input := $InputPanel/CenterContainer/InputContainer/MeaningsInputField/TextEdit


func _ready():
	kanji_manager = load("res://scripts/KanjiManager.gd").new()
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
	var json_text = kanji_manager.read_file()
	var json_parse_result = JSON.parse(json_text).result
	var json : Array = json_parse_result if json_parse_result != null else []
	var kanji_json_data : Dictionary = kanji_manager.create_json_kanji_data(kanji, meanings)
	json.append(kanji_json_data)
	# Save it into the file
	return kanji_manager.save_kanji_arr(json)


func open_dialog(title: String, msg: String) -> void:
	$MessageDialog.window_title = title
	$MessageDialog/MessageLabel.text = msg
	$MessageDialog.popup()
