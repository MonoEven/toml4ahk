#Include <toml\toml>

asList := Arrays.asList.bind("")
assertEquals := Java.Assert.assertEquals.bind("")
assertFalse := Java.Assert.assertFalse.bind("")
assertNotNull := Java.Assert.assertNotNull.bind("")
assertNull := Java.Assert.assertNull.bind("")
assertThat := Java.Assert.assertThat.bind("")
assertTrue := Java.Assert.assertTrue.bind("")
equalTo := Matchers.equalTo.bind("")
hasEntry := Matchers.hasEntry.bind("")
hasSize := Matchers.hasSize.bind("")
getResourceAsStream := Java.getResourceAsStream.bind("", "toml")
