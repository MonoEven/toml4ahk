#Include <toml\test\Test>

class Toml_ToMapTest
{
    should_convert_simple_values()
    {
        _toml := Toml().read("a = 1").tomap()
        assertEquals(1, _toml["a"])
    }

    should_covert_table()
    {
        _toml := Toml().read("c = 2`n  [a]`n  b = 1").tomap()
        assertEquals(1, _toml["a"]["b"])
        assertEquals(2, _toml["c"])
    }
    
    static testAll()
    {
        _test := Toml_ToMapTest()
        _test.should_convert_simple_values()
        _test.should_covert_table()
    }
}
