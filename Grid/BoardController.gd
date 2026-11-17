
extends Node2D

@export var background_controller: BackgroundController
@export var tile_colors: Array[TileColor]
@export var tile_scene: PackedScene
@export var tile_size: float = 64.0

var current_state: int = 1
var tiles: Array = []

var board_layout = [
	[0, 1, 1, 0, 9],
	[0, 3, 2, 9, 3],
	[9, 3, 1, 0, 2],
	[2, 1, 2, 1, 9],
	[1, 3, 9, 0, 9]
]

func get_state() -> int:
	return current_state

func restore_state(state: int):
	change_state(state, true)


func _ready():
	build_board()
	change_state(current_state)
func build_board():
	var rows = board_layout.size()
	var columns = board_layout[0].size()
	var offset = Vector2(columns - 1, rows - 1) * tile_size / 2

	for y in range(rows):
		for x in range(columns):
			var type = board_layout[y][x]
			if type == 9:
				continue

			var tile = tile_scene.instantiate()
			tile.tile_type = type
			tile.tile_colors = tile_colors
			tile.position = Vector2(x, y) * tile_size - offset
			tile.tile_size = tile_size * 0.9
			add_child(tile)
			tiles.append(tile)

func get_tile_at(grid_position: Vector2i):
	var index = 0

	for y in range(board_layout.size()):
		for x in range(board_layout[y].size()):
			if board_layout[y][x] == 9:
				continue

			if Vector2i(x, y) == grid_position:
				return tiles[index]

			index += 1

	return null

func grid_to_world(grid_position: Vector2i) -> Vector2:
	var rows = board_layout.size()
	var columns = board_layout[0].size()
	var offset = Vector2(columns - 1, rows - 1) * tile_size / 2

	return Vector2(grid_position) * tile_size - offset

func change_state(new_state: int, instant: bool = false):
	current_state = new_state
	background_controller.change_color(tile_colors[new_state].foreground, instant)

	for tile in tiles:
		tile.onChangeToState(current_state)
