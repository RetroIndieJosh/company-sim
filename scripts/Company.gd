extends Control

enum Action {
        FIRE,
        HIRE,
        INFO,
        PROMOTE,
        NONE
}

const Person = preload("res://scripts/Person.gd")

const MONEY_MIN = 10 * 1000
const MONEY_MAX = 100 * 1000 * 1000
const MONEY_RANGE = MONEY_MAX - MONEY_MIN

onready var info_employees = $"Info/Employees"
onready var info_company = $"Info/Company"
onready var people_list_display = $"Info/Person Selector"
onready var game = $"../.."

var action = Action.NONE
var player_controlled = true
var money = 0
var product = 0

func _process(_delta):
        update_company_info()

func _ready():
        if game == null:
                print("ERROR no game")
        #game.display_print("New company!")
        #game.display_print("Capital $", false)

func _on_Fire_pressed():
        action = Action.FIRE
        update_list()

func _on_Hire_pressed():
        action = Action.HIRE
        update_list()

func _on_Info_pressed():
        action = Action.INFO
        update_list()

func _on_Promote_pressed():
        action = Action.PROMOTE
        update_list()

func _on_Step_Down_as_CEO_pressed():
        print("Step down as CEO")

func _on_Person_Selector_item_selected(index):
        var pname = people_list_display.get_item_text(index)
        var person = game.get_person(pname)
        if person == null:
                print("Error: no person of name ", pname)
                return
        if action == Action.FIRE:
                person.fire()
                remove_child(person)
                game.display_print("Fired " + person.name)
        elif action == Action.HIRE:
                var salary = money * 0.1
                person.hire(self, salary)
                add_child(person)
                game.display_print("Hired " + person.name + " with salary $" + str(salary))
        elif action == Action.PROMOTE:
                game.display_print("Promoted " + person.name)
        game.show_person(person)
        update_list()

func update_company_info():
        if info_company == null:
                print("ERROR no company info")
                return
        info_company.text = "%s\n$%d\n" % [name, money]
        info_employees.text = "Employees:\n"
        for p in get_children():
                if p is Person:
                        info_employees.text += " - %s\n" % p.name

func update_list():
        people_list_display.clear()
        people_list_display.unselect_all()
        var people_list = []
        if action == Action.INFO:
                people_list = game.get_people_list_all()
        else:
                var target_company = null if action == Action.HIRE else self
                people_list = game.get_people_list(target_company)
        for p in people_list:
                people_list_display.add_item(p.name)
        print("list has ", people_list_display.get_item_count(), " items")

func work(eff, earn):
        product += eff
        money -= earn
