class_name CardNoteController extends Node2D

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


var notes_to_nodes: Dictionary 

var color: Note.NoteColorEnum = Note.NoteColorEnum.YELLOW

func _ready():
	note_c = get_parent().get_node("NoteC")
	note_c_sharp = get_parent().get_node("NoteC#")
	note_d = get_parent().get_node("NoteD")
	note_d_sharp = get_parent().get_node("NoteD#")
	note_e = get_parent().get_node("NoteE")
	note_f = get_parent().get_node("NoteF")
	note_f_sharp = get_parent().get_node("NoteF#")
	note_g = get_parent().get_node("NoteG")
	note_g_sharp = get_parent().get_node("NoteG#")
	note_a = get_parent().get_node("NoteA")
	note_a_sharp = get_parent().get_node("NoteA#")
	note_b = get_parent().get_node("NoteB")

	notes_to_nodes = {
		Note.NoteEnum.NOTE_C: note_c,
		Note.NoteEnum.NOTE_C_SHARP: note_c_sharp,
		Note.NoteEnum.NOTE_D: note_d,
		Note.NoteEnum.NOTE_D_SHARP: note_d_sharp,
		Note.NoteEnum.NOTE_E: note_e,
		Note.NoteEnum.NOTE_F: note_f,
		Note.NoteEnum.NOTE_F_SHARP: note_f_sharp,
		Note.NoteEnum.NOTE_G: note_g,
		Note.NoteEnum.NOTE_G_SHARP: note_g_sharp,
		Note.NoteEnum.NOTE_A: note_a,
		Note.NoteEnum.NOTE_A_SHARP: note_a_sharp,
		Note.NoteEnum.NOTE_B: note_b,
	}

		
	for note in notes_to_nodes:
		update_note(note, color)

func update_note(_note: Note.NoteEnum, _color: Note.NoteColorEnum = color, _is_pressed: bool = false):
	var note_node = notes_to_nodes[_note]
	note_node.set_note(_note)
	note_node.set_note_color(_color)
	note_node.set_is_pressed(_is_pressed)
	
func set_notes_pressed(_notes: Array[Note.NoteEnum]):
	for note in notes_to_nodes:
		var is_pressed = note in _notes
		notes_to_nodes[note].set_is_pressed(is_pressed)
			
