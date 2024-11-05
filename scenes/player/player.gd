extends CharacterBody2D

@export var move_speed: float = 100
@export var acceleretion: float = 20
@export var friction: float = 20

@export var jump_height: float = 120
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (pow(jump_time_to_peak, 2))) * -1.0 
@onready var fall_gravity: float = ((-2.0 * jump_height) / (pow(jump_time_to_descent, 2))) * -1.0

@onready var wall_jump_r: RayCast2D = $raycasts/RayCast2D5
@onready var wall_jump_l: RayCast2D = $raycasts/RayCast2D6


const wall_jump_pushback: float = 200
const wall_slide_gravity: float = 100
var is_wall_sliding: bool = false

func _physics_process(delta: float) -> void:
	velocity.y += gravity() * delta
	
	var direction: float = input()
	
	animations.flip_h = direction < 0
	accelerate(direction)
	
	if is_on_floor():
		if direction != 0:
			play_animations("run")
		else:
			play_animations("idle")
			decelerate()
	
	if Input.is_action_just_pressed("jump") :
		jump()
	wall_slide(delta)
	
	if !is_on_floor() && velocity.y > 0.0 && !is_wall_sliding:
		play_animations("fall")
	
	print(velocity)
	move_and_slide()


func input() -> float:
	var direction = Input.get_axis("left", "right")
	
	return direction

func accelerate(direction: float) -> void:
	velocity.x = move_toward(velocity.x, direction * move_speed, acceleretion)

func decelerate() -> void:
	velocity.x = move_toward(velocity.x, 0, friction)

func play_animations(animation: String) -> void:
	animations.play(animation)

func gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump() -> void:
	play_animations("jump")
	if is_on_floor():
		velocity.y = jump_velocity
	if is_on_wall() && Input.is_action_pressed("right") && Input.is_action_pressed("jump") && wall_jump_r.is_colliding():
		velocity.y = jump_velocity
		velocity.x = -wall_jump_pushback
	if is_on_wall() && Input.is_action_pressed("left") && Input.is_action_pressed("jump") && wall_jump_l.is_colliding():
		velocity.y = jump_velocity
		velocity.x = wall_jump_pushback

func wall_slide(delta: float) -> void:
	if is_on_wall_only():
		if Input.is_action_pressed("left") || Input.is_action_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		play_animations("wall_slide")
		velocity.y += wall_slide_gravity * delta
		velocity.y = min(velocity.y, wall_slide_gravity)
