extends CharacterBody2D

# sets up the statblock for units
@export_category("Statistics")
@export var speed_min: int = 1
@export var speed_max: int = 2
@export var attack: int = 1
@export var defense: int = 1
@export var is_playable: bool

# items, weapons, et cetera
@export_category("Loadout")
@export_group("Weapons and Tools")
@export var primary: String
@export var secondary_tool: String
@export var outfit: String
@export_group("Skills")
@export var passive: String
@export var overcharge: String
@export var overload: String
@export var last_stand: String

var target = null
var sprite: Sprite2D

@onready var health = $Health

func _ready():
	sprite = $Sprite2D

func damage_unit():
	if health > 0:
		health -= 1
	if health <= 0:
		queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("target_select"):
		target = get_global_mouse_position()
