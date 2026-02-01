vec2 cmult(vec2 a, vec2 b) {
    return vec2(
        a.x * b.x - a.y * b.y, // Real part
        a.x * b.y + a.y * b.x  // Imaginary part
    );	
}

vec2 csin(vec2 z) {
	vec2 result = vec2(0, 0);
    // Real and imaginary parts
    float x = z.x; // Real part
    float y = z.y; // Imaginary part

    // Apply the formula for sin(z)
    result.x = sin(x) * cosh(y);
    result.y = cos(x) * sinh(y);

    return result;
}
vec2 cadd(vec2 a, vec2 b) {
    return vec2(
        a.x + b.x, // Real part
        a.y + b.y  // Imaginary part
    );
}

// Subtract two complex numbers
vec2 csub(vec2 a, vec2 b) {
    return vec2(
        a.x - b.x, // Real part
        a.y - b.y  // Imaginary part
    );
}

// Divide two complex numbers
vec2 cdiv(vec2 a, vec2 b) {
    float denominator = b.x * b.x + b.y * b.y;
    return vec2(
        (a.x * b.x + a.y * b.y) / denominator, // Real part
        (a.y * b.x - a.x * b.y) / denominator  // Imaginary part
    );
}

// Compute the conjugate of a complex number
vec2 cconj(vec2 a) {
    return vec2(
        a.x,     // Real part remains the same
        -a.y     // Imaginary part is negated
    );
}

// Compute the magnitude of a complex number
float cmag(vec2 a) {
    return sqrt(a.x * a.x + a.y * a.y);
}

// Compute the exponential of a complex number
vec2 cexp(vec2 z) {
    float expx = exp(z.x);
    return vec2(
        expx * cos(z.y), // Real part
        expx * sin(z.y)  // Imaginary part
    );
}

// Compute the cosine of a complex number
vec2 ccos(vec2 z) {
    highp vec2 result = vec2(0, 0);
    // Real and imaginary parts
    highp float x = z.x; // Real part
    highp float y = z.y; // Imaginary part

    // Apply the formula for cos(z)
    result.x = cos(x) * cosh(y);
    result.y = -sin(x) * sinh(y);

    return result;
}

// Compute the hyperbolic cosine of a complex number
vec2 ccosh(vec2 z) {
    highp vec2 result = vec2(0, 0);
    // Real and imaginary parts
    highp float x = z.x; // Real part
    highp float y = z.y; // Imaginary part

    // Apply the formula for cosh(z)
    result.x = cosh(x) * cos(y);
    result.y = sinh(x) * sin(y);

    return result;
}

vec2 csinh(vec2 z) {
    vec2 result = vec2(0, 0);
    // Real and imaginary parts
    float x = z.x; // Real part
    float y = z.y; // Imaginary part

    // Apply the formula for sinh(z)
    // sinh(z) = sinh(x) * cos(y) + i * cosh(x) * sin(y)
    result.x = sinh(x) * cos(y); // Real part
    result.y = cosh(x) * sin(y); // Imaginary part

    return result;
}

// Compute the tangent of a complex number
vec2 ctan(vec2 z) {
    vec2 sin_z = csin(z);
    vec2 cos_z = ccos(z);
    return cdiv(sin_z, cos_z);
}

// Compute the logarithm of a complex number
vec2 clog(vec2 z) {
    return vec2(
        log(cmag(z)),       // Real part
        atan(z.y, z.x)     // Imaginary part
    );
}

// Compute the power of a complex number raised to another complex number
vec2 cpow(vec2 a, vec2 b) {
    // Using the formula: a^b = exp(b * log(a))
    vec2 log_a = clog(a);
    vec2 b_log_a = cmult(b, log_a);
    return cexp(b_log_a);
}

// Compute the square root of a complex number
vec2 csqrt(vec2 z) {
    float magnitude = cmag(z);
    float angle = atan(z.y, z.x) / 2.0;
    return vec2(
        sqrt(magnitude) * cos(angle), // Real part
        sqrt(magnitude) * sin(angle)  // Imaginary part
    );
}

vec2 clog(vec2 z, vec2 b) {
    // natural log of z
    vec2 ln_z = clog(z);
    // natural log of base
    vec2 ln_b = clog(b);
    // divide component‐wise in the complex sense
    return cdiv(ln_z, ln_b);
}


