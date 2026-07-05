class_name HandManager extends Node2D

var selected_card: Card = null
var hovered_card: Card = null

var mouse_area: Area2D

func _ready():
	mouse_area = get_node("Area2D")

func _physics_process(_delta):
	mouse_area.global_position = get_global_mouse_position()
	
	var overlaps = mouse_area.get_overlapping_areas()

	var top_card: Card = null
	var highest_z := -INF

	for area in overlaps:
		var card := area.get_parent() as Card
		if card.z_index > highest_z:
			highest_z = card.z_index
			top_card = card

	if top_card != hovered_card:
		if hovered_card:
			hovered_card.set_hovered(false)

		hovered_card = top_card

		if hovered_card:
			hovered_card.set_hovered(true)
