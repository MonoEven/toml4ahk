#Include <toml\test\Test>

class TableTest
{
    should_get_table()
    {
        _toml := Toml().read("[group]`nkey = `"value`"")
        group := _toml.getTable("group")
        assertEquals("value", group.getString("key"))
    }

    should_get_value_for_multi_key()
    {
        _toml := Toml().read("[group]`nkey = `"value`"")
        assertEquals("value", _toml.getString("group.key"))
    }

    should_get_value_for_multi_key_with_no_parent_table()
    {
        _toml := Toml().read("[group.sub]`nkey = `"value`"")
        assertEquals("value", _toml.getString("group.sub.key"))
    }

    should_get_table_for_multi_key()
    {
        _toml := Toml().read("[group]`nother=1`n[group.sub]`nkey = `"value`"")
        assertEquals("value", _toml.getTable("group.sub").getString("key"))
    }

    should_get_table_for_multi_key_with_no_parent_table()
    {
        _toml := Toml().read("[group.sub]`nkey = `"value`"")
        assertEquals("value", _toml.getTable("group.sub").getString("key"))
    }

    should_get_value_from_table_with_sub_table()
    {
        _toml := Toml().read("[a.b]`nc=1`n[a]`nd=2")
        assertEquals(2, _toml.getLong("a.d"))
        assertEquals(1, _toml.getTable("a.b").getLong("c"))
    }

    should_get_empty_table()
    {
        _toml := Toml().read("[a]")
        assertTrue(_toml.getTable("a").isEmpty())
    }

    should_return_null_for_missing_table()
    {
        assertNull(Toml().getTable("a"))
    }

    should_accept_table_name_with_basic_string()
    {
        _toml := Toml().read("[`"a`"]`nb = 'b'")
        assertEquals("b", _toml.getString("`"a`".b"))
    }

    should_accept_table_name_part_with_basic_string()
    {
        _toml := Toml().read("[target.`"cfg(unix)`".dependencies]`nb = 'b'")
        assertEquals("b", _toml.getString("target.`"cfg(unix)`".dependencies.b"))
    }

    should_accept_table_name_part_with_whitespace_and_basic_string()
    {
        _toml := Toml().read("[ target . `"cfg (unix)`" . dependencies ]`nb = 'b'")
        assertEquals("b", _toml.getString("target.`"cfg (unix)`".dependencies.b"))
    }

    should_accept_table_name_with_literal_string()
    {
        _toml := Toml().read("['a']`nb = 'b'")
        assertEquals("b", _toml.getString("'a'.b"))
    }

    should_accept_table_name_part_with_literal_string()
    {
        _toml := Toml().read("[target.'cfg(unix)'.dependencies]`nb = 'b'")
        assertEquals("b", _toml.getString("target.'cfg(unix)'.dependencies.b"))
    }

    should_accept_table_name_part_with_whitespace_and_literal_string()
    {
        _toml := Toml().read("[target . 'cfg(unix)' . dependencies]`nb = 'b'")
        assertEquals("b", _toml.getString("target.'cfg(unix)'.dependencies.b"))
    }

    should_return_null_when_navigating_to_missing_value()
    {
        _toml := Toml()
        assertNull(_toml.getString("a.b"))
        assertNull(_toml.getList("a.b"))
        assertNull(_toml.getTable("a.b"))
    }

    should_return_null_when_no_value_for_multi_key()
    {
        _toml := Toml().read("")
        assertNull(_toml.getString("group.key"))
    }

    should_fail_when_table_defined_twice()
    {
        try
            Toml().read("[a]`nb=1`n[a]`nc=2")
    }

    should_fail_when_illegal_characters_after_table()
    {
        try
            Toml().read("[error]   if you didn't catch this, your parser is broken")
    }
    
    static testAll()
    {
        _test := TableTest()
        _test.should_get_table()
        _test.should_get_value_for_multi_key()
        _test.should_get_value_for_multi_key_with_no_parent_table()
        _test.should_get_table_for_multi_key()
        _test.should_get_table_for_multi_key_with_no_parent_table()
        _test.should_get_value_from_table_with_sub_table()
        _test.should_get_empty_table()
        _test.should_return_null_for_missing_table()
        _test.should_accept_table_name_with_basic_string()
        _test.should_accept_table_name_part_with_basic_string()
        _test.should_accept_table_name_part_with_whitespace_and_basic_string()
        _test.should_accept_table_name_with_literal_string()
        _test.should_accept_table_name_part_with_literal_string()
        _test.should_accept_table_name_part_with_whitespace_and_literal_string()
        _test.should_return_null_when_navigating_to_missing_value()
        _test.should_return_null_when_no_value_for_multi_key()
        _test.should_fail_when_table_defined_twice()
        _test.should_fail_when_illegal_characters_after_table()
    }
}
