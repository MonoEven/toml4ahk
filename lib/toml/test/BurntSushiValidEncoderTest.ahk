#Include <toml\test\Test>

class BurntSushiValidEncoderTest
{
    array_empty()
    {
        this.runEncoder("array-empty")
    }
    
    arrays_hetergeneous()
    {
        this.runEncoder("arrays-hetergeneous")
    }

    arrays_nested()
    {
        this.runEncoder("arrays-nested")
    }

    datetime()
    {
        this.runEncoder("datetime")
    }

    empty()
    {
        this.runEncoder("empty")
    }

    example()
    {
        this.runEncoder("example")
    }

    float_()
    {
        this.runEncoder("float")
    }


    implicit_and_explicit_before()
    {
        this.runEncoder("implicit-and-explicit-before")
    }

    implicit_groups()
    {
        this.runEncoder("implicit-groups")
    }

    long_float()
    {
        this.runEncoder("long-float")
    }

    long_integer()
    {
        this.runEncoder("long-integer")
    }

    key_special_chars_modified()
    {
        this.runEncoder("key-special-chars-modified")
    }

    integer()
    {
        this.runEncoder("integer")
    }

    string_empty()
    {
        this.runEncoder("string-empty")
    }

    string_escapes_modified()
    {
        this.runEncoder("string-escapes-modified")
    }

    string_simple()
    {
        this.runEncoder("string-simple")
    }

    table_array_implicit()
    {
        this.runEncoder("table-array-implicit")
    }

    table_array_many()
    {
        this.runEncoder("table-array-many")
    }

    table_array_nest_modified()
    {
        ; Modified to remove stray spaces in the expected TOML
        this.runEncoder("table-array-nest-modified", TomlWriter.Builder().indentTablesBy(2).build())
    }

    table_array_one()
    {
        this.runEncoder("table-array-one")
    }
    
    convertStreamToString(_is)
    {
        return _is.read()
    }
    
    enrichJson(_jsonObject)
    {
        enriched := map()
        for entrykey, entryvalue in _jsonObject
            enriched[entrykey] := this.enrichJsonElement(entryvalue)
        return enriched
    }
    
    enrichJsonElement(_jsonElement)
    {
        if _jsonElement.isJsonObject()
        {
            _jsonObject := _jsonElement.getAsJsonObject()
            if (_jsonObject.has("type") && _jsonObject.has("value"))
                return this.enrichPrimitive(_jsonObject)
            return this.enrichJson(_jsonObject)
        }
        else if _jsonElement.type == "array"
        {
            tables := []
            for arrayElement in _jsonElement
                tables.push(this.enrichJsonElement(arrayElement))
            return tables
        }
        throw error ("AssertionError: received unexpected JsonElement: " type(jsonElement))
    }
    
    enrichPrimitive(_jsonObject)
    {
        _type := _jsonObject["type"].get()
        if _type == "array"
        {
            enriched := []
            for arrayElement in _jsonObject["value"].object
                enriched.push(this.enrichJsonElement(arrayElement))
            return enriched
        }
        else if _type == "integer"
            return integer(_jsonObject["value"].get())
        else if _type == "float"
            return float(_jsonObject["value"].get())
        else if _type == "string"
            return string(_jsonObject["value"].get())
        else if _type == "datetime"
            return Date(_jsonObject["value"].get())
        else if _type == "bool"
            return Boolean(_jsonObject["value"].get() == "true")
    }
    
    runEncoder(testName, _tomlWriter := TomlWriter())
    {
        inputTomlStream := getResourceAsStream("burntsushi/valid/" testName ".toml")
        expectedToml := strreplace(this.convertStreamToString(inputTomlStream), "`r`n", "`n")
        jsonInput := BurntSushiValidEncoderTest._Gson.fromJson(getResourceAsStream("burntsushi/valid/" testName ".json"))
        enriched := this.enrichJson(jsonInput)
        encoded := _tomlWriter.write(enriched)
        assertEquals(expectedToml, encoded)
    }
    
    static _Gson := Gson()
    
    static testAll()
    {
        _test := BurntSushiValidEncoderTest()
        _test.array_empty()
        _test.arrays_hetergeneous()
        _test.arrays_nested()
        _test.datetime()
        _test.empty()
        _test.example()
        _test.float_()
        _test.implicit_and_explicit_before()
        _test.implicit_groups()
        _test.long_float()
        _test.long_integer()
        _test.key_special_chars_modified()
        _test.integer()
        _test.string_empty()
        _test.string_escapes_modified()
        _test.string_simple()
        _test.table_array_implicit()
        _test.table_array_many()
        _test.table_array_nest_modified()
        _test.table_array_one()
    }
}
