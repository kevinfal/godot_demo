extends KinematicBody2D
#this script is for movement
const UP = Vector2(0,-1) #game knows this direction is up
const DOWN = Vector2(0,1)
const LEFT = Vector2(-1,0)
const RIGHT = Vector2(1,0)


var motion = Vector2() #direction/ velocity

#movement related variables
export var speed = 200 #export means it shows up in the editor
export var gravity = 10
export var jumpForce = -375
var wallJumpForce = jumpForce + 100
var dashSpeed = speed + 200


var walls
var tracker = 648
var jumpflag = false
var restricted = 0
var dashTimer = 0
var dashCoolDown = 0
var inAir = false

func isDashing():
		return dashTimer > 0 
func dashOnCoolDown():
	return dashCoolDown >0
func isRestricted():
	return restricted > 0
func inAir():
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		return false
	else:
		return true

func _physics_process(delta):#does this every frame

	var children = get_children()
	var standingSprite = children[0]
	var leftSprite = children[1]
	var rightSprite = children[2]

	#wall jumping
	if(is_on_wall()):
		
		dashCoolDown = 0
		motion.y = gravity
		
		if(Input.is_key_pressed(KEY_Z)):
					dash()
		
		#walljumping conditions
		if(Input.is_action_just_pressed("ui_up") or Input.is_key_pressed(KEY_SPACE)):
				restricted = 15
				
				
				
				if Input.is_action_pressed("ui_right"):
					
					rightSprite.visible = true
					leftSprite.visible = false
					
					motion.x += -200 #x value increases right by the speed
					motion.y = wallJumpForce
				
				elif Input.is_action_pressed("ui_left"):
					leftSprite.visible = true
					rightSprite.visible = false
					
					motion.x += 200
					motion.y = wallJumpForce
		else:
			restricted = 0
				
	else: #character is not sliding down wall
		motion.y += gravity #pushes character down "gravity"
		
	
	if Input.is_action_pressed("ui_right") and !isRestricted():
		rightSprite.visible = true
		leftSprite.visible = false
		motion.x = speed #x value increases right by 100
		if isDashing():
			motion.x = dashSpeed
	elif Input.is_action_pressed("ui_left") and !isRestricted():
		leftSprite.visible = true
		rightSprite.visible = false
		motion.x = speed * -1
		if isDashing():
			motion.x = dashSpeed * -1
	else: #not pressing left or right stops or moves up n down
		leftSprite.visible = false
		rightSprite.visible = false
		if(!isRestricted()):
			motion.x = 0 #stops character horizontaly

	if(is_on_floor()):
		jumpflag = true
		inAir = false
		if(Input.is_action_just_pressed("ui_up") or Input.is_key_pressed(KEY_SPACE)):
			
			motion.y = jumpForce
			jumpflag = false
		#dashing
		if(Input.is_key_pressed(KEY_Z)):
			dash()

		
	if(global_position[0] >= tracker):
		
		walls = get_parent().get_child(1)
		var dist = 100 #distance between random blocks
		var lastPos = walls.get_child(walls.get_child_count()-1).global_position #position of last block
		for x in range(0,10):
			
			var wall = walls.get_child(0).duplicate(1)
			wall.position = Vector2(lastPos[0] + dist, rand_range(lastPos[1] -80, lastPos[1] + 100))
			walls.add_child(wall)
			lastPos[0] += dist
		tracker += dist * 10
		
	if inAir() and isDashing():
		dashTimer += 5
		
	if(isRestricted()):
		restricted -= 1
	if(isDashing()):
		dashTimer -= 1
	if(dashOnCoolDown()):
		dashCoolDown -=1
		
	#so if I want to print anything Or call any functions it has to happen after here
	#after 2 hrs i realized this jfc
	#this is because there is no main, so this is essentially main I guess
	#everything here happens after the fact
	print(isDashing())
	motion = move_and_slide(motion, UP)
	


#end of physics method

#i'm putting movement functions here
func dash():
	if(!isDashing() and !dashOnCoolDown()):
					dashTimer = 40
					dashCoolDown = dashTimer + 5 
					
	
