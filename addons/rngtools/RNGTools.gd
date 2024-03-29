# Copyright (c) 2021 James Westman <james@jwestman.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

class_name RNGTools
extends Object


# Generates a random integer between `from` (inclusive) and `to` (exclusive).
# If `from` equals `to`, returns it.
static func randi_range(from: int, to: int, rng=null) -> int:
	if from == to:
		return from
	elif from > to:
		var swp := from + 1
		from = to + 1
		to = swp

	return (_randi(rng) % (to - from)) + from


# Shuffles an array in-place.
static func shuffle(array: Array, rng=null):
	var size := array.size()
	for i in range(size - 1):
		var swap = randi_range(i, size)
		var tmp = array[i]
		array[i] = array[swap]
		array[swap] = tmp


# Returns one element of the array at random, or null if the array is empty.
static func pick(array: Array):
	if array.is_empty():
		return null
	else:
		#print("Array size: "+str(array.size()))
		return array[randi_range(0, array.size()-1)]


# Picks n elements of the array at random, or the entire array if its length
# is less than or equal to n. The resulting array will be in the same order as
# in the input array.
static func pick_many(array: Array, n: int, rng=null) -> Array:
	var result := []
	var size := array.size()
	var needed := float(n)
	for i in range(size):
		if _randf(rng) < needed / (size - i):
			result.append(array[i])
			needed -= 1
	return result


# Picks one element of the bag at random, according to the weights specified
# in the WeightedBag.
static func pick_weighted(bag: WeightedBag, rng=null):
	if bag.weights.is_empty():
		return null

	var n := bag._keys.size()
	var x := _randf(rng)
	var i := floor(n * x) as int
	var y := ((n * x) - i) * bag._sum

	if y >= bag._u[i]:
		i = bag._k[i]

	return bag._keys[i]


# A "bag" of weighted values. Used in conjunction with pick_weighted().
class WeightedBag:
	# See https://en.wikipedia.org/wiki/Alias_method

	# A map of keys to their weights.
	var weights := {}: set = set_weights

	# Sum of weights
	var _sum := 0
	# Probability table
	var _u: PackedInt32Array
	# Alias table
	var _k: PackedInt32Array
	# Original probabilities
	var _p: PackedInt32Array
	# Map of indices to the original keys we were given
	var _keys := []


	# Sets the weights for this bag. The keys of the dictionary may be any
	# values; they are what is returned by pick_weighted(). The dictionary
	# values are the weights, as integers.
	func set_weights(new_weights: Dictionary) -> void:
		weights = new_weights

		var n := weights.size()

		_sum = 0

		_u = PackedInt32Array()
		_u.resize(n)
		_k = PackedInt32Array()
		_k.resize(n)
		_p = PackedInt32Array()
		_p.resize(n)

		_keys = weights.keys()
		for i in range(n):
			var w: int = weights[_keys[i]]
			_sum += w
			_p[i] = w

		var overfull := []
		var underfull := []

		# Initialize the probability table
		for i in range(n):
			var u: int = n * _p[i]
			_u[i] = u
			if u > _sum:
				overfull.push_back(i)
			elif u < _sum:
				underfull.push_back(i)

		# Distribute aliases
		while not overfull.is_empty():
			var i: int = overfull.pop_back()
			var j: int = underfull.pop_back()

			_k[j] = i
			_u[i] = _u[i] + _u[j] - _sum

			if _u[i] > _sum:
				overfull.push_back(i)
			elif _u[i] < _sum:
				underfull.push_back(i)


# Drop-in replacement for randi() that uses a RandomNumberGenerator if given,
# otherwise uses randi().
static func _randi(rng) -> int:
	if rng == null:
		return randi()
	else:
		var i = rng.randi()
		return rng.randi()

# Same as _randi(), but for randf()
static func _randf(rng) -> float:
	if rng == null:
		return randf()
	else:
		return rng.randf()
