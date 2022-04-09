extends Control

const SKINS := "0-6,12-15"
onready var displaySkin := SaveGame.skin

func _ready():
	var skins := PoolIntArray()
	var segments: PoolStringArray = SKINS.split(",", false)
	for s in segments:
		if "-" in s:
			var n1 := int(s.split("-")[0])
			var n2 := int(s.split("-")[1])
			skins.append_array(range(n1, n2 + 1))
		else:
			skins.append(int(s))
	
	for s in skins:
		var b := Button.new()
		b.rect_min_size = Vector2.ONE * 40
		$GridContainer.add_child(b)
		b.connect("pressed", self, "onSkinButtonPressed", [s])

func _process(delta: float) -> void:
	$Sprite.frame = displaySkin

func onSkinButtonPressed(index: int) -> void:
	displaySkin = index
	if SaveGame.isSkinUnlocked(index):
		SaveGame.skin = index
