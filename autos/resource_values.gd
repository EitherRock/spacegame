extends Node

var resources = {
	"ore": {"amount": 0, "max":5, "dependencies": {}},
	"metal": {"amount": 0, "max":5, "dependencies": {"ore": 5}},
	"ship": {"amount": 0, "max":5, "dependencies": {"ore": 5}}
}
