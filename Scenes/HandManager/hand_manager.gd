class_name HandManager extends Node2D

@onready var card_scene = preload("res://Scenes/Card/card.tscn")

var selected_card: Card = null
var hovered_card: Card = null

var hand: Array[Card] = []

const CARD_WIDTH = 40
const HAND_SIZE = 20
const HAND_WIDTH = CARD_WIDTH * 10

func _ready():
	_generate_hand()
		
func _generate_hand():
	var start_x = -HAND_WIDTH/2
	var start_y = 40
	var x_off = HAND_WIDTH/HAND_SIZE
	
	for idx in HAND_SIZE:
		var card = card_scene.instantiate()
		add_child(card)
		
		card.global_position = Vector2(start_x + idx * x_off, start_y)
