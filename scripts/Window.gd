extends MarginContainer

var curr_window : String


func _ready():
	$"../MenuContainer/Reviews".connect(
			"opened_window", self, "open_window")
	$"../MenuContainer/Kanji".connect(
			"opened_window", self, "open_window")


func open_window(window, window_name) -> void:
	# Only open new window if it is differen from the currently open one
	if curr_window != window_name:
		free_children()
		add_child(window)
		curr_window = window_name


func free_children() -> void:
	var children = get_children()
	for i in range(children.size()):
		children[i].queue_free()
