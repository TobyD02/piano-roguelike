extends Node

class ChordPattern:
	const REQUIRED_SCORE = 5
	const OPTIONAL_SCORE = 2
	
	var chord_name: String
	var required_notes: Array[int]
	var optional_notes: Array[int]
	var missing_notes: Array[int]
	var extra_notes: Array[int]
	
	var is_sus_chord: bool
	
	var alterations = 0
	
	func _init(
			_name: String,
			_required: Array[int], 
			_is_sus: bool
		):
		required_notes = _required
		is_sus_chord = _is_sus
		chord_name = _name
	
	func score(_intervals: Array[int]) -> int:
		missing_notes.clear()
		extra_notes.clear()
		
		var score = 0
		for note in required_notes:
			if _intervals.has(note):
				score += REQUIRED_SCORE
			else:
				missing_notes.append(note)
		
		if is_sus_chord:
			if _intervals.has(4):
				score -= REQUIRED_SCORE

		for note in optional_notes:
			if _intervals.has(note):
				score += OPTIONAL_SCORE
				
		for note in _intervals:
			if (note not in required_notes) and (note not in optional_notes):
				extra_notes.append(note)

		get_name("")
		score -= alterations

		return score
		
	func get_name(root_note: String) -> String:
		alterations = 0
		
		var _name = root_note + chord_name
		_name = _name_extras(_name)
		_name = _name_missing(_name)
		return _name

	
	func _name_missing(_name: String) -> String:	
		var _ommitted = []
		
		for note in missing_notes:
			if note == 4:
				alterations += 3 # Significant alteration
				_ommitted.append("no3")
			if note == 7:
				#alterations += 1 # A missing 5 "musically" is not considered a signficant modification
				_ommitted.append("no5")
		
		if _ommitted.size() > 0:
			_name += "("+ ",".join(_ommitted) + ")"
		
		return _name
		
	func _name_extras(_name: String) -> String:
		if extra_notes.size() == 0:
			return _name
		
		var has_seven = (extra_notes.has(10) or extra_notes.has(11))
		var has_nine = (extra_notes.has(1) or extra_notes.has(2) or extra_notes.has(3))
		var has_eleven = (extra_notes.has(5) or extra_notes.has(6))
		var has_thirteen = (extra_notes.has(8) or extra_notes.has(9))
		
		if extra_notes.has(11):
			if _name.find("Maj") == -1:
				_name += "Maj"
		elif (extra_notes.has(10)):
			if _name.find("Maj") != -1:
				_name = _name.replace("Maj", "")
				
		if has_seven and not extra_notes.has(2):
			alterations += 1
			_name += "7"
		elif has_seven and extra_notes.has(2):
			alterations += 1
			_name += "9"
			
		if has_thirteen:
			if not has_eleven:
				if not has_seven and not is_sus_chord and extra_notes.has(9): # If no seventh, then it is a 6 chord
					alterations += 1
					_name += "6"
				else:
					if extra_notes.has(8):
						alterations += 1
						_name += "Add(b13)"
					else:
						alterations += 1
						_name += "Add13"
			else:
				if extra_notes.has(8):
					alterations += 1
					_name += "b13"
				else:
					alterations += 1
					_name += "13"
				
		if has_eleven and not has_thirteen:
			if not has_nine:
				if not missing_notes.has(4): # Alternate case (sus chords) are checked in missing notes
					if extra_notes.has(5):
						alterations += 1
						_name += "Add11"
					else:
						alterations += 1
						_name += "Add(#11)"
			else:
				if extra_notes.has(5):
					alterations += 1
					_name += "11"
				else:
					alterations += 1
					_name += "#11"
		
		if has_nine and not has_eleven:
			if not has_seven:
				if not missing_notes.has(4): # alternate case (sus chords) are checked in missing notes
					if extra_notes.has(1):
						alterations += 1
						_name += "Add(b9)"
					if extra_notes.has(2):
						alterations += 1
						_name += "Add9"
					if extra_notes.has(3):
						alterations += 1
						_name += "Add(#9)"
			else:
				if extra_notes.has(1):
					alterations += 1
					_name += "b9"
				elif extra_notes.has(3):
					alterations += 1
					_name += "#9"
		return _name

		
				
class Chord:
	# These are in order of priority - i.e. before Maj is moved on from, each inversion is checked
	var chord_lookup: Array = [
		ChordPattern.new(" Note ", [0], false),
		ChordPattern.new("5", [0, 7], false),
		ChordPattern.new("Maj", [0, 4, 7], false),
		ChordPattern.new("Min", [0, 3, 7], false),
		ChordPattern.new("Dim", [0, 3, 6], false),
		ChordPattern.new("Aug", [0, 4, 8], false),
		ChordPattern.new("Sus2", [0, 2, 7], true),
		ChordPattern.new("Sus4", [0, 5, 7], true)
	]
	
	var notes: Array[Note.NoteEnum] = []
	var intervals: Array[Interval] = []
	var bass: Note.NoteEnum
	var root: Note.NoteEnum
	
	func _init(_notes: Array[Note.NoteEnum]) -> void:
		notes = _notes
		bass = _notes.min()
		
	static func from_notes_pressed(notes_pressed: Dictionary[Note.NoteEnum, bool]) -> Chord:		
		var notes: Array[Note.NoteEnum] = []
		for note in notes_pressed:
			if notes_pressed[note]:
				notes.append(note)
				
		return Chord.new(notes)
	
	func _generate_intervals(inversion: int):
		intervals = [Interval.new(0)]
		var _notes = notes.duplicate()
		_notes.sort()
		root = _notes[inversion%_notes.size()]
		for i in range(_notes.size()):
			var note = _notes[i]
			if note == root:
				continue
			
			var interval = (note - root + 12) % 12
			intervals.append(Interval.new(interval))

	func get_common_name():
		var chosen = ""
		var best_score = 0
		
		for inversion in notes.size():
			_generate_intervals(inversion)
			var intervals = _get_intervals_as_ints()
			intervals.sort()
			for pattern in chord_lookup:
				var score = pattern.score(intervals)
				if score > best_score:
					chosen = pattern.get_name(
						HarmonicAnalysis.get_note_name(
							root, HarmonicAnalysis.get_scale_accidental_type(root)
						)
					)
					best_score = score
					#print("New Best: " + chosen + " | SCORE: " + str(score))
		
		return chosen
		
	func _get_intervals_as_ints() -> Array[int]:
		var ints: Array[int] = []
		for i in intervals:
			ints.append(i.semitones)
		
		return ints
			
class Interval:
	const names_lookup: Dictionary[int, Array] = {
		0: ["Perfect Unison"],
		1: ["Minor Second", "Augmented Unison"],
		2: ["Major Second", "DiMinished Third"],
		3: ["Minor Third", "Augmented Second"],
		4: ["Major Third", "DiMinished Fourth"],
		5: ["Perfect Fourth", "Augmented Third"],
		6: ["DiMinished Fifth", "Tritone", "Augmented Fourth"],
		7: ["Perfect Fifth", "DiMinished Sixth"],
		8: ["Minor Sixth", "Augmented Fifth"],
		9: ["Major Sixth", "DiMinished Seventh"],
		10: ["Minor Seventh", "Augmented Sixth"],
		11: ["Major Seventh", "DiMinished Octave"],
		12: ["Perfect Octave", "Augmented Seventh"]
	}
	
	var semitones: int
	
	func _init(_semitones: int):
		semitones = _semitones
	
	func get_names():
		return names_lookup[semitones]
		
enum AccidentalType {
	SHARP,
	FLAT,
	NONE,
}		
		
## Accidental Type can be null, or HarmonicAnalysis.ACCIDENTAL_TYPE
func get_note_name(note: Note.NoteEnum, accidental_type = null):
	const note_enum_to_string: Dictionary = {
		Note.NoteEnum.NOTE_C: {AccidentalType.SHARP: "c", AccidentalType.FLAT: "c"},
		Note.NoteEnum.NOTE_C_SHARP: {AccidentalType.SHARP: "c#", AccidentalType.FLAT: "d♭"},
		Note.NoteEnum.NOTE_D: {AccidentalType.SHARP: "d", AccidentalType.FLAT: "d"},
		Note.NoteEnum.NOTE_D_SHARP: {AccidentalType.SHARP: "d#", AccidentalType.FLAT: "e♭"},
		Note.NoteEnum.NOTE_E: {AccidentalType.SHARP: "e", AccidentalType.FLAT: "e"},
		Note.NoteEnum.NOTE_F: {AccidentalType.SHARP: "f", AccidentalType.FLAT: "f"},
		Note.NoteEnum.NOTE_F_SHARP: {AccidentalType.SHARP: "f#", AccidentalType.FLAT: "g♭"},
		Note.NoteEnum.NOTE_G: {AccidentalType.SHARP: "g", AccidentalType.FLAT: "g"},
		Note.NoteEnum.NOTE_G_SHARP: {AccidentalType.SHARP: "g#", AccidentalType.FLAT: "a♭"},
		Note.NoteEnum.NOTE_A: {AccidentalType.SHARP: "a", AccidentalType.FLAT: "a"},
		Note.NoteEnum.NOTE_A_SHARP: {AccidentalType.SHARP: "a#", AccidentalType.FLAT: "b♭"},
		Note.NoteEnum.NOTE_B: {AccidentalType.SHARP: "b", AccidentalType.FLAT: "b"},
	}
	
	return note_enum_to_string[note][circle_of_fifths[note]]

func get_scale_accidental_type(scale_root: Note.NoteEnum):
	return circle_of_fifths[scale_root]

const circle_of_fifths: Dictionary = {
	Note.NoteEnum.NOTE_C: AccidentalType.FLAT,
	Note.NoteEnum.NOTE_C_SHARP: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_D: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_D_SHARP: AccidentalType.FLAT,
	Note.NoteEnum.NOTE_E: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_F: AccidentalType.FLAT,
	Note.NoteEnum.NOTE_F_SHARP: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_G: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_G_SHARP: AccidentalType.FLAT,
	Note.NoteEnum.NOTE_A: AccidentalType.SHARP,
	Note.NoteEnum.NOTE_A_SHARP: AccidentalType.FLAT,
	Note.NoteEnum.NOTE_B: AccidentalType.SHARP,
}
