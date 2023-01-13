#Include <toml\test\Test>

class ContainsTest
{
    should_contain_top_level_of_any_type()
    {
        _toml := Toml().read("a = 1  `n  [b]  `n  b1 = 1  `n  [[c]]  `n c1 = 1")
        assertTrue(_toml.contains("a"))
        assertTrue(_toml.contains("b"))
        assertTrue(_toml.contains("c"))
        assertFalse(_toml.contains("d"))
    }
    
    should_contain_nested_of_any_type()
    {
        _toml := Toml().read("[a]  `n  a1 = 1  `n  [[b]]  `n b1 = 1  `n  [[b]]  `n b1 = 2  `n  b2 = 3")
        assertTrue(_toml.contains("a.a1"))
        assertTrue(_toml.contains("b[0].b1"))
        assertTrue(_toml.contains("b[1].b1"))
        assertFalse(_toml.contains("b[2].b1"))
        assertFalse(_toml.contains("c.d"))
    }
    
    should_contain_primitive()
    {
        _toml := Toml().read("a = 1  `n  [b]  `n  b1 = 1  `n  [[c]]  `n c1 = 1")
        assertTrue(_toml.containsPrimitive("a"))
        assertTrue(_toml.containsPrimitive("b.b1"))
        assertTrue(_toml.containsPrimitive("c[0].c1"))
        assertFalse(_toml.containsPrimitive("b"))
        assertFalse(_toml.containsPrimitive("c"))
        assertFalse(_toml.containsPrimitive("d"))
    }
    
    should_contain_table()
    {
        _toml := Toml().read("a = 1  `n  [b]  `n  b1 = 1  `n  [b.b2]  `n  [[c]]  `n c1 = 1  `n [c.c2]")
        assertTrue(_toml.containsTable("b"))
        assertTrue(_toml.containsTable("b.b2"))
        assertTrue(_toml.containsTable("c[0].c2"))
        assertFalse(_toml.containsTable("a"))
        assertFalse(_toml.containsTable("b.b1"))
        assertFalse(_toml.containsTable("c"))
        assertFalse(_toml.containsTable("c[0].c1"))
        assertFalse(_toml.containsTable("d"))
    }
    
    should_contain_table_array()
    {
        _toml := Toml().read("a = 1  `n  [b]  `n  b1 = 1  `n  [[c]]  `n c1 = 1  `n [c.c2] `n  [[c]]  `n  [[c.c3]] `n c4 = 4")
        assertTrue(_toml.containsTableArray("c"))
        assertTrue(_toml.containsTableArray("c[1].c3"))
        assertFalse(_toml.containsTableArray("a"))
        assertFalse(_toml.containsTableArray("b"))
        assertFalse(_toml.containsTableArray("b.b1"))
        assertFalse(_toml.containsTableArray("c[1].c3[0].c4"))
        assertFalse(_toml.containsTableArray("d"))
    }
    
    should_not_contain_when_parent_table_is_missing()
    {
        _toml := Toml().read("a = `"1`"")
        assertFalse(_toml.contains("b.b1"))
        assertFalse(_toml.containsPrimitive("b.b1"))
        assertFalse(_toml.containsTable("b.b1"))
        assertFalse(_toml.containsTableArray("b.b1"))
    }
    
    static TestAll()
    {
        _test := ContainsTest()
        _test.should_contain_top_level_of_any_type()
        _test.should_contain_nested_of_any_type()
        _test.should_contain_primitive()
        _test.should_contain_table()
    }
}
