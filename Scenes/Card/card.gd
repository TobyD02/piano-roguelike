class_name Card extends Node2D

@export var card_note_controller: CardNoteController

func _ready():
	# Example of setting cmaj7 chord
	#card_note_controller.set_notes_pressed([
		#Note.NoteEnum.NOTE_C,
		#Note.NoteEnum.NOTE_E,
		#Note.NoteEnum.NOTE_G,
		#Note.NoteEnum.NOTE_B,
	#])
	default_z_index = z_index
	_setup_base_card()
	_generate_random()
	
func _setup_base_card():
	var notes = Note.NoteEnum.values()
	card_note_controller.set_notes_pressed([])
	card_note_controller.set_full_card_color(Note.NoteColorEnum.WHITE)
	
func _generate_random():
	var notes = Note.NoteEnum.values()
	var cols = Note.NoteColorEnum.values()

	var pressed_note: Note.NoteEnum = notes[randi_range(0, len(notes) - 1)]
	set_card_note(pressed_note, true)
	
	pressed_note = notes[randi_range(0, len(notes) - 1)]
	set_card_note(pressed_note, true)

func set_card_note(_note: Note.NoteEnum, _is_pressed: bool):
	var col = Note.NoteColorEnum.GRAY if not _is_pressed else Note.NoteColorEnum.WHITE
	card_note_controller.set_note(_note, col, _is_pressed)

func _process(delta: float):
	if is_hovered:
		z_index = 100
		var tween = get_tree().create_tween()
		tween.tween_property(card_note_controller, "scale", default_scale * 1.5, 0.25)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(card_note_controller, "scale", default_scale, 0.25)
		z_index = default_z_index
	
var default_scale: Vector2 = Vector2.ONE
var is_hovered: bool = false
var default_z_index: int

func set_hovered(_hovered: bool):
	is_hovered = _hovered
	card_note_controller.set_card_hovered(_hovered)

	
	
	
