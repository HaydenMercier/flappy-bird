extends Node

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 50
const PIPE_RANGE : int = 200
@export var pipe_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$Birb.reset()
	$GameOver.hide()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if not game_running:
					start_game()
				else:
					if $Birb.flying:
						$Birb.flap()
						check_top()

func start_game():
	game_running = true
	$Birb.flying = true
	$Birb.flap()
	$PipeTimer.start()


func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height)/2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(birb_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func check_top():
	if $Birb.position.y < 0:
		$Birb.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$Birb.flying = false
	game_running = false
	game_over = true
	$GameOver.show()

func _on_ground_hit():
	$Birb.falling = false
	stop_game()
	
func birb_hit():
	$Birb.falling = true
	stop_game()

func _on_game_over_restart():
	new_game() # Replace with function body.
