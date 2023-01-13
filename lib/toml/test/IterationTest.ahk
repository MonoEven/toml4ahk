#Include <toml\test\Test>

class IterationTest
{
    expectedException := ExpectedException.none()
    
    should_iterate_over_primitive()
    {
        _toml := Toml().read(this.file("long"))
        entry := _toml.entrySet().iterator().next()
        assertEquals("long", entry.getKey())
        assertEquals(2, entry.getValue())
    }
    
    should_iterate_over_list()
    {
        _toml := Toml().read(this.file("list"))
        entry := _toml.entrySet().iterator().next()
        assertEquals("list", entry.getKey())
        assertThat(entry.getValue(), Matchers.contains("a", "b", "c"))
    }
    
    should_iterate_over_empty_list()
    {
        _toml := Toml().read("list = []")
        entry := _toml.entrySet().iterator().next()
        assertEquals("list", entry.getKey())
        assertThat(entry.getValue(), Matchers.empty())
    }
    
    should_iterate_over_table()
    {
        _toml := Toml().read(this.file("table"))
        entry := _toml.entrySet().iterator().next()
        assertEquals("table", entry.getKey())
        assertEquals("a", entry.getValue().getString("a"))
    }
    
    should_iterate_over_table_array()
    {
        _toml := Toml().read(this.file("table_array"))
        entry := _toml.entrySet().iterator().next()
        tableArray := entry.getValue()
        assertEquals("table_array", entry.getKey())
        assertThat(tableArray, Matchers.contains(Matchers.instanceOf(Toml), Matchers.instanceOf(Toml)))
    }
    
    should_iterate_over_multiple_entries()
    {
        _toml := Toml().read(this.file("multiple"))
        entries := HashMap()
        for entry in _toml.entrySet()
            entries.put(entry.getKey(), entry.getValue())
        assertThat(entries.keySet(), Matchers.contains("a", "b", "c", "e"))
        assertThat(entries, hasEntry("a", "a"))
        assertThat(entries, hasEntry("b", asList(1, 2, 3)))
        assertTrue((entries.get("c")).getBoolean("d"))
        assertThat((entries.get("e")), hasSize(1))
    }
    
    file(name)
    {
        return fileopen(Java.file(format("toml\resources\IteratorTest\{}.toml", name)), "r")
    }
    
    static testAll()
    {
        _test := IterationTest()
        _test.should_iterate_over_primitive()
        _test.should_iterate_over_list()
        _test.should_iterate_over_table()
        _test.should_iterate_over_table_array()
        _test.should_iterate_over_multiple_entries()
    }
}
