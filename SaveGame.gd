extends Node

const SAVE_PATH := "user://save.txt"

var levelIndex := 0
var skin := 0
var skinsUnlocked := PoolIntArray(range(0, 7))
var levelStates := {}

func _enter_tree() -> void:
	loadState()

func isSkinUnlocked(newSkin:int) -> bool:
	if skin == 0: return true
	return (skinsUnlocked as Array).has(newSkin)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			saveState()

func saveState() -> void:
	var f := File.new()
	var err := f.open(SAVE_PATH, File.WRITE)
	if err != OK:
		printerr("Error while loading file: ", err)
		return
	
	var state := jsonConvert()
	f.store_string(state)
	f.close()

func jsonConvert() -> String:
	var dict := inst2dict(self) as Dictionary
	dict.erase("@path")
	dict.erase("@subpath")
	return JSON.print(dict, " ")

func deleteSave() -> void:
	var d := Directory.new()
	var err := d.remove(SAVE_PATH)
	if err != OK:
		printerr("Error whilst deleting save: ", err)
	else:
		levelIndex = 0
		skin = 0
		skinsUnlocked = PoolIntArray(range(0,7))
		levelStates = {}

func loadState() -> void:
	var stateJSON := Utility.loadFileText(SAVE_PATH)
	if !stateJSON: return
	var state := parse_json(stateJSON) as Dictionary
	for s in state:
		match s:
			"levelStates":
				for s2 in state[s]:
					levelStates[int(s2)] = state[s][s2]
			_:
				if (s as String) in self:
					set(s, state[s])
