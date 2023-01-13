#Include <toml\test\Test>

class TomlTest
{
    should_return_null_if_no_value_for_key()
    {
        _toml := Toml().read("")
        assertNull(_toml.getString("a"))
    }

    should_load_from_file()
    {
        _toml := Toml().read(getResourceAsStream("should_load_from_file.toml"))
        assertEquals("value", _toml.getString("key"))
    }

    should_support_blank_lines()
    {
        _toml := Toml().read(getResourceAsStream("should_support_blank_line.toml"))
        assertEquals(1, _toml.getLong("group.key"))
    }

    should_allow_comment_after_values()
    {
        _toml := Toml().read(getResourceAsStream("should_allow_comment_after_values.toml"))
        assertEquals(1, _toml.getLong("a"))
        assertEquals(1.1, _toml.getDouble("b"))
        assertEquals("abc", _toml.getString("c"))
        assertThat(_toml.getList("e"), Matchers.contains("a", "b"))
        assertTrue(_toml.getBoolean("f"))
        assertEquals("abc", _toml.getString("g"))
        assertEquals("abc", _toml.getString("h"))
        assertEquals("abc`nabc", _toml.getString("i"))
        assertEquals("abc`nabc", _toml.getString("j"))
    }

    should_be_empty_if_no_values()
    {
        assertTrue(Toml().isEmpty())
        assertFalse(Toml().read("a = 1").isEmpty())
    }

    should_fail_on_empty_key_name()
    {
        try
            Toml().read(" = 1")
    }

    should_fail_on_key_name_with_hash()
    {
        try
            Toml().read("a# = 1")
    }

    should_fail_on_key_name_starting_with_square_bracket()
    {
        try
            Toml().read("[a = 1")
    }

    should_fail_when_key_is_overwritten_by_table()
    {
        try
            Toml().read("[a]\nb=1`n[a.b]`nc=2")
    }

    should_fail_when_key_in_root_is_overwritten_by_table()
    {
        try
        {
            this.expectedException.expect(IllegalStateException)
            Toml().read("a=1`n  [a]")
        }
        catch as err
            this.expectedException.errorCheck(err)
    }

    should_fail_when_key_is_overwritten_by_another_key()
    {
        try
            Toml().read("[fruit]`ntype=`"apple`"`ntype=`"orange`"")
    }
    
    expectedException := ExpectedException.none()
    
    static testAll()
    {
        _test := TomlTest()
        _test.should_return_null_if_no_value_for_key()
        _test.should_load_from_file()
        _test.should_support_blank_lines()
        _test.should_allow_comment_after_values()
        _test.should_be_empty_if_no_values()
        _test.should_fail_on_empty_key_name()
        _test.should_fail_on_key_name_with_hash()
        _test.should_fail_on_key_name_starting_with_square_bracket()
        _test.should_fail_when_key_is_overwritten_by_table()
        _test.should_fail_when_key_in_root_is_overwritten_by_table()
        _test.should_fail_when_key_is_overwritten_by_another_key()
    }
}