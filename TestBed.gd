extends Node2D
# https://github.com/LukeMS/lua-namegen/blob/master/data/creatures.cfg

func snap():
	var file = File.new()
	file.open("res://assets/data/names/creatures.json", File.READ)
	var data = parse_json(file.get_as_text())
	return data

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var temp_nugget = snap()
	print(RNGTools.randi_range(-10,10));
	var bag := RNGTools.WeightedBag.new()
	bag.weights = {
		A = 1,
		B = 2,
		C = 3
	}
	# "rules": "Ap %10P-B %50CD %50PD %50Cp %25E"
	print(RNGTools.pick_weighted(bag))
	var species = "human male"


	# for n in 18:
	shuffle_stuff(temp_nugget[str(species)])

func shuffle_stuff(temp_nugget):
	var result = ""
	var the_rules := temp_nugget.rules.split(", ") as Array
	var rule = ""
	# "$A$p, %10$P-$B, %50$C$D, %50$P$D, %50$C$p, %25$E"
	# Choose a rule randomly
	# If there's a percentage at the front, roll against it
	# if roll succeeds, use that rule, otherwise, roll again
	randomize()
	while [true]:
		print("Rules: "+str(the_rules))
		rule = the_rules[0] # RNGTools.pick(the_rules)
		if(rule[0]=="$"):
			# Erase the $ if it's the first char, otherwise splitting string into array won't work. 
			# print("Cleaning the $")
			rule.erase(0, 1)
			print("Rule:"+rule)
			break
		elif(rule[0]=="%"):
			var name_chunks := rule.split("$") as Array
			# print("Cleaning the $")
			name_chunks[0].erase(0, 1)
			print("Rule:"+rule)
			if(percent(int(name_chunks[0]))):
				rule.erase(0, rule.find ( "$", 1 ))
				rule.erase(0, 1)
				print("Rule:"+rule)
				break
			else:
				print("Roll failed, trying again")


	print("We're outta the while loop")

	# rule = rule.replace ( "$", "" )
	var key1 := rule.split("$") as Array
	# $s$10v$10c$10m$e
	for key in key1:
		print("key "+key)
		if key[0].is_valid_integer():
			# Quantity = int(Quantity)
			var mytestnumber = key.substr(0, key.length()-1)
			var name_part = key.substr(key.length()-1,key.length())
			print("name_part "+name_part)
			print("mytestnumber "+mytestnumber)
			if(percent(int(mytestnumber))):
				var the_array := temp_nugget[str(name_part)].split(" ") as Array
				result = result + RNGTools.pick(the_array)
				print("We have a successfull roll")
			else:
				print("Didn't succeed for roll")
		elif key=="-":
			result = result + "-"
		else:
			var name_part := temp_nugget[str(key)].split(" ") as Array
			result = result + RNGTools.pick(name_part)

	print(result)

func percent(passed_percentile):
	var result = false
	var roll = RNGTools.randi_range(1,100)
	if(roll <= passed_percentile):
		result = true
	return result
