#Include <toml\test\Test>

class BurntSushiInvalidTest
{
    key_empty()
    {
        this.runInvalidTest("key-empty")
    }
    
    key_hash()
    {
        this.runInvalidTest("key-hash")
    }
    
    key_newline()
    {
        this.runInvalidTest("key-newline")
    }
    
    key_open_bracket()
    {
        this.runInvalidTest("key-open-bracket")
    }
    
    key_single_open_bracket()
    {
        this.runInvalidTest("key-single-open-bracket")
    }
    
    key_start_bracket()
    {
        this.runInvalidTest("key-start-bracket")
    }
    
    key_two_equals()
    {
        this.runInvalidTest("key-two-equals")
    }
    
    string_bad_byte_escape()
    {
        this.runInvalidTest("string-bad-byte-escape")
    }
    
    string_bad_escape()
    {
        this.runInvalidTest("string-bad-escape")
    }
    
    string_byte_escapes()
    {
        this.runInvalidTest("string-byte-escapes")
    }
    
    string_no_close()
    {
        this.runInvalidTest("string-no-close")
    }
    
    table_array_implicit()
    {
        this.runInvalidTest("table-array-implicit")
    }
    
    table_array_malformed_bracket()
    {
        this.runInvalidTest("table-array-malformed-bracket")
    }
    
    table_array_malformed_empty()
    {
        this.runInvalidTest("table-array-malformed-empty")
    }
    
    table_empty()
    {
        this.runInvalidTest("table-empty")
    }
    
    table_nested_brackets_close()
    {
        this.runInvalidTest("table-nested-brackets-close")
    }
    
    table_nested_brackets_open()
    {
        this.runInvalidTest("table-nested-brackets-open")
    }
    
    empty_implicit_table()
    {
        this.runInvalidTest("empty-implicit-table")
    }
    
    empty_table()
    {
        this.runInvalidTest("empty-table")
    }
    
    array_mixed_types_ints_and_floats()
    {
        this.runInvalidTest("array-mixed-types-ints-and-floats")
    }
    
    array_mixed_types_arrays_and_ints()
    {
        this.runInvalidTest("array-mixed-types-arrays-and-ints")
    }
    
    array_mixed_types_strings_and_ints()
    {
        this.runInvalidTest("array-mixed-types-strings-and-ints")
    }
    
    datetime_malformed_no_leads()
    {
        this.runInvalidTest("datetime-malformed-no-leads")
    }
    
    datetime_malformed_no_secs()
    {
        this.runInvalidTest("datetime-malformed-no-secs")
    }

    datetime_malformed_no_t()
    {
        this.runInvalidTest("datetime-malformed-no-t")
    }

    datetime_malformed_no_z()
    {
        this.runInvalidTest("datetime-malformed-no-z")
    }

    datetime_malformed_with_milli()
    {
        this.runInvalidTest("datetime-malformed-with-milli")
    }

    duplicate_key_table()
    {
        this.runInvalidTest("duplicate-key-table")
    }

    duplicate_keys()
    {
        this.runInvalidTest("duplicate-keys")
    }

    duplicate_tables()
    {
        this.runInvalidTest("duplicate-tables")
    }

    float_no_leading_zero()
    {
        this.runInvalidTest("float-no-leading-zero")
    }

    float_no_trailing_digits()
    {
        this.runInvalidTest("float-no-trailing-digits")
    }

    text_after_array_entries()
    {
        this.runInvalidTest("text-after-array-entries")
    }

    text_after_integer()
    {
        this.runInvalidTest("text-after-integer")
    }

    text_after_string()
    {
        this.runInvalidTest("text-after-string")
    }

    text_after_table()
    {
        this.runInvalidTest("text-after-table")
    }

    text_before_array_separator()
    {
        this.runInvalidTest("text-before-array-separator")
    }

    text_in_array()
    {
        this.runInvalidTest("text-in-array")
    }
    
    runInvalidTest(testName)
    {
        inputToml := getResourceAsStream("burntsushi/invalid/" testName ".toml")
        try
        {
            Toml().read(inputToml)
            Toml.Assert.fail("Should have rejected invalid input!")
        }
        catch error as err
            assertEquals(err is IllegalStateException, true)
    }
    
    static testAll()
    {
        _test := BurntSushiInvalidTest()
        _test.key_empty()
        _test.key_hash()
        _test.key_newline()
        _test.key_open_bracket()
        _test.key_single_open_bracket()
        _test.key_start_bracket()
        _test.key_two_equals()
        _test.string_bad_byte_escape()
        _test.string_bad_escape()
        _test.string_byte_escapes()
        _test.string_no_close()
        _test.table_array_implicit()
        _test.table_array_malformed_bracket()
        _test.table_array_malformed_empty()
        _test.table_empty()
        _test.table_nested_brackets_close()
        _test.table_nested_brackets_open()
        _test.empty_implicit_table()
        _test.empty_table()
        _test.array_mixed_types_ints_and_floats()
        _test.array_mixed_types_arrays_and_ints()
        _test.array_mixed_types_strings_and_ints()
        _test.datetime_malformed_no_leads()
        _test.datetime_malformed_no_secs()
        _test.datetime_malformed_no_t()
        _test.datetime_malformed_no_z()
        _test.datetime_malformed_with_milli()
        _test.duplicate_key_table()
        _test.duplicate_keys()
        _test.duplicate_tables()
        _test.float_no_leading_zero()
        _test.float_no_trailing_digits()
        _test.text_after_array_entries()
        _test.text_after_integer()
        _test.text_after_string()
        _test.text_after_table()
        _test.text_before_array_separator()
        _test.text_in_array()
    }
}
