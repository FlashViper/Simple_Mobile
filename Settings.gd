# static container of preferences
extends Node
const filepath := "user://settings.json"

var settings := {
	"invert-controls": true,
	"torque-correction": true,
	"lower-falling-gravity": true
}

func _enter_tree() -> void:
	loadSettings()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			save()

func save() -> void:
	var save := JSON.print(settings, "\t")
	var f := File.new()
	var err := f.open(filepath, File.WRITE)
	if err != OK:
		printerr("Error saving settings: ", err)
		return
	print(save)
	f.store_string(save)
	f.close()

func loadSettings() -> void:
	var txt := Utility.loadFileText(filepath)
	if !txt: return
#	print("txt: " + txt)
	settings = parse_json(txt)

func setSetting(name:String, value) -> void:
	settings[name] = value
	save()
