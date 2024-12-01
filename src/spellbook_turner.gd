extends Label

var types_used = []
var secret_script

func _ready() -> void:
	secret_script = secret.new()
	add_child(secret_script)
	SignalBus.spell_used.connect(spell_used_callback)
	write_label()


func spell_used_callback(type : int):
	if not type in types_used:
		types_used.append(type)
		index = index + 1
		write_label()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("page_left"):
		index -= 1
		write_label()
	if Input.is_action_just_pressed("page_right"):
		index += 1
		write_label()


var index = 0
func write_label():
	if types_used.size() < 1:
		text = ""
		return
	index %= types_used.size()
	var type = types_used[index]
	text = ""
	text += SignalBus.displaynames[type] + "\n\n"
	for p in secret_script.get_action_array(SignalBus.nodenames[type]):
		text += secret_script.display_text[p] + "\n"
