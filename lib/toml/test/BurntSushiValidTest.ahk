#Include <toml\test\Test>

class BurntSushiValidTest
{
    array_empty()
    {
        this.run("array-empty")
    }
    
    array_nospaces()
    {
        this.run("array-nospaces")
    }
    
    arrays_hetergeneous()
    {
        this.run("arrays-hetergeneous")
    }

    arrays_nested()
    {
        this.run("arrays-nested")
    }

    arrays()
    {
        this.run("arrays")
    }

    bool()
    {
        this.run("bool")
    }

    comments_everywhere()
    {
        this.run("comments-everywhere")
    }

    datetime()
    {
        this.run("datetime")
    }

    empty()
    {
        this.run("empty")
    }

    example()
    {
        this.run("example")
    }

    float_()
    {
        this.run("float")
    }

    implicit_and_explicit_after()
    {
        this.run("implicit-and-explicit-after")
    }

    implicit_and_explicit_before()
    {
        this.run("implicit-and-explicit-before")
    }

    implicit_groups()
    {
        this.run("implicit-groups")
    }

    integer()
    {
        this.run("integer")
    }

    key_equals_nospace()
    {
        this.run("key-equals-nospace")
    }
    
    key_space()
    {
        try
            this.run("key-space")
    }

    key_space_modified()
    {
        this.run("key-space-modified")
    }
    
    key_special_chars()
    {
        try
            this.run("key-special-chars")
    }

    key_special_chars_modified()
    {
        this.run("key-special-chars-modified")
    }
    
    keys_with_dots()
    {
        try
            this.run("keys-with-dots")
    }

    keys_with_dots_modified()
    {
        this.run("keys-with-dots-modified")
    }

    long_float()
    {
        this.run("long-float")
    }

    long_integer()
    {
        this.run("long-integer")
    }
    
    multiline_string()
    {
        try
            this.run("multiline-string")
    }

    multiline_string_modified()
    {
        this.run("multiline-string-modified")
    }

    raw_multiline_string()
    {
        this.run("raw-multiline-string")
    }

    raw_string()
    {
        this.run("raw-string")
    }

    string_empty()
    {
        this.run("string-empty")
    }
    
    string_escapes()
    {
        try
            this.run("string-escapes")
    }

    string_escapes_modified()
    {
        this.run("string-escapes-modified")
    }

    string_simple()
    {
        this.run("string-simple")
    }

    string_with_pound()
    {
        this.run("string-with-pound")
    }

    table_array_implicit()
    {
        this.run("table-array-implicit")
    }

    table_array_many()
    {
        this.run("table-array-many")
    }

    table_array_nest()
    {
        this.run("table-array-nest")
    }

    table_array_one()
    {
        this.run("table-array-one")
    }

    table_empty()
    {
        this.run("table-empty")
    }

    table_sub_empty()
    {
        this.run("table-sub-empty")
    }
    
    table_whitespace()
    {
        try
            this.run("table-whitespace")
    }
    
    table_with_pound()
    {
        try
            this.run("table-with-pound")
    }

    unicode_escape()
    {
        this.run("unicode-escape")
    }

    unicode_literal()
    {
        this.run("unicode-literal")
    }
    
    convertStreamToString(_is)
    {
        return _is.read()
    }
    
    run(testName)
    {
        inputTomlStream := getResourceAsStream("burntsushi/valid/" testName ".toml")
        inputToml := strreplace(this.convertStreamToString(inputTomlStream), "`r`n", "`n")
        expectedJson := BurntSushiValidTest._Gson.fromJson(getResourceAsStream("burntsushi/valid/" testName ".json"))
        _toml := Toml().read(inputToml)
        actual := BurntSushiValidTest.TEST_GSON.toJsonTree(_toml)
        assertEquals(expectedJson, actual)
    }
    
    static _Gson := Gson()
    
    static TEST_GSON := GsonBuilder().registerTypeAdapter(Boolean, this.serialize(Boolean))
                                                           .registerTypeAdapter(string, this.serialize(string))
                                                           .registerTypeAdapter(integer, this.serialize(integer))
                                                           .registerTypeAdapter(float, this.serialize(float))
                                                           .registerTypeAdapter(Date, this.serialize(Date))
                                                           .registerTypeHierarchyAdapter(ArrayList, this.serialize(ArrayList))
                                                           .create()
    
    static serialize(_class)
    {
        typemap := map(Boolean, "bool", string, "string", integer, "integer", float, "float", Date, "datetime", ArrayList, "array")
        func1 := _func1(_type, value) => map("type", _type, "value", value)
        func2 := _func2(_type, value) => map("type", _type, "value", value.tostring())
        func3 := _func3(_type, value) => map("type", _type, "value", value.arr)
        if _class == Boolean || _class == Date
            return func2.bind(typemap[_class])
        if _class == ArrayList
            return func3.bind(typemap[_class])
        else if typemap.has(_class)
            return func1.bind(typemap[_class])
    }
    
    static testAll()
    {
        _test := BurntSushiValidTest()
        _test.array_empty()
        _test.array_nospaces()
        _test.arrays_hetergeneous()
        _test.arrays_nested()
        _test.arrays()
        _test.bool()
        _test.comments_everywhere()
        _test.datetime()
        _test.empty()
        _test.example()
        _test.float_()
        _test.implicit_and_explicit_after()
        _test.implicit_and_explicit_before()
        _test.implicit_groups()
        _test.integer()
        _test.key_equals_nospace()
        _test.key_space()
        _test.key_space_modified()
        _test.key_special_chars()
        _test.key_special_chars_modified()
        _test.keys_with_dots()
        _test.keys_with_dots_modified()
        _test.long_float()
        _test.long_integer()
        _test.multiline_string()
        _test.multiline_string_modified()
        _test.raw_multiline_string()
        _test.raw_string()
        _test.string_empty()
        _test.string_escapes()
        _test.string_escapes_modified()
        _test.string_simple()
        _test.string_with_pound()
        _test.table_array_implicit()
        _test.table_array_many()
        _test.table_array_nest()
        _test.table_array_one()
        _test.table_empty()
        _test.table_sub_empty()
        _test.table_whitespace()
        _test.table_with_pound()
        _test.unicode_escape()
        _test.unicode_literal()
    }
}
