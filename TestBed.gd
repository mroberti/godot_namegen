extends Node2D
# https://github.com/LukeMS/lua-namegen/blob/master/data/creatures.cfg
var name_rules = load_json("res://assets/data/names/creatures.json")
func load_json(filename):
	var file = filename
	var json_as_text = FileAccess.get_file_as_string(file)
	var data = JSON.parse_string(json_as_text)
	return data

func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	make_name("tengu male")
	make_name("tengu male")

func make_name(the_name_type):
	var tempSlap = name_rules
	var name1 = random_name(tempSlap[str(the_name_type)])
	$output_console.text = $output_console.text + (name1) + "\n"
	name1 = name1.left(name1.length() - 1)
	var location1 = random_name(tempSlap[str("map locations")])
	#var location2 = random_name(tempSlap[str("map locations")])
	print(name1+"'s "+location1)
	$output_console.text = $output_console.text + (name1+"'s "+location1)+"\n"
	
func random_name(race1):
	var race = race1
	for key in race:
		if(key!="rules"):
			print("Key: "+key)
			print(race[key])
			race[key] = race[key].split(" ") as Array
			#print(race[key])

	var result = ""
	var the_rules := race.rules.split(" ") as Array
	the_rules.sort()
	print(the_rules) # Prints [[4, Tomato], [5, Potato], [9, Rice]].
	for i in range(the_rules.size() - 1, - 1, -1):
		#print(the_rules[i])
		if(the_rules[i].contains("%")):
			the_rules[i].erase(0, 1)
			var parsedString = the_rules[i].split("$") as Array
			if(percent(int(parsedString[0]))):
				for j in range(parsedString.size()):
					if(j!=0):
						result = result + RNGTools.pick(race[""+parsedString[j]+""])+" "
				break
			else:
				the_rules.remove_at(i)
		else:
			#print("remaining rules: "+str(the_rules))
			var theRule = RNGTools.pick(the_rules)
			#print("Picking a remaining non % rule: "+theRule)
			var parsedString = theRule.split("$") as Array
			#print(parsedString)
			for j in range(parsedString.size()):
				#print("j "+str(j))
				if(parsedString[j] !=""):
					if(has_letters_and_numbers(parsedString[j])):
						#print("Has numbers and letters")
						# Expected format is $s$80e$25e, so the last
						# letter is the key, but we need to do a percent
						# check on that remaining number...
						#print("Pre parsing: "+parsedString[j])
						var check = int(parsedString[j].erase(parsedString[j].length()-1, parsedString[j].length()))
						var thekey = parsedString[j].erase(0, parsedString[j].length()-1)
						#print("Key "+thekey)
						#print("check "+str(check))
						if(percent(check)):
							result = result + RNGTools.pick(race[""+thekey+""])+" "
					else:
						#print("Has only letters")
						#print("parsedString[j] "+parsedString[j])
						result = result + RNGTools.pick(race[""+parsedString[j]+""])+" "
					
	return result



func percent(passed_percentile):
	print("Percent "+str(passed_percentile))
	var result = false
	var roll = RNGTools.randi_range(1,100)
	print("Roll: "+str(roll))
	if(roll <= passed_percentile):
		result = true
	return result

func testingSnippets():
	for i in 10:
		print(i)

func has_letters_and_numbers(your_string):
	var regex = RegEx.new()
	regex.compile("[0-9][0-9]+[a-zA-Z]")
	if regex.search(str(your_string)):
		return true
	else:
		return false

func has_letters(your_string):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]")
	if regex.search(str(your_string)):
		return true
	else:
		return false

