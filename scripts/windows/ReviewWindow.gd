extends VBoxContainer

enum State {HIDE_KANJI, SHOW_KANJI, FINISHED_REVIEW}

const FINISHED_REVIEW_MSG = "Review Finished (￣▽￣)"

var state setget switch_state
var correct := 0
var wrong := 0
var left := 0
var review_amount := 2
var kanji_arr_index := -1
var kanji_manager
var date_helper
var kanji_arr : Array

onready var correct_counter := $Panel/CounterContainer/CorrectCount
onready var wrong_counter := $Panel/CounterContainer/WrongCount
onready var left_counter := $Panel/CounterContainer/LeftCount
onready var meanings_label := $Panel/MainContainer/Meanings
onready var kanji_label := $Panel/MainContainer/KanjiAnswer
onready var reveal_button := $Panel/MainContainer/Reveal
onready var correct_button := $ButtonContainer/Correct
onready var wrong_button := $ButtonContainer/Wrong


func _ready():
	# Prepare kanji to review
	kanji_manager = load("res://scripts/KanjiManager.gd").new()
	kanji_arr = kanji_manager.get_sorted_kanji_arr(review_amount)
	kanji_arr = randomize_arr(kanji_arr)
	left = review_amount
	go_to_next_kanji()
	# Add button signal connections
	reveal_button.connect("button_up", self, "switch_state", [State.SHOW_KANJI])
	correct_button.connect("button_up", self, "_on_Correct_button_up")
	wrong_button.connect("button_up", self, "_on_Wrong_button_up")
	switch_state(State.HIDE_KANJI)


func _on_Correct_button_up() -> void:
	correct += 1
	correct_counter.text = "Correct: %d" % correct
	kanji_manager.update_kanji_with_correct(kanji_arr[kanji_arr_index])
	go_to_next_kanji()
	
	
func _on_Wrong_button_up() -> void:
	wrong += 1
	wrong_counter.text = "Wrong: %d" % wrong
	kanji_manager.update_kanji_with_wrong(kanji_arr[kanji_arr_index])
	go_to_next_kanji()


func go_to_next_kanji() -> void:
	if left > 0:
		left -= 1
		kanji_arr_index += 1
		left_counter.text = "Left: %d" % left
		var kanji = kanji_arr[kanji_arr_index]
		kanji_label.text = kanji["Kanji"]
		meanings_label.text = kanji["Meaning"]
		switch_state(State.HIDE_KANJI)
	else:
		# No next kanji
		kanji_manager.save_kanji_arr()
		switch_state(State.FINISHED_REVIEW)


func switch_state(s) -> void:
	match s:
		State.HIDE_KANJI:
			hide_kanji()
			state = s
		State.SHOW_KANJI:
			show_kanji()
			state = s
		State.FINISHED_REVIEW:
			finish_review()
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


func finish_review() -> void:
	# Hide and disable reveal button
	reveal_button.hide()
	reveal_button.disabled = true
	# Hide kanji answer
	kanji_label.hide()
	# Hide and disable correct/wrong buttons
	$ButtonContainer.hide()
	correct_button.disabled = true
	wrong_button.disabled = true
	# Show finish review messages
	meanings_label.text = FINISHED_REVIEW_MSG


func open_dialog(title: String, msg: String) -> void:
	pass


func randomize_arr(arr: Array) -> Array:
	randomize()
	var rand_arr = []
	var indexes = range(arr.size())
	for i in range(arr.size()):
		var rand_index = randi() % indexes.size()
		rand_arr.append(arr[indexes[rand_index]])
		indexes.remove(rand_index)
	return rand_arr
