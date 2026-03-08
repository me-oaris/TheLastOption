extends Area2D
func _on_darkness_zone_body_entered(body):
	if body.is_in_group("Player"): 
		if body.has_method("_on_darkness_zone_body_entered"):
			body._on_darkness_zone_body_entered(self)

func _on_darkness_zone_body_exited(body):
	if body.is_in_group("Player"):
		if body.has_method("_on_darkness_zone_body_exited"):
			body._on_darkness_zone_body_exited(self)
