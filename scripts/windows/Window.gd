extends MarginContainer

const PATH_TO_OPEN := "user://"

var curr_window : String
var add_kanji_scene : PackedScene
var review_scene : PackedScene
var search_scene : PackedScene

onready var review_button := $"../MenuContainer/LeftContainer/Review"
onready var add_kanji_button := $"../MenuContainer/LeftContainer/AddKanji"
onready var search_button := $"../MenuContainer/RightContainer/SearchButton"
onready var open_file_button := $"../MenuContainer/LeftContainer/OpenFile"
onready var search_bar := $"../MenuContainer/RightContainer/SearchBar"


func _ready():
	# Review window set-up
	review_scene = preload("res://scenes/ReviewWindow.tscn")
	review_button.connect(
			"button_up", self, "_open_window", [review_scene, "Review"])
	# Add kanji window set-up
	add_kanji_scene = preload("res://scenes/AddKanjiWindow.tscn")
	add_kanji_button.connect(
			"button_up", self, "_open_window", [add_kanji_scene, "Add Kanji"])
	# Search window set-up
	search_scene = preload("res://scenes/SearchWindow.tscn")
	search_button.connect("button_up", self, "_open_search_window")
	# Open file set-up
	open_file_button.connect("button_up", self, "_open_file")
	

func _open_window(scene: PackedScene, window_name: String) -> void:
	# Only open new window if it is differen from the currently open one
	if curr_window != window_name:
		_free_children()
		var instance := scene.instance()
		add_child(instance)
		curr_window = window_name


func _open_search_window() -> void:
	_free_children()
	var instance := search_scene.instance()
	add_child(instance)
	curr_window = "Search"
	instance.search(search_bar.text)


func _open_file() -> void:
	var globalized_path := ProjectSettings.globalize_path(PATH_TO_OPEN)
	OS.shell_open(globalized_path)


func _free_children() -> void:
	var children = get_children()
	for i in range(children.size()):
		children[i].queue_free()
