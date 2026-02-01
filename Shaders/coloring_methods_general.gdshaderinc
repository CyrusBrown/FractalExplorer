vec4 get_pixel_color_1(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz){
    // Normalize iterations to a range between 0 and 1
    float t = float(iterations) / float(max_iterations);

    // Approximate histogram-like effect using a non-linear scaling function
    float intensity = pow(t, intensity_fac); // Adjust exponent for brightness control

    // Map intensity to a color gradient (blue-to-light blue-to-white)
    vec3 color;
    if (intensity < 0.3) {
        color = mix(vec3(0.0, 0.0, 0.2), vec3(0.0, 0.0, 0.8), intensity / 0.3); // Deep blue to blue
    } else if (intensity < 0.6) {
        color = mix(vec3(0.0, 0.0, 0.8), vec3(0.5, 0.5, 1.0), (intensity - 0.3) / 0.3); // Blue to light blue
    } else {
        color = mix(vec3(0.5, 0.5, 1.0), vec3(1.0, 1.0, 1.0), (intensity - 0.6) / 0.4); // Light blue to white
    }

    // Return the final color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_2(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Use smoothing to calculate a more precise iteration count
    float smooth_fac = float(iterations) - log2(log2(length(z))) + float(intensity_fac);

    // Normalize smooth to a range between 0 and 1
    float t = smooth_fac / float(max_iterations);

    // Use a gradient or a palette with sin/cos for more vivid color transitions
    vec3 color = 0.5 + 0.5*cos(3.0 + t*6.28318 + color_map);

	if (iterations == max_iterations){
		color = vec3(0,0,0);
	}

    // Return the final color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_3(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Use smoothing to calculate a more precise iteration count
    float smooth_fac = float(iterations) - log2(log2(length(z))) + 4.0; // Adjust for intensity control

    // Normalize smooth to a range between 0 and 1
    float t = smooth_fac / float(max_iterations);

    // Approximate histogram adjustment by modifying the scale and offset
    float hist_factor = 0.95; // A factor for enhancing the color range more precisely
    t = pow(t, hist_factor);

    // Use a more dynamic color mapping - modify the scaling for sin/cos
    vec3 color = 0.5 + 0.5 * cos(3.0 + t * 6.28318 * vec3(1.0, 0.5, 0.25) + color_map);

    // Set color to black if the point is considered inside the fractal (non-escaped point)
    if (iterations == max_iterations) {
        color = vec3(0, 0, 0);
    }

    // Return the final color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_4(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Number of distinct shades/colors
    int num_shades = 16; // You can adjust this to match your needs

    // Compute a wrapped index for color selection within the range of distinct shades
    int color_index = iterations % num_shades;

    // Convert the color index into a normalized float for coloring purposes
    float normalized_index = float(color_index) / float(num_shades);

    // Use the normalized index to generate a repeating color using a sine or cosine function
    vec3 color = 0.5 + 0.5 * cos(normalized_index * 6.28318 * vec3(1.0, 0.5, 0.25));

    // If the point reaches max iterations, assume it does not escape the set, color it black
    if (iterations == max_iterations) {
        color = vec3(0, 0, 0);
    }

    // Return the computed color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_5(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Define the number of distinct shades/colors
    int num_shades = 40; // Adjust this to define the cycle length of distinct colors

    // Map each iteration directly to a distinct color
    int color_index = iterations % num_shades;

    // Convert the color index into a normalized float for cosine-based color mapping
    float normalized_index = float(color_index) / float(num_shades);

    // Generate a dynamic color using cosine functions
    vec3 color = 0.5 + 0.5 * cos(6.28318 * normalized_index * vec3(1.0, 0.5, 0.25) + color_map);

    // Set color to black if the point is considered inside the fractal (non-escaped point)
    if (iterations == max_iterations) {
        color = vec3(0, 0, 0);
    }

    // Return the final color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_6(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
// Define a baseline for the number of shades and a scaling factor
    int base_shades = 16;    // Minimum number of shades when iterations are low
    int max_shades = 256;    // Maximum number of shades allowed
    float shade_factor = 0.1; // This factor determines how quickly shades scale with iterations

    // Calculate the number of shades based on max_iterations
    int num_shades = clamp(int(float(max_iterations) * shade_factor), base_shades, max_shades);

    // Map each iteration directly to a distinct color
    int color_index = iterations % num_shades;

    // Convert the color index into a normalized float for cosine-based color mapping
    float normalized_index = float(color_index) / float(num_shades);

    // Generate a dynamic color using cosine functions
    vec3 color = 0.5 + 0.5 * cos(6.28318 * normalized_index * vec3(1.0, 0.5, 0.25) + color_map);

    // Set color to black if the point is considered inside the fractal (non-escaped point)
    if (iterations == max_iterations) {
        color = vec3(0, 0, 0);
    }

    // Return the final color with full opacity
    return vec4(color, 1.0);
}

vec4 get_pixel_color_domain(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    float angle = atan(z.y, z.x); // Returns angle in [-π, π]
    
    // Normalize angle to [0, 1] for hue
    float hue = (angle + 3.14159) / (2.0 * 3.14159);
    
    // Calculate magnitude and modulate brightness (closer to zero = darker)
    float magnitude = length(z);
    float value = clamp(log(1.0 + magnitude), 0.0, 1.0);
    
    // HSV to RGB conversion for full spectrum
    float h = hue * 6.0; // Scale to [0, 6] for HSV
    float i = floor(h);
    float f = h - i;
    float p = 0.0; // For saturation = 1, p is 0
    float q = 1.0 - f;
    float t = f;
    
    vec3 color;
    if (i == 0.0) color = vec3(1.0, t, p);
    else if (i == 1.0) color = vec3(q, 1.0, p);
    else if (i == 2.0) color = vec3(p, 1.0, t);
    else if (i == 3.0) color = vec3(p, q, 1.0);
    else if (i == 4.0) color = vec3(t, p, 1.0);
    else color = vec3(1.0, p, q);
    
    // Apply brightness modulation
    color *= value;
    
    return vec4(color, 1.0);
}

vec4 get_pixel_color_domain2(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Calculate distance from starting to ending position
    float dist = length(z - sz);
    
    // Normalize distance with logarithmic scale for detail
    float norm_dist = clamp(log(1.0 + dist * intensity_fac), 0.0, 1.0);
    
    // Animate hue with TIME for dynamic effect
    float hue = norm_dist + 0.2 * sin(TIME);
    hue = fract(hue); // Keep hue in [0, 1]
    
    // Modulate saturation based on iteration count
    float saturation = clamp(float(iterations) / float(max_iterations), 0.0, 1.0);
    
    // Keep value high, with slight modulation for depth
    float value = 0.8 + 0.2 * norm_dist;
    
    // HSV to RGB conversion
    float h = hue * 6.0; // Scale to [0, 6] for HSV
    float i = floor(h);
    float f = h - i;
    float p = value * (1.0 - saturation);
    float q = value * (1.0 - saturation * f);
    float t = value * (1.0 - saturation * (1.0 - f));
    
    vec3 color;
    if (i == 0.0) color = vec3(value, t, p);
    else if (i == 1.0) color = vec3(q, value, p);
    else if (i == 2.0) color = vec3(p, value, t);
    else if (i == 3.0) color = vec3(p, q, value);
    else if (i == 4.0) color = vec3(t, p, value);
    else color = vec3(value, p, q);
    
    // Apply color_map for customizable tint
    color *= color_map;
    
    return vec4(color, 1.0);
}

vec4 get_pixel_color_internal(int iterations, int max_iterations, float intensity_fac, vec3 color_map, vec2 z, vec2 sz) {
    // Initialize maximum squared magnitude (assume this is computed during iteration)
    // For simplicity, we'll use |z|^2 here, but in practice, track max(|z_n|^2) during iteration
    float max_z2 = dot(z, z); // |z|^2 for the final iterate
    float sz2 = dot(sz, sz);  // |sz|^2, typically |c|^2 for Mandelbrot
    
    vec3 color;
    
    // Check if point is bounded (inside the Mandelbrot set)
    if (iterations >= max_iterations) {
        // Normalize max_z2 - sz2 for internal structure
        float internal_val = clamp((max_z2 - sz2) * intensity_fac, 0.0, 1.0);
        
        // Animate with TIME for rippling effect
        float animated_val = 0.5 + 0.5 * sin(internal_val * 3.14159 + TIME);
        
        // Use grayscale for internal contours, modulated by animation
        float value = clamp(animated_val, 0.0, 1.0);
        color = vec3(value);
    } else {
        // Escaping points: use distance |z - sz| and iteration count for coloring
        float dist = length(z - sz);
        float norm_dist = clamp(log(1.0 + dist * intensity_fac), 0.0, 1.0);
        
        // Hue based on normalized distance, animated slightly
        float hue = norm_dist + 0.1 * sin(TIME);
        hue = fract(hue);
        
        // Saturation based on escape time
        float saturation = clamp(float(iterations) / float(max_iterations), 0.0, 1.0);
        float value = 0.8 + 0.2 * norm_dist;
        
        // HSV to RGB conversion
        float h = hue * 6.0;
        float i = floor(h);
        float f = h - i;
        float p = value * (1.0 - saturation);
        float q = value * (1.0 - saturation * f);
        float t = value * (1.0 - saturation * (1.0 - f));
        
        if (i == 0.0) color = vec3(value, t, p);
        else if (i == 1.0) color = vec3(q, value, p);
        else if (i == 2.0) color = vec3(p, value, t);
        else if (i == 3.0) color = vec3(p, q, value);
        else if (i == 4.0) color = vec3(t, p, value);
        else color = vec3(value, p, q);
    }
    
    // Apply color_map for customizable tint
    color *= color_map;
    
    return vec4(color, 1.0);
}


