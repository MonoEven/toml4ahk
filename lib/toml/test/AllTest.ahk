#Include <toml\test\ArrayTest>
#Include <toml\test\BareKeysTest>
#Include <toml\test\BooleanTest>
#Include <toml\test\BurntSushiInvalidTest>
#Include <toml\test\BurntSushiValidEncoderTest>
#Include <toml\test\BurntSushiValidTest>
#Include <toml\test\ContainsTest>
#Include <toml\test\DefaultValueTest>
#Include <toml\test\ErrorMessagesTest>
#Include <toml\test\InlineTableTest>
#Include <toml\test\IterationTest>
#Include <toml\test\NumberTest>
#Include <toml\test\QuotedKeysTest>
#Include <toml\test\RealWorldTest>
#Include <toml\test\StringTest>
#Include <toml\test\TableArrayTest>
#Include <toml\test\TableTest>
#Include <toml\test\Toml_ToMapTest>
#Include <toml\test\TomlDefaultsTest>
#Include <toml\test\TomlReadTest>
#Include <toml\test\TomlTest>
#Include <toml\test\TomlToClassTest>
#Include <toml\test\TomlWriterTest>
#Include <toml\test\UnicodeTest>

testAll()
{
    time := A_TickCount
    ArrayTest.testAll()
    BareKeysTest.testAll()
    BooleanTest.testAll()
    BurntSushiInvalidTest.testAll()
    BurntSushiValidEncoderTest.testAll()
    BurntSushiValidTest.testAll()
    ContainsTest.testAll()
    DefaultValueTest.testAll()
    ErrorMessagesTest.testAll()
    InlineTableTest.testAll()
    IterationTest.testAll()
    NumberTest.testAll()
    QuotedKeysTest.testAll()
    RealWorldTest.testAll()
    StringTest.testAll()
    TableArrayTest.testAll()
    TableTest.testAll()
    Toml_ToMapTest.testAll()
    TomlDefaultsTest.testAll()
    TomlReadTest.testAll()
    TomlTest.testAll()
    TomlToClassTest.testAll()
    TomlWriterTest.testAll()
    UnicodeTest.testAll()
    msgbox "pass all test used: " A_TickCount - time "ms"
}
