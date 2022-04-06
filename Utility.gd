# base utility function with only static functions (I think)
class_name Utility extends Object

static func getDirectory(path: String, extension := "") -> PoolStringArray:
	var dir := Directory.new()
	var result := PoolStringArray()
	var err := dir.open(path)
	if err != OK:
		printerr("Could no  t open directory --> ", err)
		return PoolStringArray()
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			if extension == "" or file_name.ends_with(extension):
				result.append(file_name)
		file_name = dir.get_next()
	
	return result

static func loadFile(path: String, mode := File.READ) -> File:
	var f := File.new()
	if f.open(path, File.READ) == OK:
		return f
	
	printerr("couldn't load file at ", path)
	return null

static func loadFileText(path: String) -> String:
	var f := loadFile(path)
	if f != null:
		return f.get_as_text()
	return ""

static func loadFileLines(path: String) -> PoolStringArray:
	return loadFileText(path).split("\n", false)
