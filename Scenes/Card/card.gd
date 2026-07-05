class_name Card extends Node2D

@export var card_note_controller: CardNoteController
@export var default_color: Note.NoteColorEnum = Note.NoteColorEnum.WHITE

func _ready():
	# Example of setting cmaj7 chord
	#card_note_controller.set_notes_pressed([
		#Note.NoteEnum.NOTE_C,
		#Note.NoteEnum.NOTE_E,
		#Note.NoteEnum.NOTE_G,
		#Note.NoteEnum.NOTE_B,
	#])
	default_z_index = z_index
	card_note_controller.set_full_card_color(default_color)
	_generate_random()
	
func _generate_random():
	var notes = Note.NoteEnum.values()
	var cols = Note.NoteColorEnum.values()
	
	var num_notes = randi_range(1, 4)
	var select_notes: Array[Note.NoteEnum] = []
	for i in num_notes:
		var choice = randi_range(0, len(notes) - 1)
		select_notes.append(notes[choice])
		notes.remove_at(choice)
	
	card_note_controller.set_notes_pressed(select_notes)
	for note in notes:
		if randi_range(0, 10) > 6:
			var select_color: Note.NoteColorEnum = cols[randi_range(0, len(cols) - 1)]
			card_note_controller.set_notes_color([note], select_color)
			
	#
#var note_idx = 0
#var col_idx = 0
#var count: float = 0.0
#var count_max: float = 0.25
#
#func _process(delta: float):
	#count += delta
	#if count > count_max:
		#card_note_controller.set_notes_pressed([Note.NoteEnum.values()[note_idx % len(Note.NoteEnum.values())]])
		#count = 0
		#note_idx +=1
		#
		#if note_idx >= len(Note.NoteEnum.values()):
			#note_idx = 0
			#col_idx += 1
			#
		#if col_idx >= len(Note.NoteColorEnum.values()):
			#col_idx = 0
			#
		#card_note_controller.set_full_card_color(Note.NoteColorEnum.values()[col_idx])

func _process(delta: float):
	if is_hovered:
		z_index = 100
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", default_scale * 1.5, 0.25)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", default_scale, 0.25)
		z_index = default_z_index
	
var default_scale: Vector2 = Vector2.ONE
var is_hovered: bool = false
var default_z_index: int

func set_hovered(_hovered: bool):
	is_hovered = _hovered

	
	
	
