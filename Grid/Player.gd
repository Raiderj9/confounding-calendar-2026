
extends Node2D
class_name PlayerController

@export var board_controller: Node2D
@export var move_duration: float = 0.15

var grid_position: Vector2i = Vector2i(0, 0)
var is_moving: bool = false
var is_dead: bool = false

func _ready():
	position = board_controller.grid_to_world(grid_position)
	check_walkable()

func move(direction: Vector2i):
	if is_moving or is_dead:
		return

	var target_grid = grid_position + direction
	var tile = board_controller.get_tile_at(target_grid)

	if tile == null:
		return

	grid_position = target_grid
	is_moving = true

	var tween = create_tween()
	tween.tween_property(self, "position", board_controller.grid_to_world(grid_position), move_duration)

	tween.finished.connect(func():
		is_moving = false
		check_walkable()
	)

func check_walkable():
	var tile = board_controller.get_tile_at(grid_position)
	if tile == null or not tile.can_walk():
		die()

func die():
	if is_dead:
		return

	is_dead = true

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 180.0, 0.3)
	tween.tween_property(self, "modulate", Color.GRAY, 0.3)
