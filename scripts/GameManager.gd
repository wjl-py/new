extends Node

@export var session_duration_seconds: float = 120.0
@export var points_correct: int = 100
@export var points_incorrect: int = -50

var time_left: float
var score: int = 0
var streak: int = 0

var current_question: Dictionary = {}
var rng := RandomNumberGenerator.new()

@onready var score_label: Label = $UI/HUD/ScoreLabel
@onready var time_label: Label = $UI/HUD/TimeLabel
@onready var streak_label: Label = $UI/HUD/StreakLabel
@onready var question_label: Label = $UI/HUD/QuestionLabel
@onready var answer_label: Label = $UI/HUD/AnswerLabel
@onready var feedback_label: Label = $UI/HUD/FeedbackLabel

func _ready() -> void:
	time_left = session_duration_seconds
	add_to_group("game_manager")
	rng.randomize()
	update_hud()
	show_next_paper()

func _process(delta: float) -> void:
	if time_left <= 0.0:
		return
	time_left -= delta
	if time_left <= 0.0:
		time_left = 0.0
		_end_game()
	update_hud_time()

func _input(event: InputEvent) -> void:
	if time_left <= 0.0:
		return
	if event.is_action_pressed("grade_correct"):
		_grade(true)
	elif event.is_action_pressed("grade_incorrect"):
		_grade(false)

func _grade(mark_as_correct: bool) -> void:
	var is_student_correct: bool = current_question.get("student_is_right", false)
	var is_correct_judgement := (mark_as_correct == is_student_correct)
	if is_correct_judgement:
		score += points_correct
		streak += 1
		_feedback(true)
	else:
		score += points_incorrect
		streak = 0
		_feedback(false)
	update_hud()
	show_next_paper()

func _feedback(was_correct: bool) -> void:
	feedback_label.text = was_correct ? "✓ 正确判定!" : "✗ 判定错误!"
	feedback_label.modulate = was_correct ? Color(0.3, 1.0, 0.4) : Color(1.0, 0.3, 0.3)
	feedback_label.visible = true
	get_tree().create_timer(0.7).timeout.connect(func(): feedback_label.visible = false)

func show_next_paper() -> void:
	current_question = _generate_question()
	question_label.text = current_question.get("question_text", "?")
	answer_label.text = current_question.get("student_answer_text", "")

func _generate_question() -> Dictionary:
	var a := rng.randi_range(1, 20)
	var b := rng.randi_range(1, 20)
	var op_index := rng.randi_range(0, 2)
	var correct_value := 0
	var op_text := "+"
	match op_index:
		0:
			correct_value = a + b
			op_text = "+"
		1:
			correct_value = a - b
			op_text = "-"
		2:
			correct_value = a * b
			op_text = "×"
	var show_value := correct_value
	var student_is_right := rng.randf() < 0.6
	if not student_is_right:
		var delta := rng.randi_range(1, 3) * (rng.randf() < 0.5 ? -1 : 1)
		show_value = correct_value + delta
	var question_text := "%d %s %d = ?" % [a, op_text, b]
	var student_answer_text := "学生答案: %d" % show_value
	return {
		"question_text": question_text,
		"student_answer_text": student_answer_text,
		"student_is_right": student_is_right,
	}

func update_hud() -> void:
	update_hud_time()
	score_label.text = "分数: %d" % score
	streak_label.text = "连击: %d" % streak

func update_hud_time() -> void:
	time_label.text = "时间: %ds" % int(round(time_left))

func _end_game() -> void:
	feedback_label.text = "时间到! 最终分数: %d" % score
	feedback_label.modulate = Color(1, 1, 0.3)
	feedback_label.visible = true
