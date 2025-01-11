extends Area2D
class_name hitboxComponent

@export var health_component: healthComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
