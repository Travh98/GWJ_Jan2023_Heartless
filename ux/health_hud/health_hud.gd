extends Node2D

class HealthPanel:
	extends Node2D
	var test_mode : bool = false
	var timestamp_class = preload("res://globals/timestamp.gd")
	
	var appInfoFontData : DynamicFontData
	var charDisplayFont : DynamicFont
	var global_sprite_cache = { }
	var global_font_cache = { }
	var title_font_resource : String
	var panel_title : String
	var title_text_color : Color
	var title_height : int
	var frame_color1 : Color
	var frame_color2 : Color
	var frame_top_left : Vector2
	var frame_extent : Vector2
	var frame_border_width : int
	
	func assignFont(tag : String, fontObject : Font):
		if (tag != null):
			if global_font_cache.has(tag) == false:
				global_font_cache[tag] = fontObject

	func draw_border(topLeft : Vector2, bottomRight : Vector2, draw_color, draw_color2, thickness1 = 2.0, thickness2 = 2.0):
		var points_border = PoolVector2Array()
		points_border.push_back(topLeft)
		points_border.push_back(Vector2(bottomRight.x, topLeft.y))
		points_border.push_back(bottomRight)
		points_border.push_back(Vector2(topLeft.x, bottomRight.y))
		points_border.push_back(topLeft)
		draw_polyline(points_border, draw_color, thickness1, true)
		if thickness2 >= 1.0:
			var points_border2 = PoolVector2Array()
			points_border2.push_back(topLeft + Vector2(thickness1 - 1, thickness1 - 1))
			points_border2.push_back(Vector2(bottomRight.x - (thickness1 - 1), topLeft.y + thickness1 - 1))
			points_border2.push_back(bottomRight - Vector2(thickness1 - 1, thickness1 - 1))
			points_border2.push_back(Vector2(topLeft.x + thickness1 - 1, bottomRight.y - thickness1 + 1))
			points_border2.push_back(topLeft + Vector2(thickness1 - 1, thickness1 - 1))
			draw_polyline(points_border2, draw_color2, thickness2, true)
		
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

	func draw_sprite_image(folderspec, sprite_res, sprite_position):
		var pre_path = null
		if folderspec != null:
			pre_path = folderspec
		var sprite_cache_image = load_sprite_fromcache(pre_path, sprite_res)
		if (sprite_cache_image != null):
			draw_texture(sprite_cache_image, sprite_position)

	func _draw():
		appInfoFontData = DynamicFontData.new()
		appInfoFontData.font_path = title_font_resource
		charDisplayFont = DynamicFont.new()
		charDisplayFont.size = title_height
		charDisplayFont.font_data = appInfoFontData
		#var sprite_position = Vector2(20, 18)
		var title_offset = frame_top_left + Vector2(12, 4 + title_height)
		assignFont("characterDisplay", charDisplayFont)
		draw_text(title_offset, "characterDisplay", title_text_color, panel_title)
		draw_border(frame_top_left, frame_top_left + frame_extent, frame_color1, frame_color2, frame_border_width - 2.0, 2.0)
		#draw_sprite_image(null, portrait_image_resource, sprite_position)

export (String) var title_font_resource
export (String) var panel_title
export (int) var title_height
export (int) var frame_border_width = 5
export (Color) var title_text_color
export (Color) var frame_color1
export (Color) var frame_color2
export (Vector2) var frame_top_left
export (Vector2) var frame_extent

onready var health_bar: TextureProgress = $ProgressHealthbar

var health_panel_instance : HealthPanel

func _ready():
	health_panel_instance = HealthPanel.new()
	if (health_panel_instance != null):
		add_child(health_panel_instance)
	#health_panel_instance.portrait_image_resource = portrait_image_resource
	#health_panel_instance.portrait_offset = portrait_offset
	health_panel_instance.title_font_resource = title_font_resource
	health_panel_instance.title_text_color = title_text_color
	health_panel_instance.title_height = title_height
	health_panel_instance.frame_color1 = frame_color1
	health_panel_instance.frame_color2 = frame_color2
	health_panel_instance.panel_title = panel_title
	health_panel_instance.frame_top_left = frame_top_left
	health_panel_instance.frame_extent = frame_extent
	health_panel_instance.frame_border_width = frame_border_width
	set_process(true)
