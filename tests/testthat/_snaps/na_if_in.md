# non-vector x produces error

    ! Input `x` must be coercible to a vector.
    x `mean` is of uncoercible class <function>.

---

    ! Input `x` must be coercible to a vector.
    x `mean` is of uncoercible class <function>.

---

    ! Input `x` must be coercible to a vector.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

---

    ! Input `x` must be coercible to a vector.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

---

    ! Input `x` must be coercible to a vector.
    x `~. < 0` is of uncoercible class <formula>.

---

    ! Input `x` must be coercible to a vector.
    x `~. < 0` is of uncoercible class <formula>.

# if `x_label` is `.`, use `x` instead

    ! Input `x` must be coercible to a vector.
    x `x` is of uncoercible class <function>.

---

    ! Input `x` must be coercible to a vector.
    x `x` is of uncoercible class <function>.

# two-sided formula produces error

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `x ~ . < 1` is a two-sided formula.

---

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `x ~ . < 1` is a two-sided formula.

# non-coercible argument produces error

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

---

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

# multiple non-coercible arguments produces error

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `NULL` is of uncoercible class <NULL>.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

---

    ! All arguments must be coercible to an atomic vector, function, or one-sided formula.
    x `NULL` is of uncoercible class <NULL>.
    x `lm(1 ~ 1)` is of uncoercible class <lm>.

# no ... produces error

    x No values to replace with `NA` specified.

---

    x No values to replace with `NA` specified.

# function arguments must return logical vectors

    ! Function arguments must return logical vectors.
    x `min` returns an object of class <integer>.

---

    ! Function arguments must return logical vectors.
    x `min` returns an object of class <integer>.

---

    ! Function arguments must return logical vectors.
    x `max` returns an object of class <integer>.

---

    ! Function arguments must return logical vectors.
    x `max` returns an object of class <integer>.

---

    ! Function arguments must return logical vectors.
    x `mean` returns an object of class <numeric>.

---

    ! Function arguments must return logical vectors.
    x `mean` returns an object of class <numeric>.

# function arguments must return vectors of the same length as `x`

    ! Function arguments must return vectors of the same length as `x`.
    x `~TRUE` returns a vector of length 1, but `1:5` is length 5.

---

    ! Function arguments must return vectors of the same length as `x`.
    x `~TRUE` returns a vector of length 1, but `1:5` is length 5.

