#Include <toml\test\Test>

class TomlReadTest
{
    should_read_input_stream()
    {
        _toml := Toml().read(getResourceAsStream("should_load_from_file.toml"))
        assertEquals("value", _toml.getString("key"))
    }

    should_read_reader()
    {
        _toml := Toml().read(StringReader("key=1"))
        assertEquals(1, _toml.getLong("key"))
    }

    should_fail_on_missing_file()
    {
        try
            Toml().read(Java.fileopen("missing"))
        catch RuntimeException as e
            assertThat(e, Matchers.instanceOf(FileNotFoundException))
    }

    should_read_toml_without_defaults()
    {
        toml1 := Toml().read("a = 1")
        toml2 := Toml().read(toml1)
        assertEquals(toml1.getLong("a"), toml2.getLong("a"))
    }

    should_read_toml_and_merge_with_defaults()
    {
        toml1 := Toml().read("a = 1`nc = 3`nd = 5")
        toml2 := Toml().read("b = 2`nc = 4")
        mergedToml := Toml(toml1).read(toml2)
        assertEquals(toml1.getLong("a"), mergedToml.getLong("a"))
        assertEquals(toml2.getLong("b"), mergedToml.getLong("b"))
        assertEquals(toml2.getLong("c"), mergedToml.getLong("c"))
        assertEquals(toml1.getLong("d"), mergedToml.getLong("d"))
    }
    
    static testAll()
    {
        _test := TomlReadTest()
        _test.should_read_input_stream()
        _test.should_read_reader()
        _test.should_fail_on_missing_file()
        _test.should_read_toml_without_defaults()
        _test.should_read_toml_and_merge_with_defaults()
    }
}
