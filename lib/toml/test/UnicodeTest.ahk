#Include <toml\test\Test>

class UnicodeTest
{
    should_support_short_escape_form()
    {
        _toml := Toml().read("key = `"Jos\u00E9\nLocation\tSF`"")
        assertEquals("José`nLocation`tSF", _toml.getString("key"))
    }
    
    should_support_unicode_literal()
    {
        _toml := Toml().read("key = `"José LöcÄtion SF`"")
        assertEquals("José LöcÄtion SF", _toml.getString("key"))
    }
    
    static testAll()
    {
        _test := UnicodeTest()
        _test.should_support_short_escape_form()
        _test.should_support_unicode_literal()
    }
}