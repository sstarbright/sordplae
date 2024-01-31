extends Spatial

onready var ray_cast = get_node("RayCast")
onready var mesh = get_node("Mesh")
const right_angle = PI/2
export var shadow_ratio = 1.0
export var min_radius = 0.1
export var max_radius = 0.25

func _physics_process(_delta):
	if ray_cast.is_colliding():
		mesh.global_transform = Transform.IDENTITY.translated(ray_cast.get_collision_point())\
		.looking_at(ray_cast.get_collision_point()+ray_cast.get_collision_normal().rotated(Vector3.LEFT, right_angle), Vector3.UP)
		mesh.visible = true
		mesh.mesh.top_radius = clamp(lerp(max_radius, min_radius, (translation.y-mesh.translation.y)/shadow_ratio), min_radius, max_radius)
		mesh.mesh.bottom_radius = mesh.mesh.top_radius
	else:
		mesh.visible = false
