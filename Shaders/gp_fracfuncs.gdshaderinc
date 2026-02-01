#include "functions.gdshaderinc"

vec2 mandlebrot(highp vec2 z, highp vec2 c){
	return (cmult(z, z) + c);
}
vec2 cosinemult(vec2 z, vec2 c){
		return (cmult(c, ccos(z)));
}
vec2 sinemult(vec2 z, vec2 c){
		return (cmult(c, csin(z)));
}
vec2 hyperbolicsinemult(vec2 z, vec2 c){
		return (cmult(c, csinh(z)));
}
vec2 sineadd(vec2 z, vec2 c){
		return (csin(z)+c);
}
vec2 tentmap(vec2 z, vec2 c){
        // Function based on the original equation (mu * x_n for x_n < 1/2, and mu * (1 - x_n) for x_n >= 1/2)
        float real_part = z.x;
		float reverse_rp = 1.0 - real_part;
		vec2 result;
        if (real_part < 0.5) {
            result = cmult(c, vec2(real_part, z.y)); // Equivalent to mu * x_n
        } else {
            result =  cmult(c, vec2(reverse_rp, z.y)); // Equivalent to mu * (1 - x_n)
        }
		return result;
}
vec2 imagtentmap(vec2 z, vec2 c){
        // Function based on the original equation (mu * x_n for x_n < 1/2, and mu * (1 - x_n) for x_n >= 1/2)
        float imag_part = z.y;
		float reverse_ip = 1.0 - imag_part;
		vec2 result;
        if (imag_part < 0.5) {
            result = cmult(c, vec2(imag_part, z.y)); // Equivalent to mu * x_n
        } else {
            result =  cmult(c, vec2(reverse_ip, z.y)); // Equivalent to mu * (1 - x_n)
        }
		return result;
}
vec2 abstentmap(vec2 z, vec2 c){
        float real_part = z.x;
		float reverse_rp = 1.0 - real_part;
		vec2 result;
        if (abs(real_part) > abs(reverse_rp)) {
            result = cmult(c, vec2(real_part, z.y)); // Equivalent to mu * x_n
        } else {
            result =  cmult(c, vec2(reverse_rp, z.y)); // Equivalent to mu * (1 - x_n)
        }
		return result;
}
vec2 asymetrictentmap(vec2 z, vec2 c, vec2 fractal_parameter){
        // Piecewise function: v_n+1 = v_n / a (if v_n in [0, a]) or (1 - v_n) / (1 - a) (if v_n in [a, 1])
        float real_part = z.x; // Use real part of z for v_n
		float reverse_rp = 1.0 - real_part;
		vec2 result;
        if (real_part < fractal_parameter.x) {
            result = cmult(c, vec2(real_part / fractal_parameter.x, z.y)) / 2.0f; // v_n / a
        } else{
            result = cmult(c, vec2((1.0 - real_part) / (1.0 - fractal_parameter.x), z.y)) / 2.0f; // (1 - v_n) / (1 - a)
        }
		return result;
}
vec2 shiftedtentmap(vec2 z, vec2 c, vec2 fractal_parameter){
		float adjusted_real_part = z.x + fractal_parameter.x; // Compute x_n + a

		float reverse_rp = 1.0 - adjusted_real_part;
		vec2 result;
		if (adjusted_real_part < 0.5) {
		    result = cmult(c, vec2(adjusted_real_part, z.y)); // Equivalent to mu * (x_n + a)
		} else {
		    result = cmult(c, vec2(reverse_rp, z.y)); // Equivalent to mu * (1 - (x_n + a))
		}
		return result;
}
vec2 shiftedtentmapimag(vec2 z, vec2 c, vec2 fractal_parameter){
		float adjusted_imag_part = z.y + fractal_parameter.y; // Compute x_n + a

		float reverse_ip = 1.0 - adjusted_imag_part;
		vec2 result;
		if (adjusted_imag_part < 0.5) {
		    result = cmult(c, vec2(z.x, adjusted_imag_part)); // Equivalent to mu * (x_n + a)
		} else {
		    result = cmult(c, vec2(z.x, reverse_ip)); // Equivalent to mu * (1 - (x_n + a))
		}
		return result;
}
vec2 juliashiftedtentmap(vec2 z, vec2 c, vec2 fractal_parameter){
		float adjusted_real_part = z.x + c.x; // Compute x_n + a

		float reverse_rp = 1.0 - adjusted_real_part;
		vec2 result;
		if (adjusted_real_part < 0.5) {
		    result = cmult(fractal_parameter, vec2(adjusted_real_part, z.y)); // Equivalent to mu * (x_n + a)
		} else {
		    result = cmult(fractal_parameter, vec2(reverse_rp, z.y)); // Equivalent to mu * (1 - (x_n + a))
		}
		return result;
}
vec2 parametershiftedtentmap(vec2 z, vec2 c, vec2 fractal_parameter){
		vec2 adjusted_z = z + fractal_parameter; // Compute x_n + a
		vec2 reverse_rp = 1.0 - adjusted_z;
		vec2 result;
		if (length(adjusted_z) < 0.5) {
		    result = cmult(c, adjusted_z); // Equivalent to mu * (x_n + a)
		} else {
		    result = cmult(c, adjusted_z); // Equivalent to mu * (1 - (x_n + a))
		}
		return result;
}
vec2 juliaabstentmap(vec2 z, vec2 c, vec2 fractal_parameter){
		vec2 adjusted_z = z + c; // Compute x_n + a
		vec2 reverse_rp = 1.0 - adjusted_z;
		vec2 result;
		if (length(adjusted_z) < 0.5) {
		    result = cmult(fractal_parameter, adjusted_z); // Equivalent to mu * (x_n + a)
		} else {
		    result = cmult(fractal_parameter, adjusted_z); // Equivalent to mu * (1 - (x_n + a))
		}
		return result;
}

vec2 doublereversetent(vec2 z, vec2 c) {
    // Reflect real and imaginary parts
    float real_part = z.x;
    float imag_part = z.y;
    float reverse_rp = 1.0 - real_part;
    float reverse_ip = 1.0 - imag_part;
    vec2 result;

    if (real_part < 0.5) {
        result = cmult(c, vec2(real_part, imag_part)); // mu * (x_n, y_n)
    } else {
        result = cmult(c, vec2(reverse_rp, reverse_ip)); // mu * (1 - x_n, 1 - y_n)
    }

    return result;
}

vec2 doublealtreversetent1(vec2 z, vec2 c) {
    // Reflect real and imaginary parts
    float real_part = z.x;
    float imag_part = z.y;
    float reverse_rp = 1.0 - real_part;
    float reverse_ip = 1.0 - imag_part;
    vec2 result;

    if (real_part < 0.5) {
        result = cmult(c, vec2(real_part, reverse_ip)); // mu * (x_n, y_n)
    } else {
        result = cmult(c, vec2(reverse_rp, imag_part)); // mu * (1 - x_n, 1 - y_n)
    }

    return result;
}

vec2 doublealtreversetent2(vec2 z, vec2 c) {
    // Reflect real and imaginary parts
    float real_part = z.x;
    float imag_part = z.y;
    float reverse_rp = 1.0 - real_part;
    float reverse_ip = 1.0 - imag_part;
    vec2 result;

    if (real_part < 0.5) {
        result = cmult(c, vec2(reverse_rp, imag_part)); // mu * (x_n, y_n)
    } else {
        result = cmult(c, vec2(real_part, reverse_ip)); // mu * (1 - x_n, 1 - y_n)
    }

    return result;
}

vec2 circustentmap(vec2 z, vec2 c, vec2 fractal_parameter){
        float real_part = pow(z.x, fractal_parameter.x);
		float reverse_rp = pow(1.0 - z.x, fractal_parameter.x);
		vec2 result;
        if (real_part < 0.5) {
            result = cmult(c, vec2(real_part, z.y)); // Equivalent to mu * x_n
        } else {
            result =  cmult(c, vec2(reverse_rp, z.y)); // Equivalent to mu * (1 - x_n)
        }
		return result;
}

vec2 trigfunny(vec2 z, vec2 c){
	return ccos(vec2(z.x, 0) + z) * z.y + cmult(vec2(0, 1), csin(vec2(0, z.y) + z) * z.x);
	}

vec2 logfrac(vec2 z, vec2 c){
	return clog(z, c);
}

vec2 neeraj(vec2 z, vec2 c){
	return cpow(clog(z, c), c);
}

vec2 liam(vec2 z, vec2 c){
	return csin(csub(cpow(z, vec2(6, 0)), c));
}
