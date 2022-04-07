# static container of preferences
extends Node
#const filepath

var settings := {
	"invert-controls": true,
	"torque-correction": true,
	"lower-falling-gravity": true
}

#func _enter_tree() -> void:
#	loadSettings()
#
#func _notification(what: int) -> void:
#	match what:
#		NOTIFICATION_WM_QUIT_REQUEST:
#			save()
#
#func save() -> void:
#	var save := JSON.print(settings, "\t")
#	var f := File.new()
#	var err := f.open("/user/", File.WRITE)
#	if err != OK:
#		printerr("Error saving settings: ", err)
#		return
#	f.store_string(save)
#	f.close()
#
#func loadSettings() -> void:
#	settings = Utility.loadFile("")
