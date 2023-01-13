#Include <toml\test\Test>

class TomlDefaultsTest
{
    should_fall_back_to_default_value()
    {
        _toml := Toml(this.defaultToml)
        assertEquals("a", _toml.getString("a"))
    }

    should_use_value_when_present_in_values_and_defaults()
    {
        _toml := Toml(this.defaultToml).read("a = `"b`"")
        assertEquals("b", _toml.getString("a"))
    }

    should_return_null_when_no_defaults_for_key()
    {
        _toml := Toml(this.defaultToml).read("")
        assertNull(_toml.getString("b"))
    }

    should_fall_back_to_default_with_multi_key()
    {
        _toml := Toml(this.defaultToml).read("")
        assertEquals("a", _toml.getString("group.a"))
    }

    should_fall_back_to_table()
    {
        _toml := Toml(this.defaultToml).read("")
        assertEquals("a", _toml.getTable("group").getString("a"))
    }

    should_fall_back_to_table_array()
    {
        _toml := Toml(this.defaultToml).read("")
        assertThat(_toml.getTables("array"), hasSize(2))
        assertThat(_toml.getLong("array[1].b"), Matchers.equalTo(2))
    }

    should_perform_shallow_merge()
    {
        _toml := Toml(this.defaultToml).read("[group]`nb=1`n [[array]]`n b=0")
        toml2 := Toml(this.defaultToml).read("[[array]]`n b=1`n [[array]]`n b=2`n [[array]]`n b=3")
        assertEquals(1, _toml.getTable("group").getLong("b"))
        assertNull(_toml.getTable("group").getString("a"))
        assertThat(_toml.getTables("array"), hasSize(1))
        assertEquals(0, _toml.getLong("array[0].b"))
        assertThat(toml2.getTables("array"), hasSize(3))
    }
    
    defaultToml := Toml().read("a = `"a`"`n [group]`n a=`"a`"`n [[array]]`n b=1`n [[array]]`n b=2")
    
    static testAll()
    {
        _test := TomlDefaultsTest()
        _test.should_fall_back_to_default_value()
        _test.should_use_value_when_present_in_values_and_defaults()
        _test.should_return_null_when_no_defaults_for_key()
        _test.should_fall_back_to_default_with_multi_key()
        _test.should_fall_back_to_table()
        _test.should_fall_back_to_table_array()
        _test.should_perform_shallow_merge()
    }
}
