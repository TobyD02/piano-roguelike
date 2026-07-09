class_name CardInfoPanel extends BoxContainer

@export var notes_label: Label
@export var card_note_controller: CardNoteController

func make_visible(_visible: bool):	
	if not _visible:
		visible = false
		return
	
	if notes_label == null:
		return
		
	if card_note_controller == null:
		return
	
	var notes_strings = []
	for note in card_note_controller.notes_pressed:
		if card_note_controller.notes_pressed[note]:
			notes_strings.append(Note.note_enum_to_string[note])
	
	notes_label.text = "Notes: " + ", ".join(notes_strings)
	visible = true
