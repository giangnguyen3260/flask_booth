#include <flutter/runtime_effect.glsl>
precision highp float;

// Sắp xếp theo thứ tự FilterEnum
layout(location = 0) uniform lowp float uBrightness;      // Độ sáng
layout(location = 1) uniform lowp float uContrast;        // Độ tương phản
layout(location = 2) uniform lowp float uSaturation;      // Độ bão hòa
layout(location = 3) uniform lowp float uVibrance;        // Độ sống động (Vibrance)
layout(location = 4) uniform lowp float uTemperature;     // Nhiệt độ màu
layout(location = 5) uniform lowp float uSepia;           // Tông nâu cổ
layout(location = 6) uniform lowp float uGrain;           // Hạt nhiễu
layout(location = 7) uniform vec2 uScreenSize;            // Độ phân giải màn hình
layout(location = 8) uniform vec2 uChannelResolution;     // Độ phân giải texture

uniform lowp sampler2D uTexture; // Texture đầu vào

out vec4 fragColor;

// Ma trận điều chỉnh độ sáng
mat4 brightnessMatrix(float brightness) {
    return mat4(1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                brightness, brightness, brightness, 1.0);
}

// Ma trận điều chỉnh độ tương phản
mat4 contrastMatrix(float contrast) {
    float t = (1.0 - contrast) / 2.0;
    return mat4(contrast, 0.0, 0.0, 0.0,
                0.0, contrast, 0.0, 0.0,
                0.0, 0.0, contrast, 0.0,
                t, t, t, 1.0);
}

// Ma trận điều chỉnh độ bão hòa
mat4 saturationMatrix(float saturation) {
    vec3 luminance = vec3(0.3086, 0.6094, 0.0820);
    float oneMinusSat = 1.0 - saturation;
    vec3 red = vec3(luminance.x * oneMinusSat) + vec3(saturation, 0.0, 0.0);
    vec3 green = vec3(luminance.y * oneMinusSat) + vec3(0.0, saturation, 0.0);
    vec3 blue = vec3(luminance.z * oneMinusSat) + vec3(0.0, 0.0, saturation);
    return mat4(red, 0.0,
                green, 0.0,
                blue, 0.0,
                0.0, 0.0, 0.0, 1.0);
}

// Hàm điều chỉnh độ sống động (vibrance)
vec4 vibranceFilter(vec4 sourceColor, float vibrance) {
lowp float average = (sourceColor.r + sourceColor.g + sourceColor.b) / 3.0;
lowp float mx = max(sourceColor.r, max(sourceColor.g, sourceColor.b));
lowp float amt = (mx - average) * (vibrance * 3.0);
sourceColor.rgb = mix(sourceColor.rgb, vec3(mx), amt);
return sourceColor;
}

// Hàm điều chỉnh nhiệt độ màu
vec4 temperatureFilter(vec4 sourceColor, float temperature) {
sourceColor.r += temperature * 0.1;
sourceColor.b -= temperature * 0.1;
return sourceColor;
}

// Hàm điều chỉnh tông sepia
vec4 sepiaFilter(vec4 sourceColor, float sepia) {
vec3 sepiaColor = vec3(
        dot(sourceColor.rgb, vec3(0.39, 0.77, 0.19)),
        dot(sourceColor.rgb, vec3(0.35, 0.68, 0.17)),
        dot(sourceColor.rgb, vec3(0.27, 0.53, 0.13))
);
return vec4(mix(sourceColor.rgb, sepiaColor, sepia), sourceColor.a);
}

// Hàm thêm hạt nhiễu (grain)
float rand(vec2 co) {
return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 grainFilter(vec4 sourceColor, float grain, vec2 uv) {
float noise = rand(uv) * grain;
sourceColor.rgb += noise;
return sourceColor;
}

void main() {
    vec2 coord = FlutterFragCoord().xy; // Tọa độ fragment
    vec2 uv = coord / uScreenSize; // Tọa độ UV chuẩn hóa
    vec4 color = texture(uTexture, uv); // Lấy màu trực tiếp từ texture

    // Áp dụng brightness, contrast, saturation
    vec4 adjustedColor = brightnessMatrix(uBrightness) *
                         contrastMatrix(uContrast) *
                         saturationMatrix(uSaturation) *
                         color;

    // Áp dụng vibrance
    adjustedColor = vibranceFilter(adjustedColor, uVibrance);

    // Áp dụng temperature
    adjustedColor = temperatureFilter(adjustedColor, uTemperature);

    fragColor = adjustedColor;

    // Áp dụng sepia
    adjustedColor = sepiaFilter(adjustedColor, uSepia);

    // Áp dụng grain
    fragColor = grainFilter(adjustedColor, uGrain, uv);
}