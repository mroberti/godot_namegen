extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(RNGTools.randi_range(-10,10));
	var bag := RNGTools.WeightedBag.new()
	bag.weights = {
		A = 1,
		B = 1,
		C = 3
	}
	var s = ["The_Wrathful","The_People's","The_Immortal","The_Evil","The God's"]
	var m = ["Steadfast","Righteous","Industrial","Holy","Glorious","Democratic","Bold"]
	var A =["Yellow","White","Western","Victory","Upward","Unified","True","Steel","Southern","Social","Silver","Scarlet","Royal","Republican","Red","Purple","Progressive","Popular","Orange","Northern","National","Linear","Liberty","Liberal","Iron","Homeland","Grey","Green","Gold","Freedom","Federal","Emerald","Eastern","Cyan","Crimson","Conservative","Bronze","Blue","Black","Austere","Ascendant","Amber"]
	var e = ["Alliance","Association","Band","Circle","Clan","Combine","Company","Cooperative","Corporation","Enterprises","Faction","Group","Megacorp","Multistellar","Organization","Outfit","Pact","Partnership","Ring","Society","Sodality","Syndicate","Union","Unity","Zaibatsu"]
	# "rules": "_%40$s$m$A$e $s$m$e$e"
	randomize()
	for n in 8:
		shuffle_stuff(s,m,A,e)

	print(RNGTools.pick_weighted(bag))


func shuffle_stuff(s,m,A,e):
	s.shuffle()
	m.shuffle()
	A.shuffle()
	e.shuffle()
	print(s[0]+" "+m[0]+" "+A[0]+" "+e[0])
	print(s[0]+" "+m[0]+" "+e[0])
