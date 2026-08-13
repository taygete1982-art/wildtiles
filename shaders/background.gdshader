shader_type canvas_item;

uniform vec4 top_color : source_color = vec4(0.38, 0.10, 0.16, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.10, 0.03, 0.07, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.55, 0.25, 0.3);

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

void fragment() {
    vec2 uv = UV;
    vec3 col = mix(top_color.rgb, bottom_color.rgb, pow(uv.y, 1.2));
    
    float b1 = smoothstep(0.5, 0.0, distance(uv, vec2(0.2 + 0.06 * sin(TIME * 0.07), 0.3)));
    float b2 = smoothstep(0.6, 0.0, distance(uv, vec2(0.85, 0.6 + 0.05 * cos(TIME * 0.09))));
    float b3 = smoothstep(0.4, 0.0, distance(uv, vec2(0.6, 0.15)));
    col += top_color.rgb * b1 * 0.35;
    col += glow_color.rgb * b3 * 0.5;
    col += bottom_color.rgb * b2 * 0.6 + top_color.rgb * b2 * 0.15;
    
    vec2 g = floor(uv * vec2(18.0, 32.0));
    float h = hash(g);
    vec2 f = fract(uv * vec2(18.0, 32.0)) - 0.5;
    float star = step(0.93, h) * smoothstep(0.12, 0.0, length(f)) * (0.6 + 0.4 * sin(TIME * 1.5 + h * 80.0));
    col += glow_color.rgb * star * 1.2;
    
    float v = smoothstep(1.1, 0.3, distance(uv, vec2(0.5, 0.5)));
    col *= mix(0.55, 1.0, v);
    
    COLOR = vec4(col, 1.0);
}