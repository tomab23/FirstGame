extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# roll
const ROLL_SPEED = 200.0
const ROLL_DURATION = 0.25
var is_rolling = false
var roll_timer = 0.0
var dash = false

@onready var animation = $AnimatedSprite2D

# roll and dash
func _input(_event: InputEvent) -> void:
	if dash == false:
		if Input.is_action_just_pressed("roll") and is_on_floor() and not is_rolling:
			is_rolling = true
			roll_timer = ROLL_DURATION
	else:
		if Input.is_action_just_pressed("roll") and not is_rolling:
			is_rolling = true
			roll_timer = ROLL_DURATION

func _physics_process(delta: float) -> void:
	
	# handle roll
	if is_rolling:
		roll_timer -= delta
		var roll_direction = -1 if animation.flip_h else 1
		velocity.x = roll_direction * ROLL_SPEED
		if is_on_floor():
			animation.play("roll")
		elif not is_on_floor() and dash == true:
			animation.play("jump")
		if roll_timer <= 0.0:
			is_rolling = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_rolling:
		var direction := Input.get_axis("ui_left", "ui_right")
	
		if direction > 0:
			animation.flip_h = false
		elif direction < 0:
			animation.flip_h= true
		
		if is_on_floor():
			if direction == 0:
				animation.play("idle")
			else:
				animation.play("run")
		else:
			animation.play("jump")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
