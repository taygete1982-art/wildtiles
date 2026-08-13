shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.96, 0.94, 0.86, 1.0);
uniform float bevel : hint_range(0.0, 0.5) = 0.14;
uniform float corner_radius : hint_range(0.0, 0.5) = 0.14;
uniform float saturation : hint_range(0.0, 1.5) = 1.0;

float rounded_sdf(vec2 p, vec2 half_size, float radius) {
    vec2 d = abs(p) - half_size + vec2(radius);
    return length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0) - radius;
}

void fragment() {
    vec2 p = UV - vec2(0.5);
    float dist = rounded_sdf(p, vec2(0.5), corner_radius);
    float alpha = 1.0 - smoothstep(-0.015, 0.015, dist);
    
    vec4 col = base_color;
    float light = (UV.x + UV.y) * 0.5;
    float hi = smoothstep(0.55, 0.0, light);
    float lo = smoothstep(0.45, 1.0, light);
    col.rgb += hi * bevel;
    col.rgb -= lo * bevel;
    
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    col.rgb = mix(vec3(gray), col.rgb, saturation);
    
    COLOR = vec4(col.rgb, col.a * alpha);
}