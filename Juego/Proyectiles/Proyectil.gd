class_name Proyectil

extends Area2D

var velocidad: Vector2 = Vector2.ZERO
var danio: float


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func crear(pos: Vector2, dir: float, vel: float, danio_p: int) -> void:
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)
	danio = danio_p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocidad * delta

#Seniales internas

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	daniar(area)
	
func _on_body_entered(body: Node) -> void:
	daniar(body)

func _on_ProyectilEnemigo_area_entered(area: Area2D) -> void:
	daniar(area)

func _on_ProyectilEnemigo_body_entered(body: Node) -> void:
	daniar(body)


func daniar(otro_cuerpo: CollisionObject2D) -> void:
	if otro_cuerpo.has_method("recibir_danio"):
		otro_cuerpo.recibir_danio(danio)
	queue_free()
	







