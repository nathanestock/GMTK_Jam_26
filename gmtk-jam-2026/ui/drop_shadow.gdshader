shader_type canvas_item;
render_mode unshaded;

// Set shadow_offset to vec2(0.0, 0.0) to keep it perfectly centered
uniform vec2 shadow_offset = vec2(0.0, 0.0);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

// HIGHER NUMBER = THICKER SHADOW. Keep between 1 and 8 for performance.
uniform int shadow_thickness : hint_range(0, 10) = 3;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    // 1. Read the crisp, original UI elements at the current pixel
    vec4 current_color = textureLod(screen_texture, SCREEN_UV, 0.0);
    
    // 2. Sample a grid of surrounding pixels to expand/dilate the shadow
    float shadow_alpha = 0.0;
    
    for (int x = -shadow_thickness; x <= shadow_thickness; x++) {
        for (int y = -shadow_thickness; y <= shadow_thickness; y++) {
            // Apply both the global translation offset AND the scaling grid
            vec2 pixel_offset = shadow_offset + vec2(float(x), float(y));
            vec2 shadow_uv = SCREEN_UV - (pixel_offset * SCREEN_PIXEL_SIZE);
            
            // If any nearby pixel is occupied, this location belongs to the expanded shadow
            vec4 sample = textureLod(screen_texture, shadow_uv, 0.0);
            if (sample.a > 0.001) {
                shadow_alpha = shadow_color.a;
                break; // Break the inner loop early to save performance
            }
        }
    }
    
    vec4 final_shadow = vec4(shadow_color.rgb, shadow_alpha);
    
    // 3. Clean up pre-multiplied alpha artifacting native to CanvasGroup
    if (current_color.a > 0.0001) {
        current_color.rgb /= current_color.a;
    }
    
    // 4. Layer elements exactly over the thickened shadow center
    COLOR = mix(final_shadow, current_color, current_color.a);
}
