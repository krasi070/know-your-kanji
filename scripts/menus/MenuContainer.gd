extends HBoxContainer


func _ready():
	# Change font in all popup menus
	for node in get_tree().get_nodes_in_group("menus"):
		node.theme = Theme.new()
		node.theme.default_font = DynamicFont.new()
		node.theme.default_font.font_data = load("res://assets/fonts/KosugiMaru-Regular.ttf")
