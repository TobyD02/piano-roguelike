class_name CardInfoPanel extends BoxContainer

@export var notes_label: Label
@export var harmony_label: Label
@export var card_note_controller: CardNoteController

func make_visible(_visible: bool):
	if not _visible:
		visible = false
		return
	
	if notes_label == null:
		return
		
	if card_note_controller == null:
		return
		
	if harmony_label == null:
		return
	
	_generate_contents()
	
	visible = true


func _generate_contents():
	var notes_strings: Array[String] = []
	for note in card_note_controller.notes_pressed:
		if card_note_controller.notes_pressed[note]:
			notes_strings.append(Note.note_enum_to_string[note])
	
	notes_label.text = " ".join(notes_strings)
	
	#var intervals = HarmonicAnalysis.harmonic_analysis(card_note_controller.notes_pressed)
	#harmony_label.text = ", ".join(intervals)
	
	#var chords = HarmonicAnalysis.chord_analysis(card_note_controller.notes_pressed)
	#harmony_label.text = chords
	
	var chord = HarmonicAnalysis.Chord.from_notes_pressed(card_note_controller.notes_pressed)
	harmony_label.text = chord.get_common_name()
