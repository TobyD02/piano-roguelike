class_name HandManager extends Node2D

@onready var card_scene = preload("res://Scenes/Card/card.tscn")

var selected_cards_rect: Rect2
var hand_rect: Rect2

var selected_cards: Array[Card] = [] # selected_cards[Position] = Card
var hovered_card: Card = null

@export var hand_score_label: Label

var max_cards_selected: int = 15

var hand: Array[Card] = []

const CARD_WIDTH = 40
const CARD_HEIGHT = 35
const HAND_SIZE = 40
const HAND_WIDTH = CARD_WIDTH * 10

const test_chords = [
	# Triad
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G],

	# 6th
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A],

	# 7th
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_B], # Cmaj7
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP], # C7 (B♭)

	# 9th
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_B, Note.NoteEnum.NOTE_D], # Cmaj9
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_D], # C9

	# 11th
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_B, Note.NoteEnum.NOTE_D, Note.NoteEnum.NOTE_F], # Cmaj11
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_D, Note.NoteEnum.NOTE_F], # C11

	# 13th
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_B, Note.NoteEnum.NOTE_D, Note.NoteEnum.NOTE_F, Note.NoteEnum.NOTE_A], # Cmaj13
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_D, Note.NoteEnum.NOTE_F, Note.NoteEnum.NOTE_A], # C13

	# Suspended chords
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_F, Note.NoteEnum.NOTE_G], # Csus4
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D, Note.NoteEnum.NOTE_G], # Csus2

	# Added tone chords
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_D], # Cadd9
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_F], # Cadd11
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A], # Cadd6

	# Altered dominant colours
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_C_SHARP], # C7#9
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_D_SHARP], # C7#5 / C7#11 colour
	[Note.NoteEnum.NOTE_C, Note.NoteEnum.NOTE_D_SHARP, Note.NoteEnum.NOTE_G, Note.NoteEnum.NOTE_A_SHARP, Note.NoteEnum.NOTE_D], # C7b9
]

func _ready():
	
	var width = (get_window().size.x / 2 - CARD_WIDTH * 2) * 0.75
	var left_side = -(width / 2)
	var bottom = get_window().size.y / 4 - CARD_HEIGHT	
	
	selected_cards_rect = Rect2(
		left_side, # x pos 
		bottom - (CARD_HEIGHT * 3), # y pos 
		width, # width
		CARD_HEIGHT # height
	)
	
	hand_rect = Rect2(
		left_side, # x pos
		bottom - CARD_HEIGHT, # y pos
		width, # width
		CARD_HEIGHT # height
	)

	_generate_hand()
		
	
func _generate_chord(card: Card, idx: int = -1):
	
	var chord = test_chords[randi_range(0, test_chords.size() - 1)]
	if idx != -1:
		chord = test_chords[idx % test_chords.size() - 1]
	
	for note in chord:
		card.set_card_note(note, true)
		
		
func _generate_hand():
	var start_x = -HAND_WIDTH/2
	var start_y = 40
	var x_off = HAND_WIDTH/HAND_SIZE
	
	for idx in HAND_SIZE:
		var card = card_scene.instantiate()
		add_child(card)
		
		card.connect(Card.CARD_SELECTED_SIGNAL, _on_card_selected)
		hand.append(card)
		
		_sort_hand()
		#_generate_chord(card, idx)
		
func _on_card_selected(card: Card):
	if (hand.find(card) != -1) and (selected_cards.size() < max_cards_selected):
		hand.remove_at(hand.find(card))
		selected_cards.append(card)
		#card.global_position = selected_cards_rect.position + Vector2(40 * selected_cards.size(), 0)
	elif (selected_cards.find(card) != -1):
		selected_cards.remove_at(selected_cards.find(card))
		hand.append(card)
		
		
	var selected_cards_notes: Dictionary[Note.NoteEnum, bool] = {}
	if selected_cards.size() != 0:
		for selected in selected_cards:
			for note in selected.card_note_controller.notes_pressed:
				if selected.card_note_controller.notes_pressed[note]:
					selected_cards_notes[note] = true
		
	print(selected_cards_notes)
	hand_score_label.text = HarmonicAnalysis.Chord.from_notes_pressed(selected_cards_notes).get_common_name()
	
	_sort_selected()
	_sort_hand()

func _sort_hand():
	var start_x = hand_rect.position.x
	var start_y = hand_rect.position.y
	var x_off = hand_rect.size.x / hand.size()
	
	_sort_cards_in_array(hand, start_x, start_y, x_off)

func _sort_selected():
	var start_x = selected_cards_rect.position.x
	var start_y = selected_cards_rect.position.y
	var x_off = selected_cards_rect.size.x / selected_cards.size()
	
	_sort_cards_in_array(selected_cards, start_x, start_y, x_off)		

func _sort_cards_in_array(card_array: Array[Card], start_x: int, start_y: int, x_off: float):
	for idx in card_array.size():		
		var card = card_array[idx]
		card.global_position = Vector2(start_x + idx * x_off, start_y)
		card.set_default_z_index(idx)
