shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.05, 0.05, 0.1, 0.35);
uniform float corner_radius : hint_range(0.0, 0.5) = 0.14;
uniform float softness : hint_range(0.001, 0.3) = 0.10;

float rounded_sdf(vec2 p, vec2 half_size, float radius) {
    vec2 d = abs(p) - half_size + vec2(radius);
    return length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0) - radius;
}

void fragment() {
    vec2 p = UV - vec2(0.5);
    float dist = rounded_sdf(p, vec2(0.5), corner_radius);
    float alpha = 1.0 - smoothstep(0.0, softness, dist);
    COLOR = vec4(shadow_color.rgb, shadow_color.a * alpha);
}