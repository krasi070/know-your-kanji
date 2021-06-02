extends MenuButton

signal opened_window

var popup
var add_kanji_scene : PackedScene
var list_kanji_scene : PackedScene

func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_item_pressed")
	add_kanji_scene = preload("res://scenes/AddKanjiWindow.tscn")
	list_kanji_scene = preload("res://scenes/ListKanjiWindow.tscn")


func _on_item_pressed(ID: int) -> void:
	match popup.get_item_text(ID):
		"Add":
			add_kanji()
		"Edit":
			edit_kanji()
		"List":
			list_kanji()
		"Search":
			search_kanji()
		_:
			show_error_dialog()


func add_kanji() -> void:
	var instance = add_kanji_scene.instance()
	emit_signal("opened_window", instance, "AddKanji")
	

func edit_kanji() -> void:
	pass
	
	
func list_kanji() -> void:
	var instance = list_kanji_scene.instance()
	emit_signal("opened_window", instance, "ListKanji")
	
	
func search_kanji() -> void:
	pass
	
	
func show_error_dialog() -> void:
	pass
