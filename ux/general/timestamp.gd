extends Node

class timestamp:
	var current_ticks
	var start_ticks
	var hour = 0
	var minute = 0
	var second = 0
	var milli_second = 0
	
	func _init(thour = 0, tminute = 0, tsecond = 0, tmilli = 0):
		start_ticks = OS.get_ticks_msec()
		hour = thour
		minute = tminute
		second = tsecond
		milli_second = tmilli
	func get_hour():
		return hour
	func get_minute():
		return minute
	func get_second():
		return second
	func get_millisecond():
		return milli_second
	func reset_time():
		var timestamp1 = OS.get_datetime()
		start_ticks = OS.get_ticks_msec()
		current_ticks = start_ticks
		#print("timestamp=", timestamp1)
		hour = timestamp1.hour
		minute = timestamp1.minute
		second = timestamp1.second
		milli_second = current_ticks % 1000
	func update_time():
		current_ticks = OS.get_ticks_msec()
		var msecs_difference = current_ticks - start_ticks
		if (msecs_difference > 0):
			var timestamp_update = OS.get_datetime(current_ticks)
			hour = timestamp_update.hour
			minute = timestamp_update.minute
			second = timestamp_update.second
			milli_second = current_ticks % 1000
	func subtract_ticks(timestampvalue):
		if (timestampvalue != null):
			return (current_ticks - timestampvalue.current_ticks)
		else:
			return -1
