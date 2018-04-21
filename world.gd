extends Node2D

# Constants
const SPEED = 200 # Speed of the pads
const INBALLSPEED = 100 # Inital Ball Speed

# Variables
var screenSize # Size of the screen
var padSize # Size of the pads
var ballDirection = Vector2(1.0, 0.0) # Initial Direction of the ball
var ballSpeed = INBALLSPEED # Speed of the ball
var leftSc = 0 # Left Player's Score
var rightSc = 0 # Right Player's Score

# Functions

func _ready():
	screenSize = get_viewport_rect().size # Getting the screen size
	padSize = get_node("rightPlayer").get_texture().get_size() # Getting the pad size
	set_process(true)
	pass

func _process(delta):
	
	var leftCollider = Rect2(get_node("leftPlayer").get_position()-padSize*0.5, padSize) # Getting the position of left collider
	var rightCollider = Rect2(get_node("rightPlayer").get_position()-padSize*0.5, padSize) # Getting the position of right collider
	var ballPos = get_node("ball").get_position() # Getting the current position of the ball
	var leftPlayerPosition = get_node("leftPlayer").get_position() # Getting the current position of left player
	var rightPlayerPosition = get_node("rightPlayer").get_position() # Getting the position of the right player
	
	# Setting up the keys configurations
	if(leftPlayerPosition.y > 0 and Input.is_action_pressed("leftMoveUp")):
		leftPlayerPosition.y += -SPEED * delta
	if(rightPlayerPosition.y > 0 and Input.is_action_pressed("rightMoveUp")):
		rightPlayerPosition.y += -SPEED * delta
	if(leftPlayerPosition.y < screenSize.y and Input.is_action_pressed("leftMoveDown")):
		leftPlayerPosition.y += SPEED * delta
	if(rightPlayerPosition.y < screenSize.y and Input.is_action_pressed("rightMoveDown")):
		rightPlayerPosition.y += SPEED * delta
	
	# Changing the position of the ball
	ballPos += ballDirection * ballSpeed * delta
	
	# Ball's collision with upper & lower boundaries
	if(ballPos.y<0 and ballDirection.y<0 or ballPos.y >screenSize.y and ballDirection.y > 0):
		ballDirection.y=-ballDirection.y # Balls gets back in oppsite direction
	
	# Ball's collision witg pads
	if(leftCollider.has_point(ballPos) or rightCollider.has_point(ballPos)):
		ballDirection.x = -ballDirection.x # Balls gets back in oppsite direction
		ballDirection.y = randf()*2-1
		ballDirection = ballDirection.normalized()
		if(ballSpeed<300):
			ballSpeed*=1.4

	# Ball's collision with left boundary
	if(ballPos.x<0):
		ballPos = screenSize*0.5
		ballSpeed = INBALLSPEED
		ballDirection.x = -ballDirection.x # Balls gets back in oppsite direction
		rightSc+=1 # Right Player Scores
	
	# Ball's collision with the right boundary
	if(ballPos.x>screenSize.x):
		ballPos = screenSize*0.5
		ballSpeed = INBALLSPEED
		ballDirection.x = -ballDirection.x # Balls gets back in oppsite direction
		leftSc+=1 # Left Player Scores
	
	# Setting the positions
	get_node("leftPlayer").set_position(leftPlayerPosition)
	get_node("rightPlayer").set_position(rightPlayerPosition)
	get_node("ball").set_position(ballPos)
	get_node("rightScore").set_text(str(rightSc))
	get_node("leftScore").set_text(str(leftSc))
	pass
