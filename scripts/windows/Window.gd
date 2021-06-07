extends MarginContainer

var curr_window : String
var add_kanji_scene : PackedScene
var review_scene : PackedScene
var search_scene : PackedScene

onready var review_button := $"../MenuContainer/LeftContainer/Review"
onready var add_kanji_button := $"../MenuContainer/LeftContainer/AddKanji"
onready var search_button := $"../MenuContainer/RightContainer/SearchButton"
onready var search_bar := $"../MenuContainer/RightContainer/SearchBar"


func _ready():
	# Review window set-up
	review_scene = preload("res://scenes/ReviewWindow.tscn")
	review_button.connect(
			"button_up", self, "open_window", [review_scene, "Review"])
	# Add kanji window set-up
	add_kanji_scene = preload("res://scenes/AddKanjiWindow.tscn")
	add_kanji_button.connect(
			"button_up", self, "open_window", [add_kanji_scene, "Add Kanji"])
	# Search window set-up
	search_scene = preload("res://scenes/SearchWindow.tscn")
	search_button.connect("button_up", self, "open_search_window")
	

func open_window(scene: PackedScene, window_name: String) -> void:
	# Only open new window if it is differen from the currently open one
	if curr_window != window_name:
		free_children()
		var instance := scene.instance()
		add_child(instance)
		curr_window = window_name


func open_search_window() -> void:
	free_children()
	var instance := search_scene.instance()
	add_child(instance)
	curr_window = "Search"
	instance.search(search_bar.text)


func free_children() -> void:
	var children = get_children()
	for i in range(children.size()):
		children[i].queue_free()
