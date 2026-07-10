extends Node

class ChordPattern:
	const REQUIRED_SCORE = 5
	const OPTIONAL_SCORE = 2
	
	var chord_name: String
	var required_notes: Array[int]
	var optional_notes: Array[int]
	var missing_notes: Array[int]
	var extra_notes: Array[int]
	
	func _init(
			_name: String,
			_required: Array[int], 
			_optional: Array[int] = [],
		):
		required_notes = _required
		optional_notes = _optional
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

		for note in optional_notes:
			if _intervals.has(note):
				score += OPTIONAL_SCORE
				
		for note in _intervals:
			if (note not in required_notes) and (note not in optional_notes):
				extra_notes.append(note)

		return score
		
	func get_name(root_note: String) -> String:
		var _name = root_note + chord_name
		_name = _name_extras(_name)
		_name = _name_missing(_name)
		
		return _name
	
	func _name_missing(_name: String) -> String:	
		var _ommitted = []
		
		for note in missing_notes:
			if note == 4:
				_ommitted.append("no3")
			if note == 7:
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
		
		if has_seven and not has_nine:
			if extra_notes.has(10):
				if _name.find("maj") > -1:
					_name = _name.replace("maj", "")
				_name += "7"
				
			if extra_notes.has(11):
				if _name.find("maj") == -1:
					_name += "maj"
				_name += "7"
		
		if has_thirteen:
			if not has_eleven:
				if extra_notes.has(8):
					_name += "(add♭6)"
				elif (has_nine or has_seven):
					_name += "add13"
				else:
					_name += "add6"

			
		return _name
		
				
class Chord:
	# These are in order of priority - i.e. before maj is moved on from, each inversion is checked
	var chord_lookup: Array = [
		# Triads
		ChordPattern.new("maj", [0, 4, 7]),
		ChordPattern.new("min", [0, 3, 7]),
		ChordPattern.new("dim", [0, 3, 6]),
		ChordPattern.new("aug", [0, 4, 8]),
	]
		#
		## Suspended
		#[0, 2, 7]: "sus2",
		#[0, 5, 7]: "sus4",
		#
		## Sixth chords
		#[0, 4, 7, 9]: "6",
		#[0, 3, 7, 9]: "m6",
		#
		## Seventh chords
		#[0, 4, 7, 10]: "7",
		#[0, 4, 7, 11]: "maj7",
		#[0, 3, 7, 10]: "m7",
		#[0, 3, 6, 10]: "m7b5",
		#[0, 3, 6, 9]: "dim7",
		#
		## Added tone chords
		#[0, 2, 4, 7]: "add9",
		#[0, 3, 7, 14]: "madd9",
		#[0, 4, 7, 14]: "add9",
		#[0, 4, 7, 11, 14]: "maj9",
		#[0, 3, 7, 10, 14]: "m9",
		#
		## Ninth chords
		#[0, 4, 7, 10, 14]: "9",
		#[0, 4, 8, 10, 14]: "7#5",
		#[0, 3, 6, 10, 14]: "m9b5",
		#
		## Eleventh chords
		#[0, 4, 7, 10, 14, 17]: "11",
		#[0, 3, 7, 10, 14, 17]: "m11",
		#[0, 4, 7, 11, 14, 17]: "maj11",
		#
		## Thirteenth chords
		#[0, 4, 7, 10, 14, 17, 21]: "13",
		#[0, 4, 7, 11, 14, 17, 21]: "maj13",
		#[0, 3, 7, 10, 14, 17, 21]: "m13",
		#
		## Altered dominants
		#[0, 4, 7, 10, 13]: "7b9",
		#[0, 4, 7, 10, 15]: "7#9",
		#[0, 4, 7, 10, 16]: "7#11",
		#[0, 4, 7, 10, 20]: "7b13",
		#[0, 4, 8, 10]: "7#5",
		#
		## Power chords
		#[0, 7]: "5",
		#[0, 7, 12]: "5"
	#}
	
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
		var _notes = notes
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
		
		for chord in chord_lookup:
			for inversion in notes.size():
				_generate_intervals(inversion)
				var intervals = _get_intervals_as_ints()
				intervals.sort()
				for pattern in chord_lookup:
					var score = pattern.score(intervals)
					if score > best_score:
						chosen = pattern.get_name(Note.note_enum_to_string[root])
						best_score = score
						print("New Best: " + chosen + " | SCORE: " + str(score))
				#if chord_lookup.get(intervals) != null:
					#return Note.note_enum_to_string[root] + chord_lookup[intervals]
		
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
		2: ["Major Second", "Diminished Third"],
		3: ["Minor Third", "Augmented Second"],
		4: ["Major Third", "Diminished Fourth"],
		5: ["Perfect Fourth", "Augmented Third"],
		6: ["Diminished Fifth", "Tritone", "Augmented Fourth"],
		7: ["Perfect Fifth", "Diminished Sixth"],
		8: ["Minor Sixth", "Augmented Fifth"],
		9: ["Major Sixth", "Diminished Seventh"],
		10: ["Minor Seventh", "Augmented Sixth"],
		11: ["Major Seventh", "Diminished Octave"],
		12: ["Perfect Octave", "Augmented Seventh"]
	}
	
	var semitones: int
	
	func _init(_semitones: int):
		semitones = _semitones
	
	func get_names():
		return names_lookup[semitones]
