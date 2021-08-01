extends ScrollContainer

const PAGE_SIZE := 10

var page := 1
var last_page : int
var kanji_manager
var kanji_arr : Array
var list_item_scene : PackedScene
var page_controls_scene : PackedScene

onready var container := $ListContainer


func _ready():
	kanji_manager = load("res://scripts/KanjiManager.gd").new()
	list_item_scene = preload("res://scenes/ListItem.tscn")
	page_controls_scene = preload("res://scenes/PageControls.tscn")


func search(query: String):
	var results : Array = kanji_manager.search(query)
	for kanji in results:
		var data := {
			"kanji": kanji["Kanji"], 
			"meanings": kanji["Meaning"], 
			"correctness": kanji["CorrectPercentage"], 
			"weight": kanji["Weight"],
		}
		kanji_arr.append(data)
	last_page = kanji_arr.size() / PAGE_SIZE
	if kanji_arr.size() % PAGE_SIZE > 0:
		last_page += 1
	_show_page()


func _show_page() -> void:
	# Check that page is valid
	if page < 1 or page > last_page:
		return
	# Check if pages are necessary
	var page_controls_instance
	if kanji_arr.size() > PAGE_SIZE:
		page_controls_instance = page_controls_scene.instance()
		page_controls_instance.get_node("PageNumber").text = "Page %d" % page
	# Set start and end indexes
	var start := (page - 1) * PAGE_SIZE
	var end := min(start + PAGE_SIZE, kanji_arr.size())
	# Remove previous list items
	_empty()
	# Show this page's kanji
	for i in range(start, end):
		_add_list_item(kanji_arr[i])
	# Add page controls
	if page_controls_instance != null:
		container.add_child(page_controls_instance)
		var next = page_controls_instance.get_node("Next")
		if page == last_page:
			next.disabled = true
		else:
			next.disabled = false
			next.connect("button_up", self, "_next_page")
		var previous = page_controls_instance.get_node("Previous")
		if page == 1:
			previous.disabled = true
		else:
			previous.disabled = false
			previous.connect("button_up", self, "_previous_page")


func _next_page() -> void:
	page = min(page + 1, last_page)
	self.scroll_vertical = 0
	self.update()
	_show_page()


func _previous_page() -> void:
	page = max(page - 1, 1)
	self.scroll_vertical = 0
	self.update()
	_show_page()


func _add_list_item(data: Dictionary):
	var instance := list_item_scene.instance()
	instance.set_data(data)
	container.add_child(instance)


func _empty():
	var children = container.get_children()
	for i in range(children.size()):
		children[i].queue_free()
