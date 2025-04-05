#include "rational_numbers.h"

rational_t invert(rational_t rat);
int absolute_int(int n);
int exp_int(int n, int exp);
int gcd_int(int lhs, int rhs);

rational_t add(rational_t lhs, rational_t rhs) {
  if (lhs.denominator != rhs.denominator) {
    rhs.numerator *= lhs.denominator;
    lhs.numerator *= rhs.denominator;
    lhs.denominator *= rhs.denominator;
  }

  lhs.numerator += rhs.numerator;
  return reduce(lhs);
}

rational_t subtract(rational_t lhs, rational_t rhs) {
  rhs.numerator *= -1;
  return add(lhs, rhs);
}

rational_t multiply(rational_t lhs, rational_t rhs) {
  lhs.numerator *= rhs.numerator;
  lhs.denominator *= rhs.denominator;
  return reduce(lhs);
}

rational_t divide(rational_t lhs, rational_t rhs) {
  return multiply(lhs, invert(rhs));
}

rational_t absolute(rational_t rat) {
  rat.numerator = absolute_int(rat.numerator);
  rat.denominator = absolute_int(rat.denominator);
  return reduce(rat);
}

rational_t reduce(rational_t rat) {
  if (rat.numerator == 0) {
    rat.denominator = 1;
    return rat;
  }

  int gcd = gcd_int(rat.numerator, rat.denominator);
  if (gcd > 1) {
    rat.numerator /= gcd;
    rat.denominator /= gcd;
  }
  if (rat.denominator < 0) {
    rat.numerator *= -1;
    rat.denominator *= -1;
  }
  return rat;
}

rational_t exp_rational(rational_t rat, int exp) {
  if (exp < 0) {
    rat = invert(rat);
    exp *= -1;
  }

  rat.numerator = exp_int(rat.numerator, exp);
  rat.denominator = exp_int(rat.denominator, exp);
  return reduce(rat);
}

double exp_real(int base, rational_t rat) {
  return pow(base, (double)rat.numerator / rat.denominator);
}

rational_t invert(rational_t rat) {
  if (rat.numerator == 0) {
    exit(1);
  }

  int num = rat.numerator;
  rat.numerator = rat.denominator;
  rat.denominator = num;
  return reduce(rat);
}

int absolute_int(int n) {
  if (n < 0) {
    return -n;
  } else {
    return n;
  }
}

int exp_int(int n, int exp) {
  if (exp < 0) {
    exit(1);
  }

  int result = 1;
  while (exp > 0) {
    if (exp % 2 > 0) {
      result *= n;
      exp -= 1;
    }
    n *= n;
    exp /= 2;
  }
  return result;
}

int gcd_int(int lhs, int rhs) {
  if (lhs == 0 || rhs == 0) {
    exit(1);
  }

  lhs = absolute_int(lhs);
  rhs = absolute_int(rhs);
  while (rhs > 0) {
    int tmp = lhs % rhs;
    lhs = rhs;
    rhs = tmp;
  }
  return lhs;
}
