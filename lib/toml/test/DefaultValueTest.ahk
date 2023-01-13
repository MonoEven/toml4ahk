#Include <toml\test\Test>

class DefaultValueTest
{
    should_get_string()
    {
        _toml := Toml().read("s = `"string value`"")
        assertEquals("string value", _toml.getString("s", "default string value"))
    }
    
    should_get_string_default_value()
    {
        _toml := Toml().read("")
        assertEquals("default string value", _toml.getString("s", "default string value"))
    }
    
    should_get_long()
    {
        _toml := Toml().read("n = 1001")
        assertEquals(1001, _toml.getLong("n", 1002))
    }
    
    should_get_long_default_value()
    {
        _toml := Toml().read("")
        assertEquals(1002, _toml.getLong("n", 1002))
    }
    
    should_get_double()
    {
        _toml := Toml().read("n = 0.5")
        assertEquals(0.5, _toml.getDouble("n", 0.6))
    }
    
    should_get_double_default_value()
    {
        _toml := Toml().read("")
        assertEquals(0.6, _toml.getDouble("n", 0.6))
    }
    
    should_get_boolean()
    {
        _toml := Toml().read("b = true")
        assertEquals(Boolean.TRUE, _toml.getBoolean("b", Boolean.FALSE))
    }
    
    should_get_boolean_default_value()
    {
        _toml := Toml().read("")
        assertEquals(Boolean.FALSE, _toml.getBoolean("b", Boolean.FALSE))
    }
    
    should_get_array()
    {
        _toml := Toml().read("a = [1, 2, 3]`n  b = []")
        assertEquals(asList(1, 2, 3), _toml.getList("a", asList(3, 2, 1)))
        assertEquals(Collections.emptyList(), _toml.getList("b", asList(3, 2, 1)))
    }
    
    should_get_empty_array()
    {
        _toml := Toml().read("a = []")
        assertEquals(Collections.emptyList(), _toml.getList("a", asList(3, 2, 1)))
    }
    
    should_get_array_default_value()
    {
        _toml := Toml()
        assertEquals(asList(3, 2, 1), _toml.getList("a", asList(3, 2, 1)))
    }
    
    should_prefer_default_from_constructor()
    {
        defaults := Toml().read("n = 1`n d = 1.1`n  b = true`n  date = 2011-11-10T13:12:00Z`n  s = 'a'`n  a = [1, 2, 3]")
        _toml := Toml(defaults).read("")
        assertEquals(1, _toml.getLong("n", 2))
        assertEquals(1.1, _toml.getDouble("d", 2.2))
        assertTrue(_toml.getBoolean("b", false))
        assertEquals("a", _toml.getString("s", "b"))
        assertEquals(asList(1, 2, 3), _toml.getList("a", asList(3, 2, 1)))
    }
    
    static testAll()
    {
        _test := DefaultValueTest()
        _test.should_get_string()
        _test.should_get_string_default_value()
        _test.should_get_long()
        _test.should_get_long_default_value()
        _test.should_get_double()
        _test.should_get_double_default_value()
        _test.should_get_boolean()
        _test.should_get_boolean_default_value()
        _test.should_get_array()
        _test.should_get_empty_array()
        _test.should_get_array_default_value()
        _test.should_prefer_default_from_constructor()
    }
}
