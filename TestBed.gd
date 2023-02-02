extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func snap():
	var file = File.new()
	file.open("res://assets/data/names/creatures.json", File.READ)
	var data = parse_json(file.get_as_text())
	return data

# Called when the node enters the scene tree for the first time.
func _ready():
	var temp_nugget = snap()
	print(RNGTools.randi_range(-10,10));
	var bag := RNGTools.WeightedBag.new()
	bag.weights = {
		A = 1,
		B = 1,
		C = 3,
	}
	print(RNGTools.pick_weighted(bag))
	var species = "aasimar female"

	# for n in 18:
	shuffle_stuff(temp_nugget[str(species)])

func shuffle_stuff(temp_nugget):
	var result = ""
	var the_rules = temp_nugget.rules.split(" ")

	for key in the_rules[0]:
		print("key "+key)
		if key.is_valid_integer():
			print("We have a number")
		else:
			var name_part := temp_nugget[str(key)].split(" ") as Array
			result = result + RNGTools.pick(name_part)

	print(result)

func percent(passed_percentile):
	pass;
