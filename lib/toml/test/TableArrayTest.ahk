#Include <toml\test\Test>

class TableArrayTest
{
    should_parse_table_array()
    {
        _toml := Toml().read(this.file("products_table_array"))
        products := _toml.getTables("products")
        assertEquals(3, products.size())
        assertEquals("Hammer", products.get(0).getString("name"))
        assertEquals(738594937, products.get(0).getLong("sku"))
        assertNull(products.get(1).getString("name"))
        assertNull(products.get(1).getLong("sku"))
        assertEquals("Nail", products.get(2).getString("name"))
        assertEquals(284758393, products.get(2).getLong("sku"))
        assertEquals("gray", products.get(2).getString("color"))
    }

    should_parse_table_array_out_of_order()
    {
        _toml := Toml().read(this.file("should_parse_table_array_out_of_order"))
        tables := _toml.getTables("product")
        employees := _toml.getTables("employee")
        assertThat(tables, hasSize(2))
        assertThat(tables.get(0).getDouble("price"), equalTo(9.99))
        assertThat(tables.get(1).getString("type"), equalTo("ZX80"))
        assertThat(employees, hasSize(1))
        assertThat(employees.get(0).getString("name"), equalTo("Marinus van der Lubbe"))
    }

    should_parse_nested_table_arrays()
    {
        _toml := Toml().read(this.file("fruit_table_array"))
        fruits := _toml.getTables("fruit")
        assertEquals(2, fruits.size())
        apple := fruits.get(0)
        assertEquals("apple", apple.getString("name"))
        assertEquals("red", apple.getTable("physical").getString("color"))
        assertEquals("round", apple.getTable("physical").getString("shape"))
        assertEquals(2, apple.getTables("variety").size())
        banana := fruits.get(1)
        assertEquals("banana", banana.getString("name"))
        assertEquals(1, banana.getTables("variety").size())
        assertEquals("plantain", banana.getTables("variety").get(0).getString("name"))
    }

    should_create_array_ancestors_as_tables()
    {
        _toml := Toml().read("[[a.b.c]]`n id=3")
        assertEquals(3, _toml.getTable("a").getTable("b").getTables("c").get(0).getLong("id"))
    }

    should_navigate_array_with_compound_key()
    {
        _toml := Toml().read(this.file("fruit_table_array"))
        appleVarieties := _toml.getTables("fruit[0].variety")
        appleVariety := _toml.getTable("fruit[0].variety[1]")
        bananaVariety := _toml.getString("fruit[1].variety[0].name")
        assertEquals(2, appleVarieties.size())
        assertEquals("red delicious", appleVarieties.get(0).getString("name"))
        assertEquals("granny smith", appleVariety.getString("name"))
        assertEquals("plantain", bananaVariety)
    }

    should_return_null_for_missing_table_array()
    {
        _toml := Toml().read("[a]")
        assertNull(_toml.getTables("b"))
    }

    should_return_null_for_missing_table_array_with_index()
    {
        _toml := Toml()
        assertNull(_toml.getTable("a[0]"))
        assertNull(_toml.getString("a[0].c"))
    }

    should_return_null_for_index_out_of_bounds()
    {
        _toml := Toml().read("[[a]]`n  c = 1")
        assertNull(_toml.getTable("a[1]"))
    }

    should_handle_repeated_tables()
    {
        Toml().read("[[a]]`n [a.b]`n [[a]]`n [a.b]")
    }
    
    should_fail_on_empty_table_array_name()
    {
        try
            Toml().read("[[]]")
    }
    
    file(filename)
    {
        return getResourceAsStream(filename ".toml")
    }
    
    static testAll()
    {
        _test := TableArrayTest()
        _test.should_parse_table_array()
        _test.should_parse_table_array_out_of_order()
        _test.should_parse_nested_table_arrays()
        _test.should_create_array_ancestors_as_tables()
        _test.should_navigate_array_with_compound_key()
        _test.should_return_null_for_missing_table_array()
        _test.should_return_null_for_missing_table_array_with_index()
        _test.should_return_null_for_index_out_of_bounds()
        _test.should_handle_repeated_tables()
        _test.should_fail_on_empty_table_array_name()
    }
}
