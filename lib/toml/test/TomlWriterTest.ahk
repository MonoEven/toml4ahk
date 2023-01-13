#Include <toml\test\Test>

class TomlWriterTest
{
    should_write_primitive_types()
    {
        o := TomlWriterTest.TestClass()
        output := TomlWriter().write(o)
        expected := "aBoolean = false`n" .
        "aDouble = -5.4299999999999997`n" .
        "aFloat = 1.23`n" .
        "aString = `"hello`"`n" .
        "anInt = 4`n"
        assertEquals(expected, output)
    }
    
    should_write_nested_map_with_default_indentation_policy()
    {
        output := TomlWriter().write(this.buildNestedClass())
        expected := "aBoolean = true`n`n" .
                            "[Child]`n" .
                            "anInt = 2`n`n" .
                            "[Child.SubChild]`n" .
                            "anInt = 4`n`n" .
                            "[aMap]`n" .
                            "bar = `"value1`"`n" .
                            "`"baz.x`" = true`n" .
                            "foo = 1`n"
        assertEquals(expected, output)
    }
    
    should_follow_indentation_policy_of_indented_values()
    {
        output := TomlWriter.Builder().indentValuesBy(2)
                                                        .build()
                                                        .write(this.buildNestedClass())
        expected := "aBoolean = true`n`n" .
                            "[Child]`n" .
                            "  anInt = 2`n`n" .
                            "[Child.SubChild]`n" .
                            "  anInt = 4`n`n" .
                            "[aMap]`n" .
                            "  bar = `"value1`"`n" .
                            "  `"baz.x`" = true`n" .
                            "  foo = 1`n"
        assertEquals(expected, output)
    }
    
    should_follow_indentation_policy_of_indented_tables()
    {
        output := TomlWriter.Builder().indentTablesBy(2)
                                                        .build()
                                                        .write(this.buildNestedClass())
        expected := "aBoolean = true`n`n" .
                            "[Child]`n" .
                            "anInt = 2`n`n" .
                            "  [Child.SubChild]`n" .
                            "  anInt = 4`n`n" .
                            "[aMap]`n" .
                            "bar = `"value1`"`n" .
                            "`"baz.x`" = true`n" .
                            "foo = 1`n"
        assertEquals(expected, output)
    }
    
    should_follow_indentation_policy_of_indented_tables_and_values()
    {
        output := TomlWriter.Builder().indentValuesBy(2)
                                                        .indentTablesBy(2)
                                                        .build()
                                                        .write(this.buildNestedClass())
        expected := "aBoolean = true`n`n" .
                            "[Child]`n" .
                            "  anInt = 2`n`n" .
                            "  [Child.SubChild]`n" .
                            "    anInt = 4`n`n" .
                            "[aMap]`n" .
                            "  bar = `"value1`"`n" .
                            "  `"baz.x`" = true`n" .
                            "  foo = 1`n"
        assertEquals(expected, output)
    }
    
    should_write_array_of_tables_from_object()
    {
        config := TomlWriterTest.Config()
        output := TomlWriter().write(config)
        expected := "[[table]]`n" .
                            "anInt = 1`n`n" .
                            "[[table]]`n" .
                            "anInt = 2`n" .
                            "[[table2]]`n" .
                            "anInt = 3`n`n" .
                            "[[table2]]`n" .
                            "anInt = 4`n"
        assertEquals(expected, output)
    }
    
    should_write_array_of_tables_from_map()
    {
        maps := ArrayList()
        item1 := HashMap()
        item1.put("anInt", 1)
        item2 := HashMap()
        item2.put("anInt", 2)
        maps.add(item1)
        maps.add(item2)
        input := HashMap()
        input.put("maps", maps)
        output := TomlWriter().write(input)
        expected := "[[maps]]`n" .
                            "anInt = 1`n`n" .
                            "[[maps]]`n" .
                            "anInt = 2`n"
        assertEquals(expected, output)
    }
    
    should_write_array_of_array()
    {
        arrayTest := TomlWriterTest.ArrayTest()
        output := TomlWriter.Builder().padArrayDelimitersBy(1)
                                                        .build()
                                                        .write(arrayTest)
        expected := "array = [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]`n"
        assertEquals(expected, output)
    }
    
    should_write_list()
    {
        o := TomlWriterTest.ListTest()
        o.aList.add(1)
        o.aList.add(2)
        assertEquals("aList = [ 1, 2 ]`n", TomlWriter.Builder().padArrayDelimitersBy(1).build().write(o))
    }
    
    should_handle_zero_length_arrays_and_lists()
    {
        testObject := {aList: [], anArray: []}
        assertEquals("aList = []`nanArray = []`n", TomlWriter().write(testObject))
    }
    
    should_reject_heterogeneous_arrays()
    {
        try
        {
            badArray := {array: [1, "oops"]}
            this.expectedException.expect(IllegalStateException)
            this.expectedException.expectMessage(Matchers.startsWith("array"))
            TomlWriter().write(badArray)
        }
        catch as err
            this.expectedException.errorCheck(err)
    }
    
    should_reject_nested_heterogeneous_array()
    {
        try
        {
            badArray := {aMap: HashMap()}
            badArray.aMap.put("array", [1, "oops"])
            this.expectedException.expect(IllegalStateException)
            this.expectedException.expectMessage("aMap.array")
            TomlWriter().write(badArray)
        }
        catch as err
            this.expectedException.errorCheck(err)
    }
    
    should_elide_empty_intermediate_tables()
    {
        o := {b: {c: {anInt: 1}}}
        assertEquals("[b]`n`n[b.c]`nanInt = 1`n", TomlWriter().write(o))
    }
    
    should_write_map()
    {
        assertEquals("a = 1`n", TomlWriter().write(Toml().read("a = 1").toMap()))
    }
    
    should_write_classes_with_inheritance()
    {
        impl := TomlWriterTest.Impl()
        expected := "aBoolean = true`nanInt = 2`n"
        assertEquals(expected, TomlWriter().write(impl))
    }
    
    should_write_strings_to_toml_utf8()
    {
        utf8Test := TomlWriterTest.Utf8Test()
        utf8Test.input := " é foo \u20AC `b `t `n `f `r `" \ "
        assertEquals("input = `" é foo € \b \t \n \f \r \`" \\ `"`n", TomlWriter().write(utf8Test))
        utf8Test.input := " \uD801\uDC28 \uD840\uDC0B "
        assertEquals("input = `" 𐐨 𠀋 `"`n", TomlWriter().write(utf8Test))
    }
    
    should_quote_keys()
    {
        aMap := HashMap()
        aMap.put("a.b", 1)
        aMap.put("5€", 2)
        aMap.put("c$d", 3)
        aMap.put("e/f", 4)
        expected := "`"5€`" = 2`n" .
                            "`"a.b`" = 1`n" .
                            "`"c$d`" = 3`n" .
                            "`"e/f`" = 4`n"
        assertEquals(expected, TomlWriter().write(aMap))
    }
    
    should_quote_keys_in_object()
    {
        o := {%"a$"%: {%"µµ"%: 5.3}, %"€5"%: 5,  %"français"%: "langue"}
        assertEquals("`"français`" = `"langue`"`n`"€5`" = 5`n`n[`"a$`"]`n`"µµ`" = 5.2999999999999998`n", TomlWriter().write(o))
    }
    
    should_handle_urls()
    {
        from := {url: "https://github.com", uri: "https://bitbucket.com"}
        expected := "uri = `"https://bitbucket.com`"`n" .
                            "url = `"https://github.com`"`n"
        assertEquals(expected, TomlWriter().write(from))
    }
    
    should_handle_char()
    {
        o := {c: 'a'}
        assertEquals("c = `"a`"`n", TomlWriter().write(o))
    }
    
    should_write_to_writer()
    {
        output := StringWriter()
        TomlWriter().write(TomlWriterTest.SimpleTestClass(), output)
        assertEquals("a = 1`n", output.toString())
    }
    
    should_write_to_file()
    {
        output := "tmp_test.toml"
        TomlWriter().write(TomlWriterTest.SimpleTestClass(), output)
        assertEquals("a = 1`n", fileread(output))
    }
    
    should_refuse_to_write_string_fragment()
    {
        try
            TomlWriter().write("fragment")
    }

    should_refuse_to_write_boolean_fragment()
    {
        try
            TomlWriter().write(Boolean(true))
    }

    should_refuse_to_write_number_fragment()
    {
        try
            TomlWriter().write(42)
    }

    should_refuse_to_write_date_fragment()
    {
        try
            TomlWriter().write(Date())
    }

    should_refuse_to_write_array_fragment()
    {
        try
        {
            a := [Java.Null(), Java.Null()]
            TomlWriter().write(a)
        }
    }

    should_refuse_to_write_table_array_fragment()
    {
        try
        {
            a := [TomlWriterTest.SimpleTestClass(), TomlWriterTest.SimpleTestClass()]
            TomlWriter().write(a)
        }
    }

    should_not_write_list()
    {
        try
            TomlWriter().write(Arrays.asList("a"))
    }
    
    expectedException := ExpectedException.none()
    
    testDirectory := TomlWriterTest.TemporaryFolder()
    
    buildNestedClass()
    {
        TomlWriterTest.Parent.aMap.foo := 1
        TomlWriterTest.Parent.aMap.bar := "value1"
        TomlWriterTest.Parent.aMap.%"baz.x"% := Boolean(true)
        TomlWriterTest.Parent.Child.anInt := 2
        TomlWriterTest.Parent.Child.SubChild.anInt := 4
        TomlWriterTest.Parent.aBoolean := Boolean(true)
        return TomlWriterTest.Parent
    }
    
    static testAll()
    {
        _test := TomlWriterTest()
        _test.should_write_primitive_types()
        _test.should_write_nested_map_with_default_indentation_policy()
        _test.should_follow_indentation_policy_of_indented_values()
        _test.should_follow_indentation_policy_of_indented_tables()
        _test.should_follow_indentation_policy_of_indented_tables_and_values()
        _test.should_write_array_of_tables_from_object()
        _test.should_write_array_of_tables_from_map()
        _test.should_write_array_of_array()
        _test.should_write_list()
        _test.should_handle_zero_length_arrays_and_lists()
        _test.should_reject_heterogeneous_arrays()
        _test.should_reject_nested_heterogeneous_array()
        _test.should_elide_empty_intermediate_tables()
        _test.should_write_map()
        _test.should_write_classes_with_inheritance()
        _test.should_write_strings_to_toml_utf8()
        _test.should_quote_keys()
        _test.should_quote_keys_in_object()
        _test.should_handle_urls()
        _test.should_handle_char()
        _test.should_write_to_file()
        _test.should_refuse_to_write_string_fragment()
        _test.should_refuse_to_write_boolean_fragment()
        _test.should_refuse_to_write_number_fragment()
        _test.should_refuse_to_write_date_fragment()
        _test.should_refuse_to_write_array_fragment()
        _test.should_refuse_to_write_table_array_fragment()
        _test.should_not_write_list()
    }
    
    class ArrayTest
    {
        array := [[1, 2, 3], [4, 5, 6]]
    }
    
    class Base
    {
        anInt := 2
    }
    
    class Config
    {
        table := [TomlWriterTest.Config.Table(1), TomlWriterTest.Config.Table(2)]
        
        table2 := Arrays.asList(TomlWriterTest.Config.Table(3), TomlWriterTest.Config.Table(4))
        
        class Table
        {
            __new(anInt)
            {
                this.anInt := anInt
            }
        }
    }
    
    class Impl extends TomlWriterTest.Base
    {
        aBoolean := Boolean(true)
    }
    
    class ListTest
    {
        aList := ArrayList()
    }
    
    class Parent
    {
        class aMap
        {
            
        }
        
        class Child
        {
            class SubChild
            {
                
            }
        }
    }
    
    class SimpleTestClass
    {
        a := 1
    }
    
    class TestClass
    {
        aString := "hello"
        
        anInt := 4
        
        aFloat := 1.23
        
        aDouble := -5.43
        
        aBoolean := Boolean(false)
        
        static aFinalInt := 1
    }
    
    class TemporaryFolder
    {
        
    }
    
    class Utf8Test
    {
        
    }
}