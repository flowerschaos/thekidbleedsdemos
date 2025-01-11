# again use of the @ symbol on the decorators
@tool
class_name Unit
extends Path2D

@export var grid: Resource = preload("res://Scripts/grid.tres")
@export var move_range := 6

# setget no longer works in Godot 4
# there are a couple of new ways to create your getter and setter
# using a function inside of the set: block triggered an infinite loop
# so we write the setter code here
@export var skin: Texture :
	set(value):
		skin = value
		if not _sprite:
						# yield has been replaced with await
						# and we await the value on the self object
			await self.ready
		_sprite.texture = value
	get:
		return _sprite.texture
		
@export var skin_offset := Vector2.ZERO :
	set(value):
		skin_offset = value
		if not _sprite:
			await self.ready
		_sprite.position = value
	get:
		return _sprite.position

@export var move_speed := 600.0

var cell := Vector2.ZERO :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell
	
var is_selected := false :
	set(value):
		is_selected = value
		if is_selected:
			_anim_player.play("selected")
		else:
			_anim_player.play("idle")
	get:
		return is_selected
	
var _is_walking := false :
	set(value):
		_is_walking = value
		set_process(_is_walking)
	get:
		return _is_walking
	
@onready var _sprite: Sprite2D = $PathFollow2D/Sprite
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

signal walk_finished

func _ready() -> void:
	set_process(false)
	
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)
	
		# function renamed from .editor_hint
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
		
	var points := [
		Vector2(2,2),
		Vector2(2,5),
		Vector2(8,5),
		Vector2(8,7),
	]
	walk_along(PackedVector2Array(points))
		
func _process(delta: float) -> void:
		# .offset has been renamed to .progress
	_path_follow.progress += move_speed * delta
	
		# .unit_offset is now .progress_ratio
	if _path_follow.progress_ratio >= 1.0:
		self._is_walking = false
		_path_follow.progress = 0.0
		position = grid.calculate_map_position(cell)
		curve.clear_points()
		emit_signal("walk_finished")
		
# PoolVector2Array is now PackedVector2Array
func walk_along(path: PackedVector2Array) -> void:
		# there is no path.empty() value
		# so we use not path.size() instead
	if not path.size():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
		
	cell = path[-1]
	self._is_walking = true
