extends Node2D
# https://github.com/LukeMS/lua-namegen/blob/master/data/creatures.cfg

func load_json(filename):
	var file = filename
	var json_as_text = FileAccess.get_file_as_string(file)
	var data = JSON.parse_string(json_as_text)
	return data

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var temp_nugget = load_json("res://assets/data/names/creatures.json")
	print(RNGTools.randi_range(-10,10));
	var bag := RNGTools.WeightedBag.new()
	bag.weights = {
		A = 1,
		B = 2,
		C = 3
	}
	# "rules": "Ap %10P-B %50CD %50PD %50Cp %25E"
	print(RNGTools.pick_weighted(bag))
	var species = "corporations"

	for n in 1:
		print(n)
		shuffle_stuff(temp_nugget[str(species)])

func shuffle_stuff(temp_nugget):
	var result = ""
	var the_rules := temp_nugget.rules.split(", ") as Array
	var rule = ""
	print(the_rules)
	# "$A$p, %10$P-$B, %50$C$D, %50$P$D, %50$C$p, %25$E"
	# Choose a rule randomly
	# If there's a percentage at the front, roll against it
	# if roll succeeds, use that rule, otherwise, roll again
	randomize()
	while [true]:
		rule = RNGTools.pick(the_rules)
		print("First char:"+rule[0])
		if(rule[0]=="$"):
			# Erase the $ if it's the first char, otherwise splitting string into array won't work. 
			rule.erase(0, 1)
			print("Rule:"+rule)
			break
		# elif(rule[1]=="%"):
		# 	print(rule[1])
		# 	var name_chunks := rule.split("$") as Array
		# 	# Erase the $ if it's the first char, otherwise splitting string into array won't work. 
		# 	name_chunks[0].erase(0, 1)
		# 	print("Rule:"+rule)
		# 	if(percent(int(name_chunks[0]))):
		# 		rule.erase(0, rule.find ( "$", 1 ))
		# 		rule.erase(0, 1)
		# 		# print("Rule:"+rule)
		# 		break

	# rule = rule.replace ( "$", "" )

	# var key1 := rule.split("$") as Array
	# for key in key1:
	# 	if key[0].is_valid_int():
	# 		# Quantity = int(Quantity)
	# 		var mytestnumber = key.substr(0, key.length()-1)
	# 		var name_part = key.substr(key.length()-1,key.length())
	# 		if(percent(int(mytestnumber))):
	# 			var the_array := temp_nugget[str(name_part)].split(" ") as Array
	# 			result = result + RNGTools.pick(the_array)
	# 	else:
	# 		var suffix = ""
	# 		# print("key "+key)
	# 		if(key.length()>1):
	# 			# print("key[0] "+key[0])
	# 			var name_part := temp_nugget[str(key[0])].split(" ") as Array
	# 			# print("key[1] "+key[1])
	# 			var temp := key.split(str(key[0])) as Array
	# 			# print("Array "+temp[1])
	# 			result = result + (RNGTools.pick(name_part) + temp[1])
	# 			# ^^ Add a dash to the end of the word
	# 		else:
	# 			var name_part := temp_nugget[str(key[0])].split(" ") as Array
	# 			result = result + RNGTools.pick(name_part)
	# result = result.replace ( "_", " " )
	# print(result)

func percent(passed_percentile):
	var result = false
	var roll = RNGTools.randi_range(1,100)
	if(roll <= passed_percentile):
		result = true
	return result

func testingSnippets():
	for i in 10:
		print(i)
