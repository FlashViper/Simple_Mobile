extends CheckButton

export var settingName := ""

func _ready():
	pressed = SettingsManager.settings.get(settingName, pressed)
	connect("pressed", self, "onPressed")

func onPressed() -> void:
	SettingsManager.setSetting(settingName, pressed)
