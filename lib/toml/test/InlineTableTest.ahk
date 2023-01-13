#Include <toml\test\Test>

class InlineTableTest
{
    e := ExpectedException.none()
    
    should_read_empty_inline_table()
    {
        _toml := Toml().read("key = {}")
        assertTrue(_toml.getTable("key").isEmpty())
    }
    
    should_read_inline_table_with_strings()
    {
        _toml := Toml().read("name = { first = `"Tom`", last = `"Preston-Werner`"}")
        assertEquals("Tom", _toml.getTable("name").getString("first"))
        assertEquals("Preston-Werner", _toml.getString("name.last"))
    }

    should_read_inline_table_with_integers()
    {
        _toml := Toml().read("point = { x = 1, y = 2 }")
        assertEquals(1, _toml.getTable("point").getLong("x"))
        assertEquals(2, _toml.getLong("point.y"))
    }

    should_read_inline_table_with_floats()
    {
        _toml := Toml().read("point = { x = 1.5, y = 2.3 }")
        assertEquals(1.5, _toml.getTable("point").getDouble("x"))
        assertEquals(2.3, _toml.getDouble("point.y"))
    }

    should_read_inline_table_with_booleans()
    {
        _toml := Toml().read("point = { x = false, y = true }")
        assertTrue(_toml.getTable("point").getBoolean("y"))
        assertFalse(_toml.getBoolean("point.x"))
    }

    should_read_arrays()
    {
        _toml := Toml().read("arrays = { integers = [1, 2, 3], strings = [`"a`", `"b`", `"c`"] }")
        assertThat(_toml.getList("arrays.integers"), Matchers.contains(1, 2, 3))
        assertThat(_toml.getList("arrays.strings"), Matchers.contains("a", "b", "c"))
    }

    should_read_nested_arrays()
    {
        _toml := Toml().read("arrays = { nested = [[1, 2, 3], [4, 5, 6]] }").getTable("arrays")
        nested := _toml.getList("nested")
        assertThat(nested, hasSize(2))
        assertThat(nested.get(0), Matchers.contains(1, 2, 3))
        assertThat(nested.get(1), Matchers.contains(4, 5, 6))
    }

    should_read_mixed_inline_table()
    {
        _toml := Toml().read("point = { date = 2015-02-09T22:05:00Z, bool = true, integer = 123, float = 123.456, string = `"abc`", list = [5, 6, 7, 8] }").getTable("point")
        assertTrue(_toml.getBoolean("bool"))
        assertEquals(123, _toml.getLong("integer"))
        assertEquals(123.456, _toml.getDouble("float"))
        assertEquals("abc", _toml.getString("string"))
        assertThat(_toml.getList("list"), Matchers.contains(5, 6, 7, 8))
    }

    should_read_nested_inline_tables()
    {
        tables := Toml().read("tables = { t1 = { t1_1 = 1, t1_2 = 2}, t2 = { t2_1 = { t2_1_1 = `"a`" }} }").getTable("tables")
        assertEquals(1, tables.getLong("t1.t1_1"))
        assertEquals(2, tables.getLong("t1.t1_2"))
        assertEquals("a", tables.getString("t2.t2_1.t2_1_1"))
    }

    should_read_all_string_types()
    {
        strings := Toml().read("strings = { literal = 'ab]`"c', multiline = `"`"`"de]`"f`"`"`", multiline_literal = '''gh]`"i''' }").getTable("strings")
        assertEquals("ab]`"c", strings.getString("literal"))
        assertEquals("de]`"f", strings.getString("multiline"))
        assertEquals("gh]`"i", strings.getString("multiline_literal"))
    }

    should_read_inline_table_in_regular_table()
    {
        _toml := Toml().read("[tbl]`n tbl = { tbl = 1 }")
        assertEquals(1, _toml.getLong("tbl.tbl.tbl"))
    }

    should_mix_with_tables()
    {
        _toml := Toml().read("t = { k = 1 }`n  [b]`n  k = 2`n  t = { k = 3}")
        assertEquals(1, _toml.getLong("t.k"))
        assertEquals(2, _toml.getLong("b.k"))
        assertEquals(3, _toml.getLong("b.t.k"))
    }

    should_add_properties_to_existing_inline_table()
    {
        _toml := Toml().read("[a]`n  b = {k = 1}`n  [a.b.c]`n k = 2")
        assertEquals(1, _toml.getLong("a.b.k"))
        assertEquals(2, _toml.getLong("a.b.c.k"))
    }

    should_mix_with_table_arrays()
    {
        _toml := Toml().read("t = { k = 1 }`n  [[b]]`n  t = { k = 2 }`n [[b]]`n  t = { k = 3 }")
        assertEquals(1, _toml.getLong("t.k"))
        assertEquals(2, _toml.getLong("b[0].t.k"))
        assertEquals(3, _toml.getLong("b[1].t.k"))
    }

    should_fail_on_invalid_key()
    {
        Toml().read("tbl = { a. = 1 }")
    }

    should_fail_when_unterminated()
    {
        Toml().read("tbl = { a = 1 ")
    }

    should_fail_on_invalid_value()
    {
        Toml().read("tbl = { a = abc }")
    }

    should_fail_when_key_duplicated_inside_inline_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate key on line 1: a")
        Toml().read("tbl = { a = 1, a = 2 }")
    }

    should_fail_when_duplicated_by_other_key()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Table already exists for key defined on line 2: tbl")
        Toml().read("tbl = { a = 1 }`n tbl = 1")
    }

    should_fail_when_duplicated_by_other_inline_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate table definition on line 2: [tbl]")
        Toml().read("tbl = { a = 1 }`n tbl = {}")
    }

    should_fail_when_duplicated_by_top_level_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate table definition on line 2: [tbl]")
        Toml().read("tbl = {}`n [tbl]")
    }

    should_fail_when_duplicates_second_level_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate table definition on line 3: [a.b]")
        Toml().read("[a.b]`n  [a]`n b = {}")
    }

    should_fail_when_inline_table_duplicates_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate table definition on line 3: [a.b]")
        Toml().read("[a.b]`n [a]`n b = {}")
    }

    should_fail_when_second_level_table_duplicates_inline_table()
    {
        this.e.expect(IllegalStateException)
        this.e.expectMessage("Duplicate table definition on line 3: [a.b]")
        Toml().read("[a]`n b = {}`n  [a.b]")
    }
    
    static testSingle(funcname)
    {
        _test := InlineTableTest()
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
        InlineTableTest.testSingle("should_read_empty_inline_table")
        InlineTableTest.testSingle("should_read_inline_table_with_strings")
        InlineTableTest.testSingle("should_read_inline_table_with_integers")
        InlineTableTest.testSingle("should_read_inline_table_with_floats")
        InlineTableTest.testSingle("should_read_inline_table_with_booleans")
        InlineTableTest.testSingle("should_read_arrays")
        InlineTableTest.testSingle("should_read_nested_arrays")
        InlineTableTest.testSingle("should_read_mixed_inline_table")
        InlineTableTest.testSingle("should_read_nested_inline_tables")
        InlineTableTest.testSingle("should_read_all_string_types")
        InlineTableTest.testSingle("should_read_inline_table_in_regular_table")
        InlineTableTest.testSingle("should_mix_with_tables")
        InlineTableTest.testSingle("should_add_properties_to_existing_inline_table")
        InlineTableTest.testSingle("should_mix_with_table_arrays")
        InlineTableTest.testSingle("should_fail_on_invalid_key")
        InlineTableTest.testSingle("should_fail_when_unterminated")
        InlineTableTest.testSingle("should_fail_on_invalid_value")
        InlineTableTest.testSingle("should_fail_when_key_duplicated_inside_inline_table")
        InlineTableTest.testSingle("should_fail_when_duplicated_by_other_key")
        InlineTableTest.testSingle("should_fail_when_duplicated_by_other_inline_table")
        InlineTableTest.testSingle("should_fail_when_duplicated_by_top_level_table")
        InlineTableTest.testSingle("should_fail_when_duplicates_second_level_table")
        InlineTableTest.testSingle("should_fail_when_inline_table_duplicates_table")
        InlineTableTest.testSingle("should_fail_when_second_level_table_duplicates_inline_table")
    }
}
