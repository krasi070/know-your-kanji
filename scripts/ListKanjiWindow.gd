extends VBoxContainer

const FORMAT := " %d %s %1.2f%% [%d/%d/%d] (%1.2f)"
const PAGE_SIZE := 50

var page := 1
var last_page : int
var kanji_manager
var kanji_arr : Array 


func _ready():
	# Load kanji data array
	kanji_manager = load("res://scripts/KanjiManager.gd").new()
	kanji_arr = kanji_manager.get_sorted_kanji_arr()
	# Set last page
	last_page = kanji_arr.size() / PAGE_SIZE
	if kanji_arr.size() % PAGE_SIZE > 0:
		last_page += 1
	# Connect button signals
	$PageControls/Next.connect("button_up", self, "next_page")
	$PageControls/Previous.connect("button_up", self, "previous_page")
	show_page()
	

func show_page() -> void:
	# Check that page is valid
	if page < 1 or page > last_page:
		return
	# Set start and end indexes
	var start := (page - 1) * PAGE_SIZE
	var end := min(start + PAGE_SIZE, kanji_arr.size())
	# Update texts
	$KanjiList.text = ""
	$PageControls/PageNumber.text = "Page %d" % page
	# Show this page's kanji
	for i in range(start, end):
		var kanji = kanji_arr[i]
		var args = [
			i + 1, 
			kanji["Kanji"], 
			kanji["CorrectPercentage"],
			kanji["Correct"],
			kanji["Wrong"],
			kanji["Correct"] + kanji["Wrong"],
			kanji["Weight"]]
		$KanjiList.text += FORMAT % args
		if i != end - 1:
			$KanjiList.text += "\n"


func next_page() -> void:
	page = min(page + 1, last_page)
	show_page()


func previous_page() -> void:
	page = max(page - 1, 1)
	show_page()
