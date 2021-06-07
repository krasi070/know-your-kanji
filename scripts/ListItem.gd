extends Panel

var data : Dictionary

onready var kanji := $ItemContainer/KanjiArea/KanjiContainer/Kanji
onready var meanings := $ItemContainer/TwoLineDescription/MeaningsLabel
onready var correctness := $ItemContainer/TwoLineDescription/VBoxContainer/CorrectnessLabel
onready var weight := $ItemContainer/TwoLineDescription/VBoxContainer/WeightLabel
onready var edit_button := $ItemContainer/ButtonContainer/Edit
onready var delete_button := $ItemContainer/ButtonContainer/Delete


func _ready():
	kanji.text = data["kanji"]
	meanings.text = data["meanings"]
	correctness.text = "Correctness: %0.2f" % data["correctness"]
	weight.text = "Weight: %0.2f" % data["weight"]


func set_data(list_item_data: Dictionary) -> void:
	data = list_item_data
