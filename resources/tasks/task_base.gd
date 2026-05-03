class_name Task
extends Resource

@export var task_subject :String
@export var task_sender :String
@export_multiline var task_content :String
@export var task_goal :TaskGoal
@export var attachments: Array[FileData]
