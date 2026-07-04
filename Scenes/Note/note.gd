class_name Note extends Node2D

var note: NoteEnum
var note_color: NoteColorEnum
var is_pressed: bool = false

var current_animation_offset: float

const atlas_texture_width: float = 4.0
const atlas_texture_height: float = 30.0

const notes_in_colour: float = 7.0
const white_notes_color_offset: float = 64.0
const white_note_animation_spacing: float = 8.0
const black_note_animation_spacing: float = 7.0
const white_notes_start: float = 2.0
const black_notes_start: float = 449.5

const white_note_is_pressed_animation_spacing: float = 8.0
const black_note_is_pressed_animation_spacing: float = 7.0

@export var sprite: Sprite2D
var atlas_texture: AtlasTexture

var note_animation_x_offset_map: Dictionary = {
	NoteEnum.NOTE_C: white_notes_start + (white_note_animation_spacing * 2),
	NoteEnum.NOTE_C_SHARP: black_notes_start,
	NoteEnum.NOTE_D: white_notes_start + (white_note_animation_spacing * 4),
	NoteEnum.NOTE_D_SHARP: black_notes_start,
	NoteEnum.NOTE_E: white_notes_start + (white_note_animation_spacing * 6),
	NoteEnum.NOTE_F: white_notes_start + (white_note_animation_spacing * 2),
	NoteEnum.NOTE_F_SHARP: black_notes_start,
	NoteEnum.NOTE_G: white_notes_start + (white_note_animation_spacing * 4),
	NoteEnum.NOTE_G_SHARP: black_notes_start,
	NoteEnum.NOTE_A: white_notes_start + (white_note_animation_spacing * 6),
	NoteEnum.NOTE_A_SHARP: black_notes_start,
	NoteEnum.NOTE_B: white_notes_start + (white_note_animation_spacing * 6),
}

var note_color_index_map: Dictionary = {
	NoteColorEnum.BLUE: 0,
	NoteColorEnum.GRAY: 1,
	NoteColorEnum.GREEN: 2,
	NoteColorEnum.OLD: 3,
	NoteColorEnum.RED: 4,
	NoteColorEnum.WHITE: 5,
	NoteColorEnum.YELLOW: 6,
}

enum NoteEnum {
	NOTE_C,
	NOTE_C_SHARP,
	NOTE_D,
	NOTE_D_SHARP,
	NOTE_E,
	NOTE_F,
	NOTE_F_SHARP,
	NOTE_G,
	NOTE_G_SHARP,
	NOTE_A,
	NOTE_A_SHARP,
	NOTE_B,
}

enum NoteColorEnum {
	BLUE,
	GRAY,
	GREEN,
	OLD,
	RED,
	WHITE,
	YELLOW,
}

func _ready():
	atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = load("res://Assets/Pixel Piano 1.0/texture_atlas.png")
	
	current_animation_offset = note_animation_x_offset_map[NoteEnum.NOTE_C]
	

func set_note(_note: NoteEnum):
	note = _note
	set_sprite()
	
func set_note_color(_note_color: NoteColorEnum):
	note_color = _note_color
	set_sprite()
	
func set_is_pressed(_is_pressed: bool):
	is_pressed = _is_pressed
	set_sprite()
	
func set_sprite():
	var offset = note_animation_x_offset_map[note]
	print(note)
	if is_note_black(note):
		#pass
		offset += note_color_index_map[note_color] * black_note_animation_spacing * 2
	else:
		var color_offset = note_color_index_map[note_color] * white_notes_color_offset
		print("color_offset: ", color_offset)
		offset += color_offset
		
	if is_pressed:
		if is_note_black(note):
			offset += black_note_animation_spacing
		else:
			offset += white_note_animation_spacing
		
	print(note, offset)
	atlas_texture.region = Rect2(offset, 0.0, atlas_texture_width, atlas_texture_height)
	sprite.texture = atlas_texture
	
func is_note_black(note: NoteEnum) -> bool:
	match note:
		NoteEnum.NOTE_C_SHARP: return true
		NoteEnum.NOTE_D_SHARP: return true
		NoteEnum.NOTE_F_SHARP: return true
		NoteEnum.NOTE_G_SHARP: return true
		NoteEnum.NOTE_A_SHARP: return true
	
	return false
		
	
	
