#Include <toml\test\Test>

class StringTest
{
    should_get_string()
    {
        _toml := Toml().read("a = `"a`"")
        assertEquals("a", _toml.getString("a"))
    }

    should_get_empty_string()
    {
        _toml := Toml().read("a = `"`"")
        assertEquals("", _toml.getString("a"))
    }

    should_get_empty_string_with_trailing_new_line()
    {
        _toml := Toml().read("a = `"`"`n")
        assertEquals("", _toml.getString("a"))
    }

    should_get_basic_multiline_string()
    {
        _toml := Toml().read(this.file("should_get_basic_multiline_string"))
        assertEquals(_toml.getString("ref"), _toml.getString("one_line"))
        assertEquals(_toml.getString("ref"), _toml.getString("many_lines"))
    }

    should_get_multiline_string_without_new_lines()
    {
        _toml := Toml().read(this.file("should_get_multiline_string_without_new_lines"))
        assertEquals(_toml.getString("ref"), _toml.getString("multi1"))
        assertEquals(_toml.getString("ref"), _toml.getString("multi2"))
    }

    should_get_literal_string()
    {
        _toml := Toml().read(this.file("should_get_literal_string"))
        assertEquals("C:\Users\nodejs\templates", _toml.getString("winpath"))
        assertEquals("\\ServerX\admin$\system32\", _toml.getString("winpath2"))
        assertEquals("Tom `"Dubs`" Preston-Werner", _toml.getString("quoted"))
        assertEquals("<\i\c*\s*>", _toml.getString("regex"))
    }

    should_get_multiline_literal_string()
    {
        _toml := Toml().read(this.file("should_get_multiline_literal_string"))
        assertTrue(!_toml.getString("empty_line"))
        assertEquals(_toml.getString("regex2_ref"), _toml.getString("regex2"))
        assertEquals(_toml.getString("lines_ref"), _toml.getString("lines"))
    }

    should_support_special_characters_in_strings()
    {
        _toml := Toml().read(this.file("should_support_special_characters_in_strings"))
        assertEquals("`" `t `n `r \ `b `f", _toml.getString("key"))
    }

    should_support_unicode_characters_in_strings()
    {
        _toml := Toml().read(this.file("should_support_special_characters_in_strings"))
        assertEquals("more or less ±", _toml.getString("unicode_key"))
        assertEquals("more or less ±", _toml.getString("unicode_key_uppercase"))
    }

    should_fail_on_reserved_special_character_in_strings()
    {
        try
            Toml().read("key=`"\m`"")
    }

    should_fail_on_escaped_slash()
    {
        try
            Toml().read("key=`"\/`"")
    }

    should_fail_on_text_after_literal_string()
    {
        try
            Toml().read("a = ' ' jdkf")
    }

    should_fail_on_unterminated_literal_string()
    {
        try
            Toml().read("a = 'some text")
    }

    should_fail_on_multiline_literal_string_with_malformed_comment()
    {
        try
            Toml().read("a = '''some`n text`n''`nb = '''1'''")
    }

    should_fail_on_unterminated_multiline_literal_string()
    {
        try
            Toml().read("a = '''some`n text`n''")
    }

    should_fail_on_unterminated_multiline_literal_string_on_single_line()
    {
        try
            Toml().read("a = '''some text''")
    }

    should_fail_on_text_outside_multiline_string()
    {
        try
            Toml().read("a = `"`"`" `"`"`" jdkf")
    }

    should_fail_on_unterminated_multiline_string()
    {
        try
            Toml().read("a = `"`"`"some text`"`"")
    }
    
    file(filename)
    {
        return getResourceAsStream(filename ".toml")
    }
    
    static testAll()
    {
        _test := StringTest()
        _test.should_get_string()
        _test.should_get_empty_string()
        _test.should_get_empty_string_with_trailing_new_line()
        _test.should_get_basic_multiline_string()
        _test.should_get_multiline_string_without_new_lines()
        _test.should_get_literal_string()
        _test.should_get_multiline_literal_string()
        _test.should_support_special_characters_in_strings()
        _test.should_support_unicode_characters_in_strings()
        _test.should_fail_on_reserved_special_character_in_strings()
        _test.should_fail_on_escaped_slash()
        _test.should_fail_on_text_after_literal_string()
        _test.should_fail_on_unterminated_literal_string()
        _test.should_fail_on_multiline_literal_string_with_malformed_comment()
        _test.should_fail_on_unterminated_multiline_literal_string()
        _test.should_fail_on_unterminated_multiline_literal_string_on_single_line()
        _test.should_fail_on_text_outside_multiline_string()
        _test.should_fail_on_unterminated_multiline_string()
    }
}
