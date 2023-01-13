#Include <toml\test\Test>

class NumberTest
{
    should_get_number()
    {
        _toml := Toml().read("b = 1001")
        assertEquals(1001, _toml.getLong("b"))
    }

    should_get_negative_number()
    {
        _toml := Toml().read("b = -1001")
        assertEquals(-1001, _toml.getLong("b"))
    }

    should_get_number_with_plus_sign()
    {
        _toml := Toml().read("a = +1001`nb = 1001")
        assertEquals(_toml.getLong("b"), _toml.getLong("a"))
    }

    should_get_double()
    {
        _toml := Toml().read("double = 5.25")
        assertEquals(5.25, _toml.getDouble("double"))
    }

    should_get_negative_double()
    {
        _toml := Toml().read("double = -5.25")
        assertEquals(-5.25, _toml.getDouble("double"))
    }

    should_get_double_with_a_plus_sign()
    {
        _toml := Toml().read("double = +5.25")
        assertEquals(5.25, _toml.getDouble("double"))
    }

    should_get_exponent()
    {
        _toml := Toml().read("lower_case = 1e6`nupper_case = 2E6`nwith_plus = 5e+22`nboth_plus = +5E+22`nnegative = -2E-2`nfractional = 6.626e-34")
        assertEquals(1e6, _toml.getDouble("lower_case"))
        assertEquals(2E6, _toml.getDouble("upper_case"))
        assertEquals(5e22, _toml.getDouble("with_plus"))
        assertEquals(5e22, _toml.getDouble("both_plus"))
        assertEquals(-2e-2, _toml.getDouble("negative"))
        assertEquals(6.626e-34, _toml.getDouble("fractional"))
    }

    should_get_integer_with_underscores()
    {
        _toml := Toml().read("val = 100_000_000")
        assertEquals(100000000, _toml.getLong("val"))
    }

    should_get_float_with_underscores()
    {
        _toml := Toml().read("val = 100_000.123_456")
        assertEquals(100000.123456, _toml.getDouble("val"))
    }

    should_get_exponent_with_underscores()
    {
        _toml := Toml().read("val = 1_5e1_00")
        assertEquals(15e100, _toml.getDouble("val"))
    }

    should_accept_irregular_underscores()
    {
        _toml := Toml().read("val = 1_2_3_4_5")
        assertEquals(12345, _toml.getLong("val"))
    }

    should_fail_on_invalid_number()
    {
        try
            Toml().read("a = 200-")
    }

    should_fail_when_illegal_characters_after_float()
    {
        try
            Toml().read("number = 3.14  pi")
    }

    should_fail_when_illegal_characters_after_integer()
    {
        try
            Toml().read("number = 314  pi")
    }

    should_fail_on_float_without_leading_0()
    {
        try
            Toml().read("answer = .12345")
    }

    should_fail_on_negative_float_without_leading_0()
    {
        try
            Toml().read("answer = -.12345")
    }

    should_fail_on_float_with_sign_after_dot()
    {
        try
        {
            Toml().read("answer = 1.-1")
            Toml().read("answer = 1.+1")
        }
    }

    should_fail_on_float_without_digits_after_dot()
    {
        try
            Toml().read("answer = 1.")
    }

    should_fail_on_negative_float_without_digits_after_dot()
    {
        try
            Toml().read("answer = -1.")
    }

    should_fail_on_exponent_without_digits_after_dot()
    {
        try
            Toml().read("answer = 1.E1")
    }

    should_fail_on_negative_exponent_without_digits_after_dot()
    {
        try
            Toml().read("answer = -1.E1")
    }

    should_fail_on_exponent_with_dot_in_exponent_part()
    {
        try
            Toml().read("answer = -1E1.0")
    }

    should_fail_on_exponent_without_numbers_after_E()
    {
        try
            Toml().read("answer = -1E")
    }

    should_fail_on_exponent_with_two_E()
    {
        try
            Toml().read("answer = -1E1E1")
    }

    should_fail_on_float_with_two_dots()
    {
        try
            Toml().read("answer = 1.1.1")
    }

    should_fail_on_underscore_at_beginning()
    {
        try
            Toml().read("answer = _1")
    }

    should_fail_on_underscore_at_end()
    {
        try
            Toml().read("answer = 1_")
    }

    should_fail_on_two_underscores_in_a_row()
    {
        try
            Toml().read("answer = 1__1")
    }

    should_fail_on_underscore_after_minus_sign()
    {
        try
            Toml().read("answer = -_1")
    }

    should_fail_on_underscore_after_plus_sign()
    {
        try
            Toml().read("answer = +_1")
    }

    should_fail_on_underscore_before_dot()
    {
        try
            Toml().read("answer = 1_.1")
    }

    should_fail_on_underscore_after_dot()
    {
        try
            Toml().read("answer = 1._1")
    }

    should_fail_on_underscore_before_E()
    {
        try
            Toml().read("answer = 1_E1")
    }

    should_fail_on_underscore_after_E()
    {
        try
            Toml().read("answer = 1E_1")
    }

    should_fail_on_underscore_followed_by_whitespace()
    {
        try
            Toml().read("answer = _ 1")
    }
    
    static testAll()
    {
        _test := NumberTest()
        _test.should_get_number()
        _test.should_get_negative_number()
        _test.should_get_number_with_plus_sign()
        _test.should_get_double()
        _test.should_get_negative_double()
        _test.should_get_double_with_a_plus_sign()
        _test.should_get_integer_with_underscores()
        _test.should_get_float_with_underscores()
        _test.should_get_exponent_with_underscores()
        _test.should_accept_irregular_underscores()
        _test.should_fail_on_invalid_number()
        _test.should_fail_when_illegal_characters_after_float()
        _test.should_fail_when_illegal_characters_after_integer()
        _test.should_fail_on_float_without_leading_0()
        _test.should_fail_on_negative_float_without_leading_0()
        _test.should_fail_on_float_with_sign_after_dot()
        _test.should_fail_on_float_without_digits_after_dot()
        _test.should_fail_on_negative_float_without_digits_after_dot()
        _test.should_fail_on_exponent_without_digits_after_dot()
        _test.should_fail_on_negative_exponent_without_digits_after_dot()
        _test.should_fail_on_exponent_with_dot_in_exponent_part()
        _test.should_fail_on_exponent_without_numbers_after_E()
        _test.should_fail_on_exponent_with_two_E()
        _test.should_fail_on_float_with_two_dots()
        _test.should_fail_on_underscore_at_beginning()
        _test.should_fail_on_underscore_at_end()
        _test.should_fail_on_two_underscores_in_a_row()
        _test.should_fail_on_underscore_after_minus_sign()
        _test.should_fail_on_underscore_after_plus_sign()
        _test.should_fail_on_underscore_before_dot()
        _test.should_fail_on_underscore_after_dot()
        _test.should_fail_on_underscore_before_E()
        _test.should_fail_on_underscore_after_E()
        _test.should_fail_on_underscore_followed_by_whitespace()
    }
}
