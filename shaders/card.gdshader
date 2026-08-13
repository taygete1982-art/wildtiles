shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.96, 0.94, 0.86, 1.0);
uniform float bevel : hint_range(0.0, 0.5) = 0.14;
uniform float corner_radius : hint_range(0.0, 0.5) = 0.14;
uniform float saturation : hint_range(0.0, 1.5) = 1.0;
uniform float hue_shift : hint_range(0.0, 1.0) = 0.0;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

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
    
    vec3 hsv = rgb2hsv(col.rgb);
    hsv.x = fract(hsv.x + hue_shift);
    hsv.y = clamp(hsv.y * saturation, 0.0, 1.0);
    col.rgb = hsv2rgb(hsv);
    
    COLOR = vec4(col.rgb, col.a * alpha);
}