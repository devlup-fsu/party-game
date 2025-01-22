extends RigidBody3D
class_name Fuel

var parent_generator: FuelGenerator = null
var carrier: FactoryPlayer = null
var being_carried: bool = false
var is_dangerous: bool = false # check for if a fuel cell can stun a player
