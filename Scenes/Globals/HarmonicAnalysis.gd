extends Node

class Chord:
	const chord_lookup: Dictionary = {
		# Triads
		[0, 4, 7]: "maj",
		[0, 3, 7]: "min",
		[0, 3, 6]: "dim",
		[0, 4, 8]: "aug",
		
		# Suspended
		[0, 2, 7]: "sus2",
		[0, 5, 7]: "sus4",
		
		# Sixth chords
		[0, 4, 7, 9]: "6",
		[0, 3, 7, 9]: "m6",
		
		# Seventh chords
		[0, 4, 7, 10]: "7",
		[0, 4, 7, 11]: "maj7",
		[0, 3, 7, 10]: "m7",
		[0, 3, 6, 10]: "m7b5",
		[0, 3, 6, 9]: "dim7",
		
		# Added tone chords
		[0, 2, 4, 7]: "add9",
		[0, 3, 7, 14]: "madd9",
		[0, 4, 7, 14]: "add9",
		[0, 4, 7, 11, 14]: "maj9",
		[0, 3, 7, 10, 14]: "m9",
		
		# Ninth chords
		[0, 4, 7, 10, 14]: "9",
		[0, 4, 8, 10, 14]: "7#5",
		[0, 3, 6, 10, 14]: "m9b5",
		
		# Eleventh chords
		[0, 4, 7, 10, 14, 17]: "11",
		[0, 3, 7, 10, 14, 17]: "m11",
		[0, 4, 7, 11, 14, 17]: "maj11",
		
		# Thirteenth chords
		[0, 4, 7, 10, 14, 17, 21]: "13",
		[0, 4, 7, 11, 14, 17, 21]: "maj13",
		[0, 3, 7, 10, 14, 17, 21]: "m13",
		
		# Altered dominants
		[0, 4, 7, 10, 13]: "7b9",
		[0, 4, 7, 10, 15]: "7#9",
		[0, 4, 7, 10, 16]: "7#11",
		[0, 4, 7, 10, 20]: "7b13",
		[0, 4, 8, 10]: "7#5",
		
		# Power chords
		[0, 7]: "5",
		[0, 7, 12]: "5"
	}
	
	var notes: Array[Note.NoteEnum] = []
	var intervals: Array[Interval] = []
	var root: Note.NoteEnum
	
	func _init(_notes: Array[Note.NoteEnum]) -> void:
		notes = _notes
		root = _notes.min()
		
		_generate_intervals()
		
	static func from_notes_pressed(notes_pressed: Dictionary[Note.NoteEnum, bool]) -> Chord:		
		var notes: Array[Note.NoteEnum] = []
		for note in notes_pressed:
			if notes_pressed[note]:
				notes.append(note)
				
		return Chord.new(notes)
	
	func _generate_intervals():
		intervals.append(Interval.new(0))
		var _root = notes.min()
		
		for i in range(notes.size()):
			var note = notes[i]
			if note == _root:
				continue
			
			var interval = (note - root + 12) % 12
			intervals.append(Interval.new(interval))

	func get_common_name():
		return Note.note_enum_to_string[root] + chord_lookup.get(
			_get_intervals_as_ints(),
			 ""
		)
		
	func _get_intervals_as_ints():
		var ints = []
		for i in intervals:
			ints.append(i.semitones)
		
		print(ints)
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
