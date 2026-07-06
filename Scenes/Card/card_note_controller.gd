@tool
class_name CardNoteController extends Node2D

@export_tool_button("Update Card") var editor_update_card_btn = _editor_update_card
@export var editor_keys_pressed: Array[Note.NoteEnum] = []
@export var color: Note.NoteColorEnum = Note.NoteColorEnum.WHITE

var card_background: Sprite2D

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

func _ready():
	initialise_notes()
	
func _process(delta: float):
	if Engine.is_editor_hint(): # Safe guard tool
		return
		
func _editor_update_card():
	initialise_notes()
	set_notes_pressed(editor_keys_pressed)
	update_card_background()
		
func initialise_notes():
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
		set_note(note, color)
		
	update_card_background()

func set_note(_note: Note.NoteEnum, _color: Note.NoteColorEnum = color, _is_pressed: bool = false):
	var note_node = notes_to_nodes[_note]
	note_node.set_note(_note)
	note_node.set_note_color(_color)
	note_node.set_is_pressed(_is_pressed)
	
func set_notes_pressed(_notes: Array[Note.NoteEnum]):
	for note in notes_to_nodes:
		var is_pressed = note in _notes
		notes_to_nodes[note].set_is_pressed(is_pressed)
		
func set_notes_color(_notes: Array[Note.NoteEnum], _color: Note.NoteColorEnum):
	for note in _notes:
		notes_to_nodes[note].set_note_color(_color)
		
func set_full_card_color(_color: Note.NoteColorEnum):
	color = _color
	for note in notes_to_nodes:
		notes_to_nodes[note].set_note_color(color)
		
	update_card_background()
		
	
func update_card_background():
	if card_background == null:
		card_background = get_node("CardBackground")
		
	const card_background_color_map = {
		Note.NoteColorEnum.BLUE: "blue_",
		Note.NoteColorEnum.GRAY: "gray_",
		Note.NoteColorEnum.GREEN: "green_",
		Note.NoteColorEnum.OLD: "old_",
		Note.NoteColorEnum.RED: "red_",
		Note.NoteColorEnum.WHITE: "white_",
		Note.NoteColorEnum.YELLOW: "yellow_",
	}
	
	var texture_name = card_background_color_map[color] + "card_background.png"
	card_background.texture = load("res://Assets/Pixel Piano 1.0/card_backgrounds/" + texture_name)
	
