class_name Card extends Node2D

@export var card_note_controller: CardNoteController

func _ready():
	# Example of setting cmaj7 chord
	card_note_controller.set_notes_pressed([
		Note.NoteEnum.NOTE_C,
		Note.NoteEnum.NOTE_E,
		Note.NoteEnum.NOTE_G,
		Note.NoteEnum.NOTE_B,
	])
	
	
	
	
