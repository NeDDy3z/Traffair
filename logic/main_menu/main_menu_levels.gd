extends Control




## Start Kbely level on kbely selection
func _on_kbely_button_pressed():
	get_tree().change_scene_to_file(Global.levels["kbely"])


## Start Ruzyne level on ruzyne selection
func _on_ruzyne_button_pressed():
	get_tree().change_scene_to_file(Global.levels["ruzyne"])


## Close level selection menu
func _on_close_pressed():
	self.visible = false
