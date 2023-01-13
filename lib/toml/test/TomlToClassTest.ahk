#Include <toml\test\Test>

class TomlToClassTest
{
    should_convert_toml_primitives()
    {
        _toml := Toml().read(this.file("should_convert_primitive_values.toml"))
        values := _toml.to(TomlToClassTest.TomlPrimitives1, , protoFlag := false)
        assertEquals("string", values.string)
        assertEquals(123, values.number)
        assertEquals(2.1, values.decimal)
        assertTrue(values.bool)
    }

    should_convert_to_non_toml_primitives()
    {
        extraPrimitives := Toml().read(this.file("should_convert_extra_primitives.toml")).to(TomlToClassTest.ExtraPrimitives, , protoFlag := false)
        assertEquals("value", extraPrimitives.group.key)
        assertEquals(1.2, extraPrimitives.bigDecimal)
        assertEquals(5, extraPrimitives.bigInteger)
        assertEquals(3, extraPrimitives.aShort)
        assertEquals(7, extraPrimitives.anInteger)
        assertEquals('u', extraPrimitives.character)
        assertEquals("http://www.example.com", extraPrimitives.url)
        assertEquals("http://www.test.com", extraPrimitives.uri)
        assertThat(ArrayList(extraPrimitives.set*), Matchers.contains("a", "b"))
        assertThat(ArrayList(extraPrimitives.strings*), Matchers.contains("c", "d"))
        assertEquals("CONSTRUCTOR", extraPrimitives.elementType)
    }

    should_convert_tables()
    {
        fileName := "should_convert_tables.toml"
        _toml := Toml().read(this.file(fileName))
        tomlTables := _toml.to(TomlToClassTest.TomlTables1, , protoFlag := false)
        assertEquals("value1", tomlTables.group1.string)
        assertEquals("value2", tomlTables.group2.string)
    }

    should_convert_tables_with_defaults()
    {
        defaultToml := Toml().read("[group2]`n string=`"defaultValue2`"`n number=2`n [group3]`n string=`"defaultValue3`"")
        _toml := Toml(defaultToml).read(this.file("should_convert_tables.toml"))
        tomlTables := _toml.to(TomlToClassTest.TomlTables2, , protoFlag := false)
        assertEquals("value1", tomlTables.group1.string)
        assertEquals("value2", tomlTables.group2.string[2])
        ; !!!
            assertTrue(tomlTables.group2.hasprop("number"))
        assertEquals("defaultValue3", tomlTables.group3.string)
    }

    should_use_defaults()
    {
        defaults := Toml().read(this.file("should_convert_tables.toml"))
        _toml := Toml(defaults).read("")
        tomlTables := _toml.to(TomlToClassTest.TomlTables3, , protoFlag := false)
        assertEquals("value1", tomlTables.group1.string)
        assertEquals("value2", tomlTables.group2.string)
    }

    should_ignore_keys_not_in_class()
    {
        tomlPrimitives := Toml().read("a=1`nstring=`"s`"").to(TomlToClassTest.TomlPrimitives2, , protoFlag := false)
        assertEquals("s", tomlPrimitives.string)
    }

    should_convert_table_array()
    {
        _toml := Toml().read(this.file("should_convert_table_array_to_class.toml")).to(TomlToClassTest.TomlTableArrays, , protoFlag := false)
        assertEquals("grouper 1", _toml.groupers.string[1])
        assertEquals("grouper 2", _toml.groupers.string[2])
        assertEquals("My Name", _toml.name)
        assertEquals(12, _toml.primitives.number)
    }

    should_convert_fruit_table_array()
    {
        fruitArray := Toml().read(this.file("fruit_table_array.toml")).to(TomlToClassTest.FruitArray, , protoFlag := false)
        apple := fruitArray.fruit
        assertEquals("apple", apple.name[1])
        assertEquals("red", apple.physical.color)
        assertEquals("round", apple.physical.shape)
        assertEquals("red delicious", apple.variety.name[1])
        assertEquals("granny smith", apple.variety.name[2])
        banana := fruitArray.fruit
        assertEquals("banana", banana.name[2])
        assertEquals("plantain", banana.variety.name[3])
    }
    
    file(fileName)
    {
        return getResourceAsStream(fileName)
    }
    
    static testAll()
    {
        _test := TomlToClassTest()
        _test.should_convert_toml_primitives()
        _test.should_convert_to_non_toml_primitives()
        _test.should_convert_tables()
        _test.should_convert_tables_with_defaults()
        _test.should_use_defaults()
        _test.should_ignore_keys_not_in_class()
        _test.should_convert_table_array()
        _test.should_convert_fruit_table_array()
    }
    
    class ExtraPrimitives
    {
        
    }
    
    class FruitArray
    {
        
    }
    
    class TomlPrimitives1
    {
        
    }
    
    class TomlPrimitives2
    {
        
    }
    
    class TomlTableArrays
    {
        
    }
    
    class TomlTables1
    {
        
    }
    
    class TomlTables2
    {
        
    }
    
    class TomlTables3
    {
        
    }
}