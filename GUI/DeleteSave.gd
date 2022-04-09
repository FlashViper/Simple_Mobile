extends Popup

func _ready():
	$Panel/yes.connect("pressed", self, "delete")

func delete() -> void:
	if $Panel/CheckButton.pressed:
		SaveGame.deleteSave()
	hide()
