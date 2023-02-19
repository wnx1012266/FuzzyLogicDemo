extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	attack_interval = 0.3#rand_range(0.1,1.0)
	
	pass # Replace with function body.

export var attack_interval = 1.0
var _attack_interval = 0.0

var check_angle_interval = 0.1
var _check_angle_interval = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#func _process(delta):
	var Enemys = get_tree().get_nodes_in_group("Enemys")
	var targetThreatValue = null
	var target = null
	for a in Enemys:
		var result = getThreat(a)
		var vThreat = result[0]
		
		if targetThreatValue==null or vThreat > targetThreatValue:
			targetThreatValue = vThreat
			target = a
			attack_interval = result[1]
			
	#if _check_angle_interval<=0:
	pointTo(target)
	#attack_interval = caculateAttackSpeed(target)
	if target!=null:
		if _attack_interval<=0:
			#attack(target)
			attack2()
			_attack_interval = attack_interval
	_attack_interval -= delta	
	pass
	

var fireToVec = Vector2(0,-1)

func pointTo(target):
	if target==null:
		return
		
#	var ang = a.angle_to(b) # 派 #-1.57（-90degree)  1.57(90 degree) , ang = 0 mean degree = 0.
	
	var vec = $Position2D.global_position - self.global_position
	var vecTarget = target.global_position - self.global_position
	var ang = vec.angle_to(vecTarget)
	

	var Fuzzy = FuzzyLogic.new()
	
	
	var mFarLeft     =   Fuzzy.FuzzyReverseGrade(ang, -1.57, -1.0) #value is angle...
	var mLeft        =   Fuzzy.FuzzyTrapezoid(ang, -1.0, -0.8, -0.2, 0.0)#value is angle...
	var mAhead       =   Fuzzy.FuzzyTriangle(ang, -0.2, 0.0,0.2)#value is angle...
	var mRight       =   Fuzzy.FuzzyTrapezoid(ang, 0.0, 0.2, 0.8, 1.0)#value is angle...
	var mFarRight    =   Fuzzy.FuzzyGrade(ang, 1.0, 1.57)#value is angle...

	var FL = -0.03 	#FarLeft 
	var FR = 0.03	#FarRight
	var NetForce= mFarLeft * FL + mLeft * FL + mRight * FR + mFarRight * FR
	print("NetForce: ",NetForce)
	self.rotate(NetForce)
	
	fireToVec =  ($Position2D.global_position - self.global_position).normalized()

var preloadBullet = preload("res://Bullet.tscn")

func attack2():
	var dirt = fireToVec
	var bullet = preloadBullet.instance()
	bullet.position = self.position
	bullet.setDirt(dirt)
	bullet.setAngle(fireToVec.angle())
	get_parent().add_child(bullet)
	

func getThreat(target):
	var blockHouse = get_parent().get_node("blockhouse")
	var _range = blockHouse.position.distance_to(target.position)
	
	var _force = target.force
	
	var FL = FuzzyLogic.new()
	#Range Fuzzy sets
	var mClose = FL.FuzzyTriangle(_range,0.0,0.0,150.0)
	var mMedium = FL.FuzzyTrapezoid(_range,100.0,200.0,350.0,450.0)
	var mFar = FL.FuzzyGrade(_range,400.0,500.0)
	#Force size fuzzy sets
	var mTiny =FL.FuzzyTriangle(_force,-10.0,0.0,10.0)
	var mSmall = FL.FuzzyTrapezoid(_force,5.0,10.0,20.0,25.0)
	var mModerate = FL.FuzzyTrapezoid(_force,20.0,25.0,35.0,40.0)
	var mLarge = FL.FuzzyGrade(_force,35.0,40.0)

	
	var Threat_mLow = FL.FuzzyOR(\
						FL.FuzzyOR(\
							FL.FuzzyOR(FL.FuzzyAND(mMedium,mTiny),FL.FuzzyAND(mMedium,mSmall)),\
							FL.FuzzyOR(FL.FuzzyAND(mFar,mTiny),FL.FuzzyAND(mFar,mSmall))\
								),\
							FL.FuzzyAND(mFar,mModerate))
							
	var Threat_mMedium = FL.FuzzyAND(mClose,mTiny)
	Threat_mMedium = FL.FuzzyOR(Threat_mMedium,FL.FuzzyAND(mMedium,mModerate))
	Threat_mMedium = FL.FuzzyOR(Threat_mMedium,FL.FuzzyAND(mFar,mLarge))
	
	var Threat_mHigh = FL.FuzzyAND(mClose,mSmall)
	Threat_mHigh = FL.FuzzyOR(Threat_mHigh,FL.FuzzyAND(mClose,mModerate))
	Threat_mHigh = FL.FuzzyOR(Threat_mHigh,FL.FuzzyAND(mClose,mLarge))
	Threat_mHigh = FL.FuzzyOR(Threat_mHigh,FL.FuzzyAND(mMedium,mLarge))

	#Defuzzification 
	var maxThreat = ( max(0,Threat_mLow)*10 +  max(0,Threat_mMedium)*30 + max(0,Threat_mHigh)*50 )/ (max(0,Threat_mLow)+max(0,Threat_mMedium)+max(0,Threat_mHigh))
	#print("maxThreat is :",maxThreat)
	
	var ThreatLowAttackSpeed=  1.0 #base attack speed
	var ThreatMediumAttackSpeed=  0.5#base attack speed
	var ThreatHightAttackSpeed=  0.1#base attack speed
	
	var attackSpeed = 0.01
	if (Threat_mLow+Threat_mMedium+Threat_mHigh)!=0:
		var A = ThreatLowAttackSpeed * max(0.0,Threat_mLow)
		var B = ThreatMediumAttackSpeed* max(0.0,Threat_mMedium)
		var C = ThreatHightAttackSpeed* max(0.0,Threat_mHigh)
		attackSpeed = (max(0.0,A) + max(0.0,B) + max(0.0,C))/(max(0.0,Threat_mLow)+max(0.0,Threat_mMedium)+max(0.0,Threat_mHigh))
	
	return [maxThreat,attackSpeed]
