class_name SectorMeteoritos


extends Node2D


func _on_Timer_timeout() -> void:
	for spawner in $Spawners.get_children():
		spawner.spawnear_meteorito()
