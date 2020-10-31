extends "res://NPCs/PlayerDetection.gd"

var navigation
var destinations
var motion
var possible_destinations
var path

export var minimum_arrival_distance = 5
export var walk_speed = 0.5

func _ready():
	randomize()
	navigation = get_tree().get_root().find_node("Navigation2D", true, false)
	destinations = navigation.get_node("Destinations")
	possible_destinations = destinations.get_children()
	make_path()

func _physics_process(delta):
	navigate()

func make_path():
	var new_destintation = possible_destinations[randi() % possible_destinations.size() - 1]
	path = navigation.get_simple_path(position, new_destintation.position, false)

func navigate():
	var distance_to_destintaion = position.distance_to(path[0])
	if distance_to_destintaion > minimum_arrival_distance:
		move()
	else:
		update_path()

func move():
	look_at(path[0])
	motion = (path[0] - position).normalized() * MAX_SPEED * walk_speed
	if is_on_wall():
		make_path()
	move_and_slide(motion)

func update_path():
	if path.size() == 1:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		path.remove(0)

func _on_Timer_timeout():
	make_path()
