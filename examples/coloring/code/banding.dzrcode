vec4 get_color(int iterations, vec2 z, vec2 sz) {
    int num_shades = 40;

    int color_index = iterations % num_shades;

    float normalized_index = float(color_index) / float(num_shades);

    vec3 color = 0.5 + 0.5 * cos(6.28318 * normalized_index * vec3(1.0, 0.5, 0.25) + color_map);

    if (iterations == max_iterations) {
        color = vec3(0, 0, 0);
    }

    return vec4(color, 1.0);
}