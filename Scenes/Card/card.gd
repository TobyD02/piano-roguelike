class_name Card extends Control

const CARD_SELECTED_SIGNAL: String = "card_selected_signal"
signal card_selected_signal(card: Card)

@export var card_note_controller: CardNoteController
@export var card_info_panel: CardInfoPanel
@export var card_selector: Container

var default_scale: Vector2 = Vector2.ONE
var is_hovered: bool = false
var is_selected: bool = false
var default_z_index: int

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
	
	if card_selector == null:
		return
		
	card_selector.connect("mouse_entered", _on_mouse_entered)
	card_selector.connect("mouse_exited", _on_mouse_exited)
	
func _process(delta: float) -> void:
	if is_hovered and Input.is_action_just_pressed("select"):
		emit_signal(CARD_SELECTED_SIGNAL, self)
	
func _setup_base_card():
	var notes = Note.NoteEnum.values()
	card_note_controller.set_notes_pressed([])
	card_note_controller.set_full_card_color(Note.NoteColorEnum.WHITE)
	
func _generate_random():
	var notes = Note.NoteEnum.values()
	var cols = Note.NoteColorEnum.values()
	
	 #Select 3 notes (spaced) and then potentially add extensions?
	
	#for i in 2:
		#if i == 1 or randi_range(0, 10) > 0.5:
	var pressed_note: Note.NoteEnum = notes[randi_range(0, len(notes) - 1)]
	set_card_note(pressed_note, true)
	#set_card_note(Note.NoteEnum.NOTE_F_SHARP, true)
	#set_card_note(Note.NoteEnum.NOTE_G, true)
	#set_card_note(Note.NoteEnum.NOTE_A, true)
	#set_card_note(Note.NoteEnum.NOTE_A_SHARP, true)


func set_card_note(_note: Note.NoteEnum, _is_pressed: bool):
	var col = Note.NoteColorEnum.GRAY if not _is_pressed else Note.NoteColorEnum.WHITE
	card_note_controller.set_note(_note, col, _is_pressed)
	

func set_hovered(_hovered: bool):
	is_hovered = _hovered
	if not is_selected:
		_do_standout(is_hovered)
	
	
func _on_mouse_entered():
	card_info_panel.make_visible(true)
	set_hovered(true)

func _on_mouse_exited():
	card_info_panel.make_visible(false)
	set_hovered(false)	

func _do_standout(_should_standout: bool):
	card_note_controller.set_card_standout(_should_standout)
	if _should_standout:
		z_index = 100
		var tween = get_tree().create_tween()
		tween.tween_property(card_note_controller, "scale", default_scale * 1.25, 0.25)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(card_note_controller, "scale", default_scale, 0.25)
		z_index = default_z_index

func set_default_z_index(_z_index: int):
	z_index = _z_index
	default_z_index = z_index

#func set_selected(_selected: bool):
	#is_selected = _selected
