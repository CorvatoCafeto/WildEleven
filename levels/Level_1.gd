extends Node2D

var score = 0
var highscore = Globals.highscore
var can_upgrade = 0

func _ready():
	randomize()
	Globals.in_alter_dimension = false
	_on_dimension_swap()
	
	$AlterDimension.set_collision_layer_bit(1,0)
	$player.connect("dimension_swap", self, "_on_dimension_swap")

func _on_dimension_swap():
	#if $solids.visible:
	if Globals.in_alter_dimension == true:
		$solids.modulate.a = 0.25
		$AlterDimension.modulate.a = 0.8
		$solids.z_index = 100
		$AlterDimension.z_index = -100
		$solids.set_collision_layer_bit(1,0)
		$AlterDimension.set_collision_layer_bit(1,1)
		$permanent.position = Vector2()
		Globals.in_alter_dimension = false
		if can_upgrade > 0:
			get_node("upgrade_area/Collision").position.y = 52
		else:
			get_node("upgrade_area/Collision").position.y = 92
		for item in get_tree().get_nodes_in_group("items"):
			item.set_modulate(Color(0.1,0.1,0.1))
	else:
		$solids.modulate.a = 0.8
		$AlterDimension.modulate.a = 0.25
		$solids.z_index = -100
		$AlterDimension.z_index = 100
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.set_collision_layer_bit(1,1)
		$permanent.position = Vector2(0,-1216)
		Globals.in_alter_dimension = true
		get_node("upgrade_area/Collision").position.y = 92
	
		for item in get_tree().get_nodes_in_group("items"):
			if ($player.position - item.position).length() < 40:
				item.touched()
				
			item.set_modulate(Color(1,1,1))
	
	
func actualize_score(points):
	score += points
	get_node("UI/Score").text = str(score)
	
	for i in [10, 25, 50, 100, 200, 400, 600, 800, 1000]:
		if i == score:
			can_upgrade += 1
	
	if can_upgrade > 0:
		$upgrade_area.visible = true

func game_over():
	get_node("UI/GameOver/AnimGameOver").play("game_over")
