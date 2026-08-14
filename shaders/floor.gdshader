shader_type canvas_item;

uniform vec4 base : source_color = vec4(0.40, 0.28, 0.20, 1.0);

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

void fragment() {
    vec2 uv = UV;
    float row = floor(uv.y * 6.0);
    float off = mod(row, 2.0) * 0.5;
    float gap = step(0.96, fract(uv.x * 3.0 + off));
    float grain = hash(floor(uv * vec2(3.0, 6.0))) * 0.08;
    vec3 col = base.rgb - gap * 0.15 + grain;
    COLOR = vec4(col, 1.0);
}