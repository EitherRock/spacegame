extends Node

var resources = {
	"coal": {"amount": 0, "max":5, "dependencies": {}},
	"ore": {"amount": 0, "max":5, "dependencies": {"coal": 5}},
	"metal": {"amount": 0, "max":5, "dependencies": {"ore": 5}},
	"ship": {"amount": 0, "max":5, "dependencies": {"ore": 5}}
}

var facilities = {
	"cave": ["coal", "ore"],
	"smelter": ["metal"],
	"processing": ['material']
}
