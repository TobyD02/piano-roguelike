class_name Card extends Node2D

var note_c: Note
var note_c_sharp: Note
var note_d: Note
var note_d_sharp: Note
var note_e: Note
var note_f: Note
var note_f_sharp: Note
var note_g: Note
var note_g_sharp: Note
var note_a: Note
var note_a_sharp: Note
var note_b: Note

var notes: Dictionary 

var color: Note.NoteColorEnum = Note.NoteColorEnum.OLD

func _ready():
	note_c = get_node("NoteC")
	note_c_sharp = get_node("NoteC#")
	note_d = get_node("NoteD")
	note_d_sharp = get_node("NoteD#")
	note_e = get_node("NoteE")
	note_f = get_node("NoteF")
	note_f_sharp = get_node("NoteF#")
	note_g = get_node("NoteG")
	note_g_sharp = get_node("NoteG#")
	note_a = get_node("NoteA")
	note_a_sharp = get_node("NoteA#")
	note_b = get_node("NoteB")
	
	notes = {
		note_c: Note.NoteEnum.NOTE_C,
		note_c_sharp: Note.NoteEnum.NOTE_C_SHARP,
		note_d: Note.NoteEnum.NOTE_D,
		note_d_sharp: Note.NoteEnum.NOTE_D_SHARP,
		note_e: Note.NoteEnum.NOTE_E,
		note_f: Note.NoteEnum.NOTE_F,
		note_f_sharp: Note.NoteEnum.NOTE_F_SHARP,
		note_g: Note.NoteEnum.NOTE_G,
		note_g_sharp: Note.NoteEnum.NOTE_G_SHARP,
		note_a: Note.NoteEnum.NOTE_A,
		note_a_sharp: Note.NoteEnum.NOTE_A_SHARP,
		note_b: Note.NoteEnum.NOTE_B
	}

		
	for note_node in notes:
		setup_note(note_node, notes[note_node], color)

func setup_note(_note_node: Note, _note: Note.NoteEnum, _color: Note.NoteColorEnum = color, _is_pressed: bool = false):
	_note_node.set_note(_note)
	_note_node.set_note_color(_color)
	_note_node.set_is_pressed(_is_pressed)

var tick = 0.0
var idx = 0

func _process(delta: float):
	var notes_array = [
	note_c,
	note_c_sharp,
	note_d,
	note_d_sharp,
	note_e,
	note_f,
	note_f_sharp,
	note_g,
	note_g_sharp,
	note_a,
	note_a_sharp,
	note_b,
]
	tick += delta
	if tick >= 0.25:
		setup_note(notes_array[idx], notes[notes_array[idx]], color, not notes_array[idx].is_pressed)
		tick = 0
		idx += 1
		if idx >= len(notes_array):
			idx = 0
	
	
	
	
	
