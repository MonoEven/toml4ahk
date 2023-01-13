#Include <toml\test\Test>

class BareKeysTest
{
    should_ignore_spaces_around_key_segments()
    {
        _toml := Toml().read("[ a . b   . c  ]  `n  key = `"a`"")
        assertEquals("a", _toml.getString("a.b.c.key"))
    }
    
    should_support_underscores_in_key_names()
    {
        _toml := Toml().read("a_a = 1")
        assertEquals(1, _toml.getLong("a_a"))
    }
    
    should_support_underscores_in_table_names()
    {
        _toml := Toml().read("[group_a]`na = 1")
        assertEquals(1, _toml.getLong("group_a.a"))
    }
    
    should_support_numbers_in_key_names()
    {
        _toml := Toml().read("a1 = 1")
        assertEquals(1, _toml.getLong("a1"))
    }
    
    should_support_numbers_in_table_names()
    {
        _toml := Toml().read("[group1]`na = 1")
        assertEquals(1, _toml.getLong("group1.a"))
    }
    
    should_fail_when_characters_outside_accept_range_are_used_in_table_name()
    {
        try
            Toml().read("[~]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_when_characters_outside_accept_range_are_used_in_table_array_name()
    {
        try
            Toml().read("[[~]]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_when_dots_in_key_name()
    {
        try
            Toml().read("a.b = 1")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_when_characters_outside_accept_range_are_used_in_key_name()
    {
        try
            Toml().read("~ = 1")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_sharp_sign_in_table_name()
    {
        try
            Toml().read("[group#]`nkey=1")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_spaces_in_table_name()
    {
        try
            Toml().read("[valid  key]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_sharp_sign_in_table_array_name()
    {
        try
            Toml().read("[[group#]]`nkey=1")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_spaces_in_table_array_name()
    {
        try
            Toml().read("[[valid  key]]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_question_marks_in_key_name()
    {
        try
            Toml().read("key?=true")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_empty_table_name()
    {
        try
            Toml().read("[]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_name_ending_with_empty_table_name()
    {
        try
            Toml().read("[a.]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_name_containing_empty_table_name()
    {
        try
            Toml().read("[a..b]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_name_starting_with_empty_table_name()
    {
        try
            Toml().read("[.b]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_array_name_ending_with_empty_table_name()
    {
        try
            Toml().read("[[a.]]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_array_name_containing_empty_table_name()
    {
        try
            Toml().read("[[a..b]]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    should_fail_on_nested_table_array_name_starting_with_empty_table_name()
    {
        try
            Toml().read("[[.b]]")
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    static testAll()
    {
        _test := BareKeysTest()
        _test.should_ignore_spaces_around_key_segments()
        _test.should_support_underscores_in_key_names()
        _test.should_support_underscores_in_table_names()
        _test.should_support_numbers_in_key_names()
        _test.should_support_numbers_in_table_names()
        _test.should_fail_when_characters_outside_accept_range_are_used_in_table_name()
        _test.should_fail_when_characters_outside_accept_range_are_used_in_table_array_name()
        _test.should_fail_when_dots_in_key_name()
        _test.should_fail_when_characters_outside_accept_range_are_used_in_key_name()
        _test.should_fail_on_sharp_sign_in_table_name()
        _test.should_fail_on_spaces_in_table_name()
        _test.should_fail_on_sharp_sign_in_table_array_name()
        _test.should_fail_on_spaces_in_table_array_name()
        _test.should_fail_on_question_marks_in_key_name()
        _test.should_fail_on_empty_table_name()
        _test.should_fail_on_nested_table_name_ending_with_empty_table_name()
        _test.should_fail_on_nested_table_name_containing_empty_table_name()
        _test.should_fail_on_nested_table_name_starting_with_empty_table_name()
        _test.should_fail_on_nested_table_array_name_ending_with_empty_table_name()
        _test.should_fail_on_nested_table_array_name_containing_empty_table_name()
        _test.should_fail_on_nested_table_array_name_starting_with_empty_table_name()
    }
}
