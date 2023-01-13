#Include <toml\test\Test>

class QuotedKeysTest
{
    should_accept_quoted_key_for_value()
    {
        _toml := Toml().read("`"127.0.0.1`" = `"localhost`"  `n  `"character encoding`" = `"UTF-8`" `n  `"ʎǝʞ`" = `"value`"")
        assertEquals("localhost", _toml.getString("`"127.0.0.1`""))
        assertEquals("UTF-8", _toml.getString("`"character encoding`""))
        assertEquals("value", _toml.getString("`"ʎǝʞ`""))
    }

    should_accept_quoted_key_for_table_name()
    {
        _toml := Toml().read("[`"abc def`"]`n  val = 1")
        assertEquals(1, _toml.getTable("`"abc def`"").getLong("val"))
    }

    should_accept_partially_quoted_table_name()
    {
        _toml := Toml().read("[dog.`"tater.man`"]  `n  type = `"pug0`"  `n[dog.tater]  `n  type = `"pug1`"`n[dog.tater.man]  `n  type = `"pug2`"")
        dogs := _toml.getTable("dog")
        assertEquals("pug0", dogs.getTable("`"tater.man`"").getString("type"))
        assertEquals("pug1", dogs.getTable("tater").getString("type"))
        assertEquals("pug2", dogs.getTable("tater").getTable("man").getString("type"))
        assertEquals("pug0", _toml.getString("dog.`"tater.man`".type"))
        assertEquals("pug2", _toml.getString("dog.tater.man.type"))
    }

    should_conserve_quoted_key_in_map()
    {
        _toml := Toml().read("[dog.`"tater.man`"]  `n  type = `"pug0`"  `n[dog.tater]  `n  type = `"pug1`"`n[dog.tater.man]  `n  type = `"pug2`"")
        dogs := _toml.getTable("dog")
        _map := dogs.to(QuotedKeysTest.Map)
        assertEquals("pug0", _map.%"`"tater.man`""%.%"type"%)
        assertEquals("pug1", _map.%"tater"%.%"type"%)
        assertEquals("pug2", _map.%"tater"%.%"man"%.%"type"%)
    }

    should_convert_quoted_keys_to_map_but_not_to_object_fields()
    {
        quoted := Toml().read("`"ʎǝʞ`" = `"value`"  `n[map]  `n  `"ʎǝʞ`" = `"value`"").to(QuotedKeysTest.Quoted, , protoFlag := false)
        assertFalse(quoted.hasprop("ʎǝʞ"))
        assertEquals("value", quoted.map.%"`"ʎǝʞ`""%)
    }

    should_support_table_array_index_with_quoted_key()
    {
        _toml := Toml().read("[[ dog. `" type`" ]] `n  name = `"type0`"  `n  [[dog.`" type`"]]  `n  name = `"type1`"")
        assertEquals("type0", _toml.getString("dog.`" type`"[0].name"))
        assertEquals("type1", _toml.getString("dog.`" type`"[1].name"))
    }

    should_support_table_array_index_with_dot_in_quoted_key()
    {
        _toml := Toml().read("[[ dog. `"a.type`" ]] `n  name = `"type0`"")
        assertEquals("type0", _toml.getString("dog.`"a.type`"[0].name"))
    }

    should_support_quoted_key_containing_square_brackets()
    {
        _toml := Toml().read("[dog.`" type[abc]`"] `n  name = `"type0`"  `n  [dog.`" type[1]`"]  `n  `"name[]`" = `"type1`"")
        assertEquals("type0", _toml.getString("dog.`" type[abc]`".name"))
        assertEquals("type1", _toml.getString("dog.`" type[1]`".`"name[]`""))
    }

    should_support_quoted_key_containing_escaped_quote()
    {
        _toml := Toml().read("[dog.`"ty\`"pe`"] `n  `"na\`"me`" = `"type0`"")
        assertEquals("type0", _toml.getString("dog.`"ty\`"pe`".`"na\`"me`""))
    }

    should_support_fully_quoted_table_name()
    {
        _toml := Toml().read("[`"abc.def`"]  `n  key = 1")
        assertEquals(1, _toml.getLong("`"abc.def`".key"))
    }

    should_support_whitespace_around_key_segments()
    {
        _toml := Toml().read("[  dog. `"type`". breed   ] `n  name = `"type0`"")
        assertEquals("type0", _toml.getString("dog.`"type`".breed.name"))
    }

    should_support_unicode()
    {
        _toml := Toml().read("[[`"\u00B1`"]]`n  `"\u00B1`" = `"a`"`n [`"\u00B11`"]`n  `"±`" = 1")
        assertThat(_toml.getTables("`"±`""), hasSize(1))
        assertEquals("a", _toml.getTables("`"±`"").get(0).getString("`"±`""))
        assertEquals(1, _toml.getTable("`"±1`"").getLong("`"±`""))
    }

    should_fail_on_malformed_quoted_key()
    {
        try
            Toml().read("k`"ey`" = 1")
    }

    should_fail_on_malformed_quoted_table()
    {
        try
            Toml().read("[a`"bc`"]")
    }

    should_fail_on_malformed_quoted_nested_table()
    {
        try
            Toml().read("[a.a`"bc`"]")
    }
    
    static testAll()
    {
        _test := QuotedKeysTest()
        _test.should_accept_quoted_key_for_value()
        _test.should_accept_quoted_key_for_table_name()
        _test.should_accept_partially_quoted_table_name()
        _test.should_convert_quoted_keys_to_map_but_not_to_object_fields()
        _test.should_support_table_array_index_with_quoted_key()
        _test.should_support_table_array_index_with_dot_in_quoted_key()
        _test.should_support_quoted_key_containing_square_brackets()
        _test.should_support_quoted_key_containing_escaped_quote()
        _test.should_support_fully_quoted_table_name()
        _test.should_support_whitespace_around_key_segments()
        _test.should_support_unicode()
        _test.should_fail_on_malformed_quoted_key()
        _test.should_fail_on_malformed_quoted_table()
        _test.should_fail_on_malformed_quoted_nested_table()
    }
    
    class Map
    {
        
    }
    
    class Quoted
    {
        
    }
}
