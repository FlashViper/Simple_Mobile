extends Control

const SKINS := "0-5,12-15"
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
	
	# pixel location: (22, 40)
	var tex := preload("res://Sprites/robot_drone.png").get_data().duplicate()
	tex.lock()
	for s in skins:
		var b := Button.new()
		b.rect_min_size = Vector2.ONE * 40
		$GridContainer.add_child(b)
		b.connect("pressed", self, "onSkinButtonPressed", [s])
		b.self_modulate = tex.get_pixel(
			64 * (s % 4) + 22,
			64 * (s as int / 4) + 40
		)
		
		if !SaveGame.isSkinUnlocked(s):
			var t := TextureRect.new()
			var a := AtlasTexture.new()
			a.atlas = preload("res://Sprites/mechanics.png")
			a.region = Rect2(224,128,32,32)
			t.texture = a
			b.add_child(t)
			t.rect_position = Vector2()
			t.rect_size = b.rect_size
			t.expand = true
			t.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

func _process(delta: float) -> void:
	$Sprite.frame = displaySkin

func onSkinButtonPressed(index: int) -> void:
	displaySkin = index
	if SaveGame.isSkinUnlocked(index):
		SaveGame.skin = index
		SaveGame.saveState()
