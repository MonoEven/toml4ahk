#Include <toml\test\Test>

class ArrayTest
{
    should_get_array()
    {
        _toml := Toml().read("list = [`"a`", `"b`", `"c`"]")
        assertEquals(asList("a", "b", "c"), _toml.getList("list"))
    }
    
    should_return_null_if_no_value_for_key()
    {
        _toml := Toml().read("")
        assertNull(_toml.getList("a"))
    }
    
    should_allow_multiline_array()
    {
        _toml := Toml().read(this.file("should_allow_multiline_array"))
        assertEquals(asList("a", "b", "c"), _toml.getList("a"))
    }
    
    should_get_nested_arrays()
    {
        clients := Toml().read("data = [ [`"gamma`", `"delta`"], [1, 2]] # just an update to make sure parsers support it")
        assertEquals(asList(asList("gamma", "delta"), asList(1, 2)), clients.getList("data"))
    }
    
    should_get_deeply_nested_arrays()
    {
        data := Toml().read("data = [[[1], [2]], [3, 4]]").getList("data")
        assertThat(data, hasSize(2))
        assertEquals(asList(1), data.get(0).get(0))
        assertEquals(asList(2), data.get(0).get(1))
        assertEquals(asList(3, 4), data.get(1))
    }
    
    should_get_nested_arrays_with_no_space_between_outer_and_inner_array()
    {
        clients := Toml().read("data = [[`"gamma`", `"delta`"], [1, 2]] # just an update to make sure parsers support it")
        assertEquals(asList(asList("gamma", "delta"), asList(1, 2)), clients.getList("data"))
    }
    
    should_ignore_comma_at_end_of_array()
    {
        _toml := Toml().read("key=[1,2,3,]")
        assertEquals(asList(1, 2, 3), _toml.getList("key"))
    }
    
    should_support_mixed_string_types()
    {
        _toml := Toml().read("key = [`"a`", 'b', `"`"`"c`"`"`", '''d''']")
        assertThat(_toml.getList("key"), Matchers.contains("a", "b", "c", "d"))
    }
    
    should_support_array_terminator_in_strings()
    {
        _toml := Toml().read("key = [`"a]`", 'b]', `"`"`"c]`"`"`", '''d]''']")
        assertThat(_toml.getList("key"), Matchers.contains("a]", "b]", "c]", "d]"))
    }
    
    should_support_array_of_inline_tables()
    {
        _toml := Toml().read(getResourceAsStream("should_support_array_of_inline_tables.toml"))
        assertThat(_toml.getList("points"), hasSize(4))
        assertEquals(1, _toml.getLong("points[0].x"))
        assertEquals(2, _toml.getLong("points[0].y"))
        assertEquals(3, _toml.getLong("points[0].z"))
        assertEquals(7, _toml.getLong("points[1].x"))
        assertEquals(8, _toml.getLong("points[1].y"))
        assertEquals(9, _toml.getLong("points[1].z"))
        assertEquals(2, _toml.getLong("points[2].x"))
        assertEquals(4, _toml.getLong("points[2].y"))
        assertEquals(8, _toml.getLong("points[2].z"))
        assertEquals("3", _toml.getString("points[3].x"))
        assertEquals("6", _toml.getString("points[3].y"))
        assertEquals("12", _toml.getString("points[3].z"))
    }
    
    file(filename)
    {
        return fileopen(Java.file(format("toml\resources\{}.toml", filename)), "r")
    }
    
    static testAll()
    {
        _test := ArrayTest()
        _test.should_get_array()
        _test.should_return_null_if_no_value_for_key()
        _test.should_allow_multiline_array()
        _test.should_get_nested_arrays()
        _test.should_get_deeply_nested_arrays()
        _test.should_get_nested_arrays_with_no_space_between_outer_and_inner_array()
        _test.should_ignore_comma_at_end_of_array()
        _test.should_support_mixed_string_types()
        _test.should_support_array_terminator_in_strings()
        _test.should_support_array_of_inline_tables()
    }
}
