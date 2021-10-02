extends HBoxContainer

const Person = preload("res://scripts/Person.gd")

const CREDIT_MIN = 200
const CREDIT_MAX = 800

onready var auto_advance_button = $"Output/Auto Advance"
onready var auto_advance_progress = $"Output/Auto Advance Progress"
onready var display_container = $"Output/Main"
onready var display = $"Output/Main/Text"
onready var main_info = $"Tabs/Main/Info"
onready var person_info = $"Output/Info"
onready var prefab_company = preload("res://scenes/Company.tscn")
onready var tabs = $"Tabs"

var company_cost = 10000
var loan_amount = 50000
var loan_max = loan_amount * 3

var credit_score = 400

var day = 1
var money = 0

var companies = []
var loans = []
var people = []

var auto_advance = false
var elapsed = 0.0
var sec_per_day = 5

class Loan:
        const APR_MIN = 0.03
        const APR_MAX = 0.07
        const APR_RANGE = APR_MAX - APR_MIN 

        var apr: float
        var amount: int

        func _init(loan, credit_score):
                amount = loan
                var credit_percent = float(credit_score - CREDIT_MIN) / CREDIT_MAX
                print("credit percent ", credit_percent)
                apr = credit_percent * APR_RANGE + APR_MIN

        func min_payment() -> int:
                return int(ceil(0.2 * amount))

        func month() -> int:
                var interest_rate = apr / 12.0
                var interest = int(floor(interest_rate * amount))
                self.amount += interest
                return interest

        func pay(payment):
                amount -= payment

func _process(delta):
        main_info.text = "Money: $" + comma_sep(money) + "\n"
        main_info.text += "Loans: $" + comma_sep(total_loans()) + " (" + comma_sep(len(loans)) + ")\n"
        if not auto_advance:
                return
        elapsed += delta
        auto_advance_progress.value = elapsed / sec_per_day
        if elapsed > sec_per_day:
                elapsed -= sec_per_day
                end_day()

func _ready():
        print("Output: ", $"Output")
        print("Output/Main: ", $"Output/Main")
        print("Output/Main/Text: ", $"Output/Main/Text")
        randomize()
        display_clear()
        for _i in range(10):
                var person = Person.new()
                people.append(person)

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

func display_print(s:String="", newline:bool=true):
        if display == null:
                print("ERROR no display (clear)")
        display.text += s
        if newline:
                display.text += "\n"
        display_container.scroll_vertical = display_container.get_v_scrollbar().max_value

func end_day():
        for p in people:
                var msg = p.update()
                if msg != "":
                        display_print(msg)
        display_print("Day %d ended." % day)
        if day % 30 == 0:
                for loan in loans:
                        var interest = loan.month()
                        display_print("Loan interest: $", false)
                        display_num(interest)

                        var minimum_payment = loan.min_payment()
                        money -= minimum_payment
                        loan.pay(minimum_payment)
                        display_print("Deducted minimum payment of $", false)
                        display_num(minimum_payment)

        for c in companies:
                display_print("%s: " % c.name)
                display_num(c.money)
        display_print()
        day += 1

func get_people_list(target_company):
        var people_list = []
        for p in people:
                if p.company == target_company:
                        people_list.append(p)
        return people_list

func get_people_list_all():
        return people

func get_person(name) -> Person:
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

func total_loans() -> int:
        var loan_total = 0
        for loan in loans:
                loan_total += loan.amount
        return loan_total

func _on_New_Company_pressed():
        if money < company_cost:
                display_print("Not enough capital to establish company (minimum $", false)
                display_num(company_cost, false)
                display_print("). Consider taking out a loan!\n")
                return
        var company = prefab_company.instance()
        money -= company_cost
        company.money = company_cost
        tabs.add_child(company)

func _on_Next_Day_pressed():
        end_day()

func least_loan_index() -> int:
        var least_loan = 0xFFFFFFFF
        var index = -1
        for i in range(len(loans)):
                if loans[i].amount < least_loan:
                        least_loan = loans[i].amount
                        index = i
        return index

func _on_Repay_Loan_pressed():
        if len(loans) == 0:
                display_print("No loans to repay!\n")
                return
        var index = least_loan_index()
        var repayment = loans[index].amount
        if money < repayment:
                display_print("Cannot repay loan, minimum $%d.\n" % repayment)
                return
        display_print("Repaid $", false)
        display_num(repayment, false)
        display_print(" loans.\n")
        money -= repayment
        loans.remove(index)

func _on_Take_Loan_pressed():
        if total_loans() + loan_amount > loan_max:
                display_print("Banks refused loan. Repay old loans first.")
                return
        var loan = Loan.new(loan_amount, credit_score)
        loans.append(loan)
        money += loan_amount
        display_print("Took loan $", false)
        display_num(loan_amount, false)
        display_print(" (APR %d%%)" % (100 * loan.apr))


func _on_Next_Month_pressed():
        for _i in range(30):
                _on_Next_Day_pressed()

func _on_Auto_Advance_toggled(button_pressed):
        auto_advance = button_pressed
        #auto_advance_button.disable = not auto_advance

func _on_HScrollBar_value_changed(value):
        sec_per_day = value + 1
        auto_advance_button.text = "AUTO ADVANCE (%ds/day)" % sec_per_day
