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
"N":"customGroupN",
"O":"customGroupO"
}

var species = "giant male"

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
	# Assuming you have already loaded the provided file data into a variable named "rulesText"

	# Initialize an empty string to store the filtered data
	var filtered_data = ""

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
			# Append the line to the filtered data
			filtered_data += line + "\n"
	
	for i in range(0,100):
		var pickedRule
		while true:
			pickedRule = RNGTools.pick(main_rules[""+species+""]["rules"])
			print("rule: "+pickedRule)
			if pickedRule[0]=="%":
				# OK we have a percentile rule, let's trim up
				# the string and what not to pass to percent
				var tempChunks = pickedRule.split("$") as Array
				var percent = tempChunks[0].right(tempChunks[0].length()-1)
				#print("Roll D100 "+percent)
				#print(percent(percent))
				if(percent(percent)):
					#print("WIIIIIIIIINNNNNNNNNNN!!!")
					process_rule(pickedRule)
					break
			else:
				#print("bort!")
				process_rule(pickedRule)
				break


func percent(passed_percentile):
	passed_percentile = int(passed_percentile)
	#print("Percent "+str(passed_percentile))
	var result = false
	var roll = RNGTools.randi_range(1,100)
	#print("Roll: "+str(roll))
	if(roll <= passed_percentile):
		result = true
	return result

func process_rule(the_rule):
	var result = ""
	print("Received rule: "+the_rule)
	var rule_chunks = the_rule.split("$")
	for i in range(0,rule_chunks.size()):
		if(i>0):
			# #print("ah? "+rule_chunks[i])
			# #print(parse_dict[""+rule_chunks[i]+""])
			result = result + RNGTools.pick(main_rules[""+species+""][""+parse_dict[""+rule_chunks[i]+""]+""])
			# #print(main_rules["dwarf male"][""+parse_dict[chunk]+""])
	#print("Result: "+result)
	add_output(result)
	return result

func add_output(theString):
	$output_console.text = $output_console.text + theString +"\n"
