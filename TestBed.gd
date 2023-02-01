extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func snap():
	var file = File.new()
	file.open("res://assets/data/names/infernal 3.json", File.READ)
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
		C = 3
	}
	print(temp_nugget["A"][0])
	var s = ["The Wrathful","The People's","The Immortal","The Evil","God's"]
	var m = ["Steadfast","Righteous","Industrial","Holy","Glorious","Democratic","Bold"]
	var A =["Yellow","White","Western","Victory","Upward","Unified","True","Steel","Southern","Social","Silver","Scarlet","Royal","Republican","Red","Purple","Progressive","Popular","Orange","Northern","National","Linear","Liberty","Liberal","Iron","Homeland","Grey","Green","Gold","Freedom","Federal","Emerald","Eastern","Cyan","Crimson","Conservative","Bronze","Blue","Black","Austere","Ascendant","Amber"]
	var e = ["Alliance","Association","Band","Circle","Clan","Combine","Company","Cooperative","Corporation","Enterprises","Faction","Group","Megacorp","Multistellar","Organization","Outfit","Pact","Partnership","Ring","Society","Sodality","Syndicate","Union","Unity","Zaibatsu"]
	# "rules": "_%40$s$m$A$e $s$m$e$e"
	randomize()


	# print(RNGTools.pick_weighted(bag))
	# print(temp_nugget.rules)
	temp_nugget.rules = temp_nugget.rules.replace("$", "")
	temp_nugget.rules = temp_nugget.rules.replace("_", "")
	var the_rule = temp_nugget.rules.split(",")
	for n in 18:
		shuffle_stuff(the_rule[0],temp_nugget)
	# Now next step is to load and parse the rules, and see 
	# About programatically calling said rules like temp.e,temp.s, etc. neg

func shuffle_stuff(the_rule,temp_nugget):
	var result = ""
	for digit in the_rule:
		# print(digit)
		var splat := temp_nugget[str(digit)].split(",") as Array
		splat.shuffle()
		result = result + splat[0]
	print(result)
