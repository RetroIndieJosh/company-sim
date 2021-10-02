extends Node

const AGE_MIN = 18
const AGE_MAX = 25
const AGE_RANGE = AGE_MAX - AGE_MIN

const PERSONALITY_MAX = 20
const SPECIALIZATION_MAX = 20

const MONEY_MIN = 100
const MONEY_MAX = 10000
const MONEY_RANGE = MONEY_MAX - MONEY_MIN

const CONSONANTS = ["r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r",
"r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r",
"r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "t", "t", "t", "t", "t",
"t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t",
"t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "t", "n", "n",
"n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n",
"n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n", "n",
"s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s",
"s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "l", "l", "l",
"l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l", "l",
"l", "l", "l", "l", "l", "l", "l", "l", "l", "c", "c", "c", "c", "c", "c", "c",
"c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c", "c",
"d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d", "d",
"d", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p",
"p", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m", "m",
"h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "h", "g",
"g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "b", "b", "b", "b", "b",
"b", "b", "b", "b", "b", "b", "f", "f", "f", "f", "f", "f", "f", "f", "f", "f",
"y", "y", "y", "y", "y", "y", "w", "w", "w", "w", "w", "w", "w", "k", "k", "k",
"k", "k", "k", "v", "v", "v", "v", "v", "x", "x", "z", "z", "j", "q"]

const VOWELS = ["e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e",
"e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e",
"e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e",
"e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "a", "a", "a", "a",
"a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a",
"a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a",
"a", "a", "a", "a", "a", "a", "a", "i", "i", "i", "i", "i", "i", "i", "i", "i",
"i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i",
"i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "i", "o", "o", "o",
"o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o",
"o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o",
"o", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u", "u",
"u", "u", "u", "y", "y", "y"]

enum Degree {
        BACHELOR,
        MASTER,
        TERMINAL,
        COUNT
}

var age: int

var degree: int
var personality: int
var specialization: int

var happiness: float
var efficiency: float

var company: Node = null
var money: int
var salary: int

var days_worked: int = 0

onready var game = $"../.."

func _init():
        age = randi() % AGE_RANGE + AGE_MIN
        degree = randi() % Degree.COUNT
        personality = randi() % PERSONALITY_MAX
        specialization = randi() % SPECIALIZATION_MAX
        happiness = 50
        efficiency = 50
        money = randi() % MONEY_RANGE + MONEY_MIN
        generate_name()

func fire():
        company = null

func generate_name():
        var length = randi() % 6 + 3
        var is_vowel = randi() % 2 == 0
        var consecutive = 0
        for i in range(length):
                if is_vowel:
                        name += VOWELS[randi() % len(VOWELS)]
                else:
                        name += CONSONANTS[randi() % len(CONSONANTS)]
                if i == 0:
                        name = name.to_upper()

                if consecutive > 1 or randi() % 5 != 0:
                        is_vowel = not is_vowel
                        consecutive = 0
                else:
                        consecutive += 1

func get_info():
        var info = name
        info += "\n        %s" % ("unemployed" if company == null else company.name)
        info += "\n        Age: " + str(age)
        info += "\n        Personality: " + str(personality)
        info += "\n        Specialization: " + str(specialization)
        info += "\n        Happiness: " + str(happiness)
        info += "\n        Efficiency: " + str(efficiency)
        return info

func hire(comp, sal):
        company = comp
        salary = sal

func is_employed():
        return company != null

func update() -> String:
        if not is_employed():
                return ""
        days_worked += 1
        if days_worked % 14 != 0:
                return ""
        var earnings = int(salary / 26.0)
        money += earnings
        company.work(efficiency, earnings)
        return "Paid $%d to %s from company %s" % [earnings, name, company.name]
