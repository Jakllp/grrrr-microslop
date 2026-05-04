extends Node

var tasks = {
	"08:30": load("res://resources/tasks/first_task.tres"),
	"09:25": load("res://resources/tasks/second_task.tres")
}

var SuccessSound :AudioStreamPlayer
var FailSound :AudioStreamPlayer

var tasks_to_evaluate :Array[Task] = []

func reset() -> void:
	SuccessSound = null
	FailSound = null
	tasks_to_evaluate = []

func check_trigger_task(time_string :String) -> void:
	var task :Task = tasks.get(time_string)
	if task != null and !tasks_to_evaluate.has(task):
		GameData.add_task(task)
		tasks_to_evaluate.append(task)

func check_task(task :Task) -> bool:
	var successful := false
	
	if task.task_goal is SentenceGoal:
		var sentgoal :SentenceGoal = task.task_goal
		var attachm = sentgoal.attachment
		var file_data = _find_file_for_task(attachm.file_name)
		
		if file_data != null:
			var edited_file_content = GameData.file_contents.get(file_data.resource_path)
			if edited_file_content != null and edited_file_content != attachm.file_content:
				for required in sentgoal.content_contains:
					if !edited_file_content.contains(required):
						successful = false
						continue
					else: 
						successful = true
	elif task.task_goal is FailGoal:
		var failgoal :FailGoal = task.task_goal
		var attachm = failgoal.attachment
		var file_data = _find_file_for_task(attachm.file_name)
		
	
		if file_data != null:
			var edited_file_content = GameData.file_contents.get(file_data.resource_path)
			if edited_file_content != null and edited_file_content != attachm.sheets:
				var cells :Dictionary = edited_file_content.get(0).get("cells")
				for required in failgoal.content_contains:
					if !cells.values().has(required):
						successful = false
						continue
					else: 
						successful = true
	
	if successful:
		tasks_to_evaluate.erase(task)
		SuccessSound.play()
	else:
		FailSound.play()
		
	return successful

func _find_file_for_task(name :String) -> FileData:
	for file in GameData.saved_files:
		if file.file_name == name:
			return file
	return null

func check_end_of_day() -> bool:
	return tasks_to_evaluate.is_empty()
