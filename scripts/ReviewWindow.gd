extends VBoxContainer

enum State {HIDE_KANJI, SHOW_KANJI}

var state setget switch_state
var correct := 0
var wrong := 0
var left := 0

onready var correct_counter := $Panel/CounterContainer/CorrectCount
onready var wrong_counter := $Panel/CounterContainer/WrongCount
onready var left_counter := $Panel/CounterContainer/LeftCount
onready var meanings_label := $Panel/MainContainer/Meanings
onready var kanji_label := $Panel/MainContainer/KanjiAnswer
onready var reveal_button := $Panel/MainContainer/Reveal
onready var correct_button := $ButtonContainer/Correct
onready var wrong_button := $ButtonContainer/Wrong


func _ready():
	reveal_button.connect("button_up", self, "switch_state", [State.SHOW_KANJI])
	correct_button.connect("button_up", self, "_on_Correct_button_up")
	wrong_button.connect("button_up", self, "_on_Wrong_button_up")
	switch_state(State.HIDE_KANJI)


func _on_Correct_button_up() -> void:
	correct += 1
	correct_counter.text = "Correct: %d" % correct
	go_to_next_kanji()
	
	
func _on_Wrong_button_up() -> void:
	wrong += 1
	wrong_counter.text = "Wrong: %d" % wrong
	go_to_next_kanji()


func go_to_next_kanji() -> void:
	left -= 1
	left_counter.text = "Left: %d" % left
	switch_state(State.HIDE_KANJI)
	# Continue to next kanji


func switch_state(s) -> void:
	match s:
		State.HIDE_KANJI:
			hide_kanji()
			state = s
		State.SHOW_KANJI:
			show_kanji()
			state = s
		_:
			open_dialog("Error", "Tried to access an uknown state!")


func hide_kanji() -> void:
	# Show and enable reveal button
	reveal_button.show()
	reveal_button.disabled = false
	# Hide kanji answer
	kanji_label.hide()
	# Hide and disable correct/wrong buttons
	$ButtonContainer.hide()
	correct_button.disabled = true
	wrong_button.disabled = true


func show_kanji() -> void:
	# Hide and disable reveal button
	reveal_button.hide()
	reveal_button.disabled = true
	# Show kanji answer
	kanji_label.show()
	# Show and enable correct/wrong buttons
	$ButtonContainer.show()
	correct_button.disabled = false
	wrong_button.disabled = false


func open_dialog(title: String, msg: String) -> void:
	pass
