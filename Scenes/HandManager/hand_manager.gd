class_name HandManager extends Node2D

@onready var card_scene = preload("res://Scenes/Card/card.tscn")

var selected_card: Card = null
var hovered_card: Card = null

var hand: Array[Card] = []

const CARD_WIDTH = 40
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
		
		card.global_position = Vector2(start_x + idx * x_off, start_y)
		#_generate_chord(card, idx)
