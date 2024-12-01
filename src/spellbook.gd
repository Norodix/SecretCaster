extends VBoxContainer

var secret_script

func _ready() -> void:
	secret_script = secret.new()
	add_child(secret_script)
	SignalBus.spell_used.connect(spell_used_callback)
	for child in get_children():
		if "text" in child:
			child.text = ""


var types_used = []
var index = 0
func spell_used_callback(type : int):
	if not type in types_used:
		types_used.append(type)
		write_label(type)
		index += 1

func write_label(type : int):
	var l : Label = get_children()[index]
	l.text = ""
	l.text += SignalBus.displaynames[type] + "\n"
	for p in secret_script.get_action_array(SignalBus.nodenames[type]):
		l.text += secret_script.display_text[p] + "\n"
