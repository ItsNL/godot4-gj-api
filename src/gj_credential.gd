extends Resource
class_name GameJoltCredential

@export var accountIndex : int = 0
@export var User : String = ""
@export var Token : String = ""

const path = "user://gj/"

func save_credentials():
	ResourceSaver.save(self, path + "0.tres")

func load_credentials():
	if ResourceLoader.exists(path + "0.tres"):
		return load(path + "0.tres")
