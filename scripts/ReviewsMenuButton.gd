extends MenuButton

signal opened_window

var popup
var kanji_review_scene : PackedScene


func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_item_pressed")
	kanji_review_scene = preload("res://scenes/ReviewWindow.tscn")


func _on_item_pressed(ID: int) -> void:
	match popup.get_item_text(ID):
		"Kanji Review":
			review_kanji()
		"Word Review":
			review_words()
		_:
			show_error_dialog()


func review_kanji() -> void:
	var instance = kanji_review_scene.instance()
	emit_signal("opened_window", instance, "Kanji Review")


func review_words() -> void:
	pass


func show_error_dialog() -> void:
	pass
