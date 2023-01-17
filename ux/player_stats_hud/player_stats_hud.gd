extends Node2D

class PlayerStatsFrame:
	extends Node2D
	var test_mode : bool = false
	var timestamp_class = preload("res://globals/timestamp.gd")
	var nb_points = 48
	var line_color = Color(0, 0, 0)
	var imageFolder : String
	var appInfoFontData : DynamicFontData
	var charDisplayFont : DynamicFont
	var global_sprite_cache = { }
	var global_font_cache = { }
	
	var portrait_image_resource : String
	var title_font_resource : String
	var character_title : String
	var title_text_color : Color
	var title_height : int
	var frame_color : Color
	var frame_top_left : Vector2
	var frame_extent : Vector2
	var portrait_offset : Vector2
	
	func assignFont(tag : String, fontObject : Font):
		if (tag != null):
			if global_font_cache.has(tag) == false:
				global_font_cache[tag] = fontObject

	func draw_border(topLeft : Vector2, bottomRight : Vector2, draw_color, line_thickness = 4.0):
		var points_border = PoolVector2Array()
		var width = bottomRight.x - topLeft.x
		var height = bottomRight.y - topLeft.y
		points_border.push_back(topLeft)
		points_border.push_back(Vector2(topLeft.x + width, topLeft.y))
		points_border.push_back(bottomRight)
		points_border.push_back(Vector2(topLeft.x, topLeft.y + height))
		points_border.push_back(topLeft)
		draw_polyline(points_border, draw_color, line_thickness, true)

	func draw_text(startCoord: Vector2, fontTag : String, draw_color : Color, text : String):
		var fontObj = global_font_cache[fontTag]
		draw_string(fontObj, startCoord, text)

	func load_sprite_fromcache(folderspec, sprite_resource):
		if global_sprite_cache.has(sprite_resource):
			return global_sprite_cache[sprite_resource]
		var res = null
		var pre_path = null
		if folderspec != null:
			pre_path = folderspec
		var sprite_resource_file = sprite_resource
		if (pre_path != null):
			sprite_resource_file = pre_path + "/" + sprite_resource_file
		var sprite_Image = load(sprite_resource_file)
		global_sprite_cache[sprite_resource] = sprite_Image
		res = global_sprite_cache[sprite_resource]
		return res

	func draw_tileset_image(folderspec, sprite_res, columns, rows, image_draw_sequence, sprite_position):
		if (image_draw_sequence == null) or (image_draw_sequence.size() <= 0):
			return
		var pre_path = null
		if folderspec != null:
			pre_path = folderspec
		var sprite_cache_image = load_sprite_fromcache(pre_path, sprite_res)
		if (sprite_cache_image != null):
			var sprite_height = sprite_cache_image.get_height() / rows
			var sprite_width = sprite_cache_image.get_width() / columns
			for image_spec in image_draw_sequence:
				var unit_width = image_spec.get_spansize().x
				var unit_height = image_spec.get_spansize().y
				var origin_x = image_spec.get_coordinate().x
				var origin_y = image_spec.get_coordinate().y
				var placement_rect = Rect2(sprite_position, Vector2(sprite_width * unit_width, sprite_height * unit_height))
				var image_rect = Rect2(Vector2(origin_x * sprite_width, origin_y * sprite_height), Vector2(sprite_width * unit_width, sprite_height * unit_height))
				draw_texture_rect_region(sprite_cache_image, placement_rect, image_rect)

	func draw_sprite_image(folderspec, sprite_res, sprite_position):
		var pre_path = null
		if folderspec != null:
			pre_path = folderspec
		var sprite_cache_image = load_sprite_fromcache(pre_path, sprite_res)
		if (sprite_cache_image != null):
			draw_texture(sprite_cache_image, sprite_position)

	func _draw():
		appInfoFontData = DynamicFontData.new()
		charDisplayFont = DynamicFont.new()
		var sprite_position = Vector2(20, 22)
		if test_mode:
			appInfoFontData.font_path = "res://assets/fonts/PixelAE-Regular.ttf"
			charDisplayFont.size = 16
			charDisplayFont.font_data = appInfoFontData
			imageFolder = "res://assets/images/npc"
			var portrait_character = "tin-man-pose.png"
			assignFont("characterDisplay", charDisplayFont)
			draw_text(Vector2(12, 18), "characterDisplay", Color.antiquewhite, "Tin Man")
			draw_border(Vector2(2, 2), Vector2(90, 98), Color(0.85, 0.475, 0.0), 4)
			draw_sprite_image(imageFolder, portrait_character, sprite_position)
		else:
			appInfoFontData.font_path = title_font_resource
			charDisplayFont.size = title_height
			charDisplayFont.font_data = appInfoFontData
			assignFont("characterDisplay", charDisplayFont)
			draw_text(portrait_offset, "characterDisplay", title_text_color, character_title)
			draw_border(frame_top_left, frame_top_left + frame_extent, frame_color, 2)
			draw_sprite_image(null, portrait_image_resource, sprite_position)
		
	func _ready():
		set_process(true)
		
	func _process(delta):
		update()

export (String) var portrait_image_resource
export (String) var title_font_resource
export (String) var character_title
export (int) var title_height
export (Color) var title_text_color
export (Color) var frame_color
export (Vector2) var frame_top_left
export (Vector2) var frame_extent
export (Vector2) var portrait_offset
export (Dictionary) var player_stats

var player_hud : PlayerStatsFrame

# Called when the node enters the scene tree for the first time.
func _ready():
	player_hud = PlayerStatsFrame.new()
	#player_hud.test_mode = true
	if (player_hud != null):
		add_child(player_hud)
	player_hud.portrait_image_resource = portrait_image_resource
	player_hud.portrait_offset = portrait_offset
	player_hud.title_font_resource = title_font_resource
	player_hud.title_text_color = title_text_color
	player_hud.title_height = title_height
	player_hud.frame_color = frame_color
	player_hud.character_title = character_title
	player_hud.frame_top_left = frame_top_left
	player_hud.frame_extent = frame_extent
	set_process(true)
