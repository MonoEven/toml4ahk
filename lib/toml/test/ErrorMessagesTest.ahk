#Include <toml\test\Test>

class ErrorMessagesTest
{
    e := ExpectedException.none()
    
    invalid_table()
    {
        this.e.expectMessage("Invalid table definition on line 1: [in valid]")
        Toml().read("[in valid]")
    }
    
    duplicate_table()
    {
        this.e.expectMessage("Duplicate table definition on line 2: [again]")
        Toml().read("[again]`n[again]")
    }
    
    empty_implicit_table_name()
    {
        this.e.expectMessage("Invalid table definition due to empty implicit table name: [a..b]")
        Toml().read("[a..b]")
    }
    
    duplicate_key()
    {
        this.e.expectMessage("Duplicate key on line 2: k")
        Toml().read("k = 1`n  k = 2")
    }
    
    invalid_key()
    {
        this.e.expectMessage("Key is not followed by an equals sign on line 1: k`" = 1")
        Toml().read("k`" = 1")
    }
    
    invalid_table_array()
    {
        this.e.expectMessage("Invalid table array definition on line 1: [[in valid]]")
        Toml().read("[[in valid]]")
    }
    
    invalid_value()
    {
        this.e.expectMessage("Invalid text after key k on line 1")
        Toml().read("k = 1 t")
    }
    
    unterminated_multiline_literal_string()
    {
        this.e.expectMessage("Unterminated value on line 1: k = '''abc")
        Toml().read("k = '''abc")
    }
    
    unterminated_multiline_string()
    {
        this.e.expectMessage("Unterminated value on line 1: k = `"`"`"abc`"`"")
        Toml().read("k = `"`"`"abc`"`"")
    }
    
    unterminated_array()
    {
        this.e.expectMessage("Unterminated value on line 1: k = [`"abc`"")
        Toml().read("k = [`"abc`"")
    }
    
    unterminated_inline_table()
    {
        this.e.expectMessage("Unterminated value on line 1: k = { a = `"abc`"")
        Toml().read("k = { a = `"abc`"")
    }
    
    key_without_equals()
    {
        this.e.expectMessage("Key is not followed by an equals sign on line 2: k")
        Toml().read("`nk`n=3")
    }
    
    heterogeneous_array()
    {
        this.e.expectMessage("k becomes a heterogeneous array on line 2")
        Toml().read("k = [ 1,`n  1.1 ]")
    }
    
    key_in_root_is_overwritten_by_table()
    {
        this.e.expectMessage("Key already exists for table defined on line 2: [a]")
        Toml().read("a=1`n  [a]")
    }

    table_is_overwritten_by_key()
    {
        this.e.expectMessage("Table already exists for key defined on line 3: b")
        Toml().read("[a.b]`n  [a]`n  b=1")
    }

    should_display_correct_line_number_with_literal_multiline_string()
    {
        this.e.expectMessage("on line 8")
        Toml().read("[table]`n`n k = '''abc`n`ndef`n'''`n # comment `n j = 4.`n l = 5")
    }

    should_display_correct_line_number_with_multiline_string()
    {
        this.e.expectMessage("on line 9")
        Toml().read("[table]`n`n k = `"`"`"`nabc`n`ndef`n`"`"`"`n # comment `n j = 4.`n l = 5")
    }

    should_display_correct_line_number_with_array()
    {
        this.e.expectMessage("on line 10")
        Toml().read("[table]`n`n k = [`"`"`"`nabc`n`ndef`n`"`"`"`n, `n # comment `n j = 4.,`n l = 5`n]")
    }
    
    static testSingle(funcname)
    {
        _test := ErrorMessagesTest()
        try
        {
            _test.%funcname%()
        }
        catch as err
        {
            _test.e.errorCheck(err)
        }
    }
    
    static testAll()
    {
        ErrorMessagesTest.testSingle("invalid_table")
        ErrorMessagesTest.testSingle("duplicate_table")
        ErrorMessagesTest.testSingle("empty_implicit_table_name")
        ErrorMessagesTest.testSingle("duplicate_key")
        ErrorMessagesTest.testSingle("invalid_key")
        ErrorMessagesTest.testSingle("invalid_table_array")
        ErrorMessagesTest.testSingle("invalid_value")
        ErrorMessagesTest.testSingle("unterminated_multiline_literal_string")
        ErrorMessagesTest.testSingle("unterminated_multiline_string")
        ErrorMessagesTest.testSingle("unterminated_array")
        ErrorMessagesTest.testSingle("unterminated_inline_table")
        ErrorMessagesTest.testSingle("key_without_equals")
        ErrorMessagesTest.testSingle("heterogeneous_array")
        ErrorMessagesTest.testSingle("key_in_root_is_overwritten_by_table")
        ErrorMessagesTest.testSingle("table_is_overwritten_by_key")
        ErrorMessagesTest.testSingle("should_display_correct_line_number_with_literal_multiline_string")
        ErrorMessagesTest.testSingle("should_display_correct_line_number_with_multiline_string")
        ErrorMessagesTest.testSingle("should_display_correct_line_number_with_array")
    }
}
