extends Node

var tasks = {
	"08:04": load("res://resources/tasks/sample_task.tres")
}

var tasks_to_evaluate :Array[Task] = []

func check_trigger_task(time_string :String) -> void:
	var task :Task = tasks.get(time_string)
	if task != null and !tasks_to_evaluate.has(task):
		print(task.task_subject + " " + task.task_sender + " " + task.task_content)
		tasks_to_evaluate.append(task)

func check_task(task :Task) -> bool:
	var successful := false
	match task.task_goal:
		SentenceTask:
			pass
		_:
			pass
	if successful:
		tasks_to_evaluate.erase(task)
	return successful

func check_end_of_day() -> bool:
	return tasks_to_evaluate.is_empty()
