extends MarginContainer

var curr_window : String
var add_kanji_scene : PackedScene
var review_scene : PackedScene

onready var review_button := $"../MenuContainer/LeftContainer/Review"
onready var add_kanji_button := $"../MenuContainer/LeftContainer/AddKanji"


func _ready():
	review_scene = preload("res://scenes/ReviewWindow.tscn")
	review_button.connect(
			"button_up", self, "open_window", [review_scene, "Review", review_button])
	add_kanji_scene = preload("res://scenes/AddKanjiWindow.tscn")
	add_kanji_button.connect(
			"button_up", self, "open_window", [add_kanji_scene, "Add Kanji", add_kanji_button])


func open_window(scene: PackedScene, window_name: String, button: Button) -> void:
	# Only open new window if it is differen from the currently open one
	if curr_window != window_name:
		free_children()
		var instance := scene.instance()
		add_child(instance)
		curr_window = window_name


func free_children() -> void:
	var children = get_children()
	for i in range(children.size()):
		children[i].queue_free()
