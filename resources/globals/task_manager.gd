extends Node

var tasks = {
	"08:04": load("res://resources/tasks/first_task.tres")
}

var tasks_to_evaluate :Array[Task] = []

func check_trigger_task(time_string :String) -> void:
	var task :Task = tasks.get(time_string)
	if task != null and !tasks_to_evaluate.has(task):
		GameData.add_task(task)
		tasks_to_evaluate.append(task)

func check_task(task :Task) -> bool:
	var successful := false
	
	if task.task_goal is SentenceGoal:
		var sentgoal :SentenceGoal = task.task_goal
		var file = _find_file_for_task(sentgoal.attachment.file_name)
		
		if file != null and file.file_content != sentgoal.attachment.file_content:
			for required in sentgoal.content_contains:
				if !file.file_content.contains(required):
					successful = false
					continue
				else: 
					successful = true
	
	if successful:
		tasks_to_evaluate.erase(task)
	return successful

func _find_file_for_task(name :String) -> FileData:
	for file in GameData.saved_files:
		if file.file_name == name:
			return file
	return null

func check_end_of_day() -> bool:
	return tasks_to_evaluate.is_empty()
