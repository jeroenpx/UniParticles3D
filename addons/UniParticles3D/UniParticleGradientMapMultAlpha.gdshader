shader_type spatial;
render_mode unshaded, blend_premul_alpha, depth_draw_opaque, cull_disabled;

uniform sampler2D albedo_texture : source_color, repeat_disable;
uniform sampler2D gradient_texture : source_color, hint_default_white,repeat_disable;

instance uniform int particles_anim_h_frames : hint_range(1, 128) = 1;
instance uniform int particles_anim_v_frames : hint_range(1, 128) = 1;
instance uniform bool particles_anim_loop = false;

//uniform vec4 override_instance_custom;
varying vec4 instance_custom;
varying vec2 rotated_uv;

vec3 hue_change(vec3 input_color, float shift_hue) {
	vec3 color_hsv;
	{
		vec3 c = input_color;
		vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
		vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
		vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
		float d = q.x - min(q.w, q.y);
		float e = 1.0e-10;
		color_hsv=vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	}
	color_hsv.x = mod((color_hsv.x + shift_hue), 1.0f);
	vec3 color_rgb;
	{
		vec3 c = color_hsv;
		vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
		vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		color_rgb=c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
	}
	return color_rgb.rgb;
}

void vertex() {
	instance_custom = INSTANCE_CUSTOM;

	//if (override_instance_custom.x > -0.01) {
		//instance_custom = override_instance_custom;
		//COLOR = vec4(0.0,0.0,0.0,1.0);
	//}

	// Get the direction of motion from the model matrix's forward vector (Z axis)
	vec3 velocity_dir = normalize(MODEL_MATRIX[2].xyz);

	// Get custom scales and parameters
	float scale_x = instance_custom.y;
	float scale_y = instance_custom.z;
	float angle = instance_custom.x;
	float stretch = instance_custom.w;

	// Get view direction (from object to camera)
	vec3 view_dir = normalize(INV_VIEW_MATRIX[2].xyz);

	// Calculate how parallel the view is to the velocity
	float parallel_factor = abs(dot(velocity_dir, view_dir));

	// Setup billboard orientation vectors
	vec3 billboard_right = normalize(INV_VIEW_MATRIX[0].xyz);
	vec3 billboard_up = normalize(INV_VIEW_MATRIX[1].xyz);

	if (abs(COLOR.b) > 0.6) {
		if (COLOR.b < -0.01) {
			// Calculate rotation to align with velocity
			float vel_angle = atan(dot(velocity_dir, billboard_right), dot(velocity_dir, billboard_up));

			// Rotate the billboard vectors to align with velocity
			vec3 new_up = (billboard_up * cos(vel_angle) + billboard_right * sin(vel_angle));
			vec3 new_right = (-billboard_up * sin(vel_angle) + billboard_right * cos(vel_angle));
			// Apply scaling
			billboard_right = new_right * scale_x;
			billboard_up = new_up * scale_y;
		} else {
			billboard_right *= scale_x;
			billboard_up *= scale_y;
		}
		// Apply additional rotation if needed
		vec2 uv_center = vec2(0.5, 0.5);
		vec2 uv_offset = UV - uv_center;
		float cos_a = cos(angle);
		float sin_a = sin(angle);
		rotated_uv = vec2(
			uv_offset.x * cos_a - uv_offset.y * sin_a,
			uv_offset.x * sin_a + uv_offset.y * cos_a
		) + uv_center;

		// Simple billboard matrix
		mat4 mat_world = mat4(
			vec4(billboard_right, 0.0),
			vec4(billboard_up, 0.0),
			vec4(view_dir, 0.0),
			MODEL_MATRIX[3]);

		// Preserve original scale
		mat4 scale_mat = mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));

		MODELVIEW_MATRIX = VIEW_MATRIX * mat_world * scale_mat;
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	} else {
		// Project velocity onto view plane
		vec3 projected_vel = velocity_dir - view_dir * dot(velocity_dir, view_dir);
		float proj_length = length(projected_vel);

		// Improved stretch factor calculation
		float view_aligned_factor = smoothstep(0.0, 0.3, proj_length);
		float effective_stretch = mix(stretch, stretch * 0.25, parallel_factor * parallel_factor);
		effective_stretch = mix(effective_stretch, stretch, view_aligned_factor);

		// Calculate stretch direction
		vec3 stretch_dir = normalize(mix(velocity_dir, projected_vel, view_aligned_factor));

		// Calculate angle between up vector and stretch direction
		float vel_angle = atan(dot(stretch_dir, billboard_right), dot(stretch_dir, billboard_up));

		// Apply custom scales to the billboard vectors
		billboard_right *= scale_x;
		billboard_up *= scale_y;

		// Rotate and stretch the vectors
		vec3 new_up = (billboard_up * cos(vel_angle) + billboard_right * sin(vel_angle));
		vec3 new_right = (-billboard_up * sin(vel_angle) + billboard_right * cos(vel_angle));

		float abs_stretch = (effective_stretch);
		billboard_up = new_up * abs_stretch;
		billboard_right = new_right * (1.0 / sqrt(abs_stretch));
		// Calculate rotated UV coordinates
		vec2 uv_center = vec2(0.5, 0.5);
		vec2 uv_offset = UV - uv_center;
		float cos_a = cos(angle + (COLOR.b > 0.1 ? vel_angle : 0.0));
		float sin_a = sin(angle + (COLOR.b > 0.1 ? vel_angle : 0.0));
		rotated_uv = vec2(
			uv_offset.x * cos_a - uv_offset.y * sin_a,
			uv_offset.x * sin_a + uv_offset.y * cos_a
		) + uv_center;

		// Construct final billboard matrix
		mat4 mat_world = mat4(
			vec4(billboard_right, 0.0),
			vec4(billboard_up, 0.0),
			vec4(view_dir, 0.0),
			MODEL_MATRIX[3]);

		// Preserve original scale
		mat4 scale_mat = mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));

		MODELVIEW_MATRIX = VIEW_MATRIX * mat_world * scale_mat;
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	if (COLOR.a > -0.5) {
		float h_frames = float(particles_anim_h_frames);
		float v_frames = float(particles_anim_v_frames);
		float particle_total_frames = float(particles_anim_h_frames * particles_anim_v_frames);

		if (COLOR.a >= 1.0) {
			// Single row mode
			// Extract row and frame progress
			float row = floor(COLOR.a);
			float frame_progress = fract(COLOR.a);

			// Calculate frame within row
			float particle_frame = floor(frame_progress * h_frames);

			// Apply UV transformation
			rotated_uv /= vec2(h_frames, v_frames);
			rotated_uv += vec2(
				mod(particle_frame, h_frames) / h_frames,
				row / v_frames
			);
		} else {
			// Whole sheet mode
			float frame = COLOR.a * particle_total_frames;
			float current_frame = floor(frame);

			// Apply UV transformation
			rotated_uv /= vec2(h_frames, v_frames);
			rotated_uv += vec2(
				mod(current_frame, h_frames) / h_frames,
				floor(current_frame / h_frames) / v_frames
			);
		}
	}
}

void fragment() {
	vec4 input_color = texture(albedo_texture, rotated_uv);
	float value = (input_color.r + input_color.g + input_color.b) / 3.0;
	vec4 output_color = texture(gradient_texture, vec2(COLOR.g, 0.1)) * vec4(input_color.rgb,1.0);

	ALBEDO = hue_change(output_color.rgb,COLOR.r);
	ALPHA = min(min(input_color.a * output_color.a, value),output_color.a);
}
