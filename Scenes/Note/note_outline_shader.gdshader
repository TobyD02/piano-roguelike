shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 20.0) = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (tex.a > 0.0) {
        COLOR = tex * COLOR;
    } else {
        vec2 texel = TEXTURE_PIXEL_SIZE;
        float outline_alpha = 0.0;

        const int SAMPLES = 16;
        for (int i = 0; i < SAMPLES; i++) {
            float angle = float(i) / float(SAMPLES) * TAU;
            vec2 offset = vec2(cos(angle), sin(angle)) * texel * outline_width;
            outline_alpha = max(outline_alpha, texture(TEXTURE, UV + offset).a);
        }

        COLOR = vec4(outline_color.rgb, outline_color.a * outline_alpha);
    }
}