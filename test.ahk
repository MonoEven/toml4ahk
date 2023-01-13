#Include <toml\toml>

toml1 := Toml().read("a=1")
msgbox toml1.getLong("a")