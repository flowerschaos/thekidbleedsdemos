@tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)

@export var grid: Resource = preload("res://Scripts/grid.tres")
@export var ui_cooldown = 0.1

var cell := Vector2.ZERO :
	set(value):
		cell = grid.gridclamp(value)
	get:
		return cell

@onready var timer: Timer = $Timer
func _ready() -> void:
	timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)

func unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.cell = grid.calculate_grid_coordinates(event.position)
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)
		get_tree().set_input_as_handled()
	var should_move := event.is_pressed()
	if event.is_echo():
			should_move = should_move and timer.is_stopped()
	if not should_move:
		return
	if event.is_action("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2.DOWN

func draw() -> void:
		draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.ALICE_BLUE, false, 2.0)

func set_cell(value: Vector2) -> void:
	var new_cell: Vector2 = grid.clamp(value)
	if new_cell.is_equal_approx(cell):
		return
	cell = new_cell
	position = grid.calculate_map_position(cell)
	emit_signal("moved", cell)
	timer.start()
