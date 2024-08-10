extends Area2D

signal hit
signal scored


func _on_body_entered(body):
	hit.emit()


func _on_score_area_area_entered(area):
	scored.emit()
