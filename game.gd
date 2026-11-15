extends Control

var day = 1

var oxygen = 100
var water = 100
var food = 100
var electricity = 100
var solar_generation = 20
var power_consumption = 15
var dust_storm = false
var greenhouse_production = 6
var greenhouse_power_consumption = 5
var battery_used_today = false
var electrolysis_used_today = false
var shielding_level = 0
var shielding_materials = 3

func _on_end_day_button_pressed():
	day += 1
	
	battery_used_today = false
	electrolysis_used_today = false
	
	$DayLabel.text = "Mission Day: " + str(day)
	
	if electricity >= greenhouse_power_consumption:
		electricity -= greenhouse_power_consumption
	else:
		greenhouse_production = 0
		$GreenhouseCard/VBoxContainer/Label2.text = " FOOD PRODUCTION : INACTIVE"
	
	oxygen = max(0, oxygen - 6)
	water = max(0, water-7)
	food = max(0, food-3+greenhouse_production)
	
	dust_storm = randf() < 0.7

	var actual_solar = solar_generation
	
	if dust_storm: 
		actual_solar = solar_generation * 0.7
		$MissionStatusLabel.text = "DUST STORM! SOLAR POWER REDUCED ! "
	
	electricity = max(0, electricity-power_consumption+actual_solar)
	
	$HBoxContainer/OxygenCard/VBoxContainer/OxygenBar.value = oxygen
	$HBoxContainer/WaterCard/VBoxContainer2/WaterBar.value = water
	$HBoxContainer/FoodCard/VBoxContainer2/FoodBar.value = food
	$HBoxContainer/ElectricityCard/VBoxContainer3/ElectricityBar.value = electricity
	
	if oxygen <= 0 or water <= 0 or food <= 0 or electricity <= 0:
		$MissionStatusLabel.text = "MISSION Failed !"
		$EndDayButton.disabled = true
		return
	
	if day >= 15:
		$MissionStatusLabel.text = "MISSION COMPLETED !"
		$EndDayButton.disabled = true

var battery = 10

func upgrade_battery():
	if battery_used_today == false:
		battery_used_today = true
		$HBoxContainer/ElectricityCard/VBoxContainer3/ElectricityBar.value = electricity+25
		$BatteryUpgradeButton.text = " BATTERY CONNECTED ! "
		$BatteryUpgradeButton.text = " CONNECT BATTERY TO THE MAIN (+25) ! "
		battery -= 1
		$BatteryCapacity.text = "Battery Left : " + str(battery)
		if battery == 0:
			$BatteryUpgradeButton.disabled = true

func produce_oxygen_pressed():
	if electrolysis_used_today == false:
		electrolysis_used_today = true
		oxygen += 5
		$OxygenProductionCard/VBoxContainer/OxygenProduction.text = "OXYGEN PRODUCTION : ACTIVE"
		$OxygenProductionCard/VBoxContainer/OxygenProduction.text = "OXYGEN PRODUCTION : INACTIVE"
		$HBoxContainer/ElectricityCard/VBoxContainer3/ElectricityBar.value = electricity-20
		$produce_oxygen_pressed.disable = true

func shielding_pressed():
	if shielding_materials > 0 and shielding_level < 4:
		shielding_materials -= 1
		shielding_level += 1
		$HBoxContainer/ShieldingCard/VBoxContainer/Label2.text = "SHIELDING LEVEL : " + str(shielding_level)
		$HBoxContainer/ShieldingCard/VBoxContainer/Label3.text = "Sheilding Materials : " + str(shielding_materials)
		$HBoxContainer/ElectricityCard/VBoxContainer3/ElectricityBar.value = electricity-10
func mine_resources():
	shielding_materials += 1
	$HBoxContainer/ShieldingCard/VBoxContainer/Label3.text = "Sheilding Materials : " + str(shielding_materials)
	$HBoxContainer/ElectricityCard/VBoxContainer3/ElectricityBar.value = electricity-8
