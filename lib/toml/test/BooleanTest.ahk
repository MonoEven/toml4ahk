#Include <toml\test\Test>

class BooleanTest
{
    should_get_boolean()
    {
        _toml := Toml().read("bool_false = false`nbool_true = true")
        assertFalse(_toml.getBoolean("bool_false"))
        assertTrue(_toml.getBoolean("bool_true"))
    }
    
    should_fail_on_invalid_boolean_true()
    {
        try
            Toml().read("answer = true abc")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_invalid_boolean_false()
    {
        try
            Toml().read("answer = false abc")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    static testAll()
    {
        _test := BooleanTest()
        _test.should_get_boolean()
        _test.should_fail_on_invalid_boolean_true()
        _test.should_fail_on_invalid_boolean_false()
    }
}
