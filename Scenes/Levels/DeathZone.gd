extends Node2D

func _on_deathzone_area_entered(area):
	var player = area.get_owner()
	
	player.HealthDepleted = true
