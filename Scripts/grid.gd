class_name Grid
extends Resource

# grid size in rows and columns
@export var size = Vector2(20,20)
# size of a cell in pixels
@export var cell_size = Vector2(80,80)

# half of cell_size- this is how we center units
var half_cell_size = cell_size/2

# returns a cell's position in pixels; for placing and moving units
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + half_cell_size

# returns cell coordinates. does a lot of math to take where you put your units down with the editor
# 'n snap 'em to grid coords
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()

# makes sure that units placed down are actually on the battlefield
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out = cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y

# makes sure that 'grid_position' is within battlefield bounds
func gridclamp(grid_position: Vector2) -> Vector2:
	var out = grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

# takes coordinates and references 'em with index data
func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
