class_name SpreadsheetData
extends FileData

@export var rows: int = 50
@export var columns: int = 20

# Example:
# [
#   {
#     "title": "Sheet 1",
#     "cells": {
#       "A1": "Name",
#       "B1": "Score",
#       "A2": "Bob"
#     }
#   }
# ]
@export var sheets: Array[Dictionary] = []
