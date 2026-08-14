shader_type canvas_item;

uniform vec4 base : source_color = vec4(0.55, 0.38, 0.36, 1.0);

void fragment() {
    vec2 uv = UV;
    float stripe = step(0.5, fract(uv.x * 12.0)) * 0.05;
    float light = smoothstep(0.0, 0.3, uv.y) * smoothstep(1.0, 0.7, uv.y) * 0.08;
    vec3 col = base.rgb + stripe + light;
    COLOR = vec4(col, 1.0);
}