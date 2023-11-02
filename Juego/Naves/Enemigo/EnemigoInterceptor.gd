class_name EnemigoInterceptor

extends EnemigoBase





func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if  anim_name == "spawn":
		controlar_estados(ESTADO.VIVO)
