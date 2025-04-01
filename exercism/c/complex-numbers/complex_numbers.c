#include "complex_numbers.h"

complex_t c_from_real(double r);
complex_t c_negate(complex_t x);
double c_abs_sq(complex_t x);

complex_t c_add(complex_t a, complex_t b) {
  return (complex_t){.real = c_real(a) + c_real(b),
                     .imag = c_imag(a) + c_imag(b)};
}

complex_t c_sub(complex_t a, complex_t b) { return c_add(a, c_negate(b)); }

complex_t c_mul(complex_t a, complex_t b) {
  return (complex_t){.real = c_real(a) * c_real(b) - c_imag(a) * c_imag(b),
                     .imag = c_real(a) * c_imag(b) + c_imag(a) * c_real(b)};
}

complex_t c_div(complex_t a, complex_t b) {
  if (c_imag(b) != 0) {
    double divisor = c_abs_sq(b);
    complex_t result = c_conjugate(b);
    result = c_mul(result, a);
    result = c_div(result, c_from_real(divisor));
    return result;
  } else if (c_real(b) != 0) {
    return (complex_t){.real = c_real(a) / c_real(b),
                       .imag = c_imag(a) / c_real(b)};
  } else {
    exit(1);
  }
}

double c_abs(complex_t x) { return sqrt(c_abs_sq(x)); }

complex_t c_conjugate(complex_t x) {
  return (complex_t){.real = c_real(x), .imag = -c_imag(x)};
}

double c_real(complex_t x) { return x.real; }

double c_imag(complex_t x) { return x.imag; }

complex_t c_exp(complex_t x) {
  double multiplier = exp(c_real(x));
  complex_t result = {.real = cos(c_imag(x)), .imag = sin(c_imag(x))};
  result = c_mul(result, c_from_real(multiplier));
  return result;
}

complex_t c_from_real(double r) { return (complex_t){.real = r, .imag = 0}; }

complex_t c_negate(complex_t x) {
  return (complex_t){.real = -c_real(x), .imag = -c_imag(x)};
}

double c_abs_sq(complex_t x) {
  return c_real(x) * c_real(x) + c_imag(x) * c_imag(x);
}
