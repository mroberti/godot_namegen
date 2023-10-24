extends Node2D
# https://github.com/LukeMS/lua-namegen/blob/master/data/creatures.cfg
var rulesText = load_json("res://assets/data/names/rules2.txt")
var parse_dict = {
"s":"syllablesStart",
"m":"syllablesMiddle",
"e":"syllablesEnd",
"p":"syllablesPre",
"P":"syllablesPost",
"v":"phonemesVocals",
"c":"phonemesConsonants",
"A":"customGroupA",
"B":"customGroupB",
"C":"customGroupC",
"D":"customGroupD",
"E":"customGroupE",
"F":"customGroupF",
"G":"customGroupG",
"H":"customGroupH",
"N":"customGroupN",
"O":"customGroupO"
}

var species = "dwarf male 2"

var main_rules = {}
	
func load_json(filename):
	var file = filename
	var the_contents = FileAccess.get_file_as_string(file)
	#var data = JSON.parse_string(json_as_text)
	return the_contents

func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false
	
func _ready():
	# Split the loaded data into lines
	var lines = rulesText.split("\n")
	var parentNode = ""
	# Iterate through the lines
	for line in lines:
		# Check if the line does not contain "//" (a comment) and is not blank

		if(!(line.contains("//")) && line != ""):
			if(line.contains("name \"")):
				parentNode=line.split("\"")[1]
				main_rules[parentNode]={}
				##print(parentNode)
			if(line.contains("=")):
				# The key name
				var key = line.split("=")[0].strip_edges(true,true)
				##print("Key: "+key)
				# The value of the key
				var value = line.split("=")[1].strip_edges(true,true)
				value = value.replace("\"", "")
				value = value.replace(",", "")
				# #print("Value: "+value)
				main_rules[parentNode][""+key+""] = value.split(" ") as Array
	
	for i in range(0,100):
		add_output(random_name("aasimar male")+" "+random_name("halfling surname"))

func random_name(theSpecies):
	var result = ""
	var pickedRule
	while true:
		pickedRule = RNGTools.pick(main_rules[""+theSpecies+""]["rules"])
		#print("rule: "+pickedRule)
		if pickedRule[0]=="%":
			# OK we have a percentile rule, let's trim up
			# the string and what not to pass to percent
			var tempChunks = pickedRule.split("$") as Array
			var percent = tempChunks[0].right(tempChunks[0].length()-1)
			#print("Roll D100 "+percent)
			#print(percent(percent))
			if(percent(percent)):
				#print("WIIIIIIIIINNNNNNNNNNN!!!")
				result = process_rule(pickedRule,theSpecies)
				break
		else:
			#print("bort!")
			result = process_rule(pickedRule,theSpecies)
			break
	return result

func percent(passed_percentile):
	passed_percentile = int(passed_percentile)
	#print("Percent "+str(passed_percentile))
	var result = false
	var roll = RNGTools.randi_range(1,100)
	#print("Roll: "+str(roll))
	if(roll <= passed_percentile):
		result = true
		print("Passed")
	return result

func process_rule(the_rule, theSpecies):
	var result = ""
	#print("Received rule: "+the_rule)
	var rule_chunks = the_rule.split("$")
	for i in range(0,rule_chunks.size()):
		if(i>0):
			#print(rule_chunks[i])
			if(rule_chunks[i].length()==1):
				result = result + RNGTools.pick(main_rules[""+theSpecies+""][""+parse_dict[""+rule_chunks[i]+""]+""])
			elif(rule_chunks[i][0].is_valid_int()):
				#print("Hey it's a number!")
				var extracted_percentile = ""
				var extracted_rule_chunk = ""
				var suffix = ""
				for letter in rule_chunks[i]:
					if(letter.is_valid_int()):
						extracted_percentile += letter
					else:
						if(has_letters(letter)):
							extracted_rule_chunk += letter
						else:
							suffix+=letter 
				if(percent(extracted_percentile)):
					result = result + RNGTools.pick(main_rules[""+theSpecies+""][""+parse_dict[""+extracted_rule_chunk+""]+""])
					result = result + suffix
				#print("Extracted percentile: "+extracted_percentile)
			else:
				var extracted_rule_chunk = ""
				var suffix = ""
				for letter in rule_chunks[i]:
					if(has_letters(letter)):
						result += RNGTools.pick(main_rules[""+theSpecies+""][""+parse_dict[""+letter+""]+""])
					else:
						suffix+=letter 
				result = result + suffix
	return result

func add_output(theString):
	$output_console.text = $output_console.text + theString +"\n"

func has_letters(your_string):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(your_string)):
		print(true)
		return true
	else:
		print(false)
		return false
