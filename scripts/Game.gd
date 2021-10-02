extends HBoxContainer

const Person = preload("res://scripts/Person.gd")

onready var company_tabs = $"Company Tabs"
onready var display_container = $"Output/Main"
onready var display = $"Output/Main/Text"
onready var person_info = $"Output/Info"
onready var prefab_company = preload("res://scenes/Company.tscn")

var companies = []
var day = 0
var people = []

func _ready():
        print("Output: ", $"Output")
        print("Output/Main: ", $"Output/Main")
        print("Output/Main/Text: ", $"Output/Main/Text")
        randomize()
        display_clear()
        for _i in range(10):
                var person = Person.new()
                people.append(person)
                add_child(person)

func comma_sep(number):
        var string = str(number)
        var mod = string.length() % 3
        var res = ""

        for i in range(0, string.length()):
                if i != 0 && i % 3 == mod:
                        res += ","
                res += string[i]

        return res

func display_clear():
        display.text = ""

func display_num(n: int, newline:bool=true):
        var ns = comma_sep(n)
        display_print(ns, newline)

func display_print(s:String, newline:bool=true):
        if display == null:
                print("ERROR no display (clear)")
                #display = $"Output/Main/Text"
                #if display == null:
                        #print("ERROR no display (clear)")
                        #return
        display.text += s
        if newline:
                display.text += "\n"
        display_container.scroll_vertical = display_container.get_v_scrollbar().max_value

func end_day():
        day += 1
        display_print("Day %d ended")
        for c in companies:
                display_print("%s: " % c.name)
                display_num(c.money)

func get_people_list(target_company):
        var people_list = []
        for p in people:
                if p.company == target_company:
                        people_list.append(p)
        return people_list

func get_people_list_all():
        return people

func get_person(name):
        for p in people:
                if p.name == name:
                        return p
        return null

func show_person(person):
        person_info.text = person.get_info()

func tick():
        for c in companies:
                c.update_employees()
        end_day()

func _on_New_Company_pressed():
        var company = prefab_company.instance()
        company_tabs.add_child(company)
