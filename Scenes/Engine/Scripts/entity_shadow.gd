extends Spatial

onready var ray_cast = get_node("RayCast")
onready var model = get_node("Model")
onready var mesh = get_node("Model/Mesh")
const right_angle = PI/2
const up_rotation = Vector3(-right_angle, 0.0, 0.0)
export var shadow_ratio = 1.0
export var min_radius = 0.1
export var max_radius = 0.25

func _physics_process(_delta):
	if ray_cast.is_colliding():
		if ray_cast.get_collision_normal() != Vector3.UP:
			model.global_transform = Transform.IDENTITY.translated(ray_cast.get_collision_point()).looking_at(ray_cast.get_collision_point()+ray_cast.get_collision_normal(), Vector3.UP)
		else:
			model.global_translation = ray_cast.get_collision_point()
			model.global_rotation = up_rotation
		mesh.visible = true
		mesh.mesh.top_radius = clamp(lerp(max_radius, min_radius, (translation.y-model.translation.y)/shadow_ratio), min_radius, max_radius)
		mesh.mesh.bottom_radius = mesh.mesh.top_radius
	else:
		mesh.visible = false
