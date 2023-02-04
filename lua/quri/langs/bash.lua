local lang = require("quri.langs.setup")

return lang("bash"):server("bashls"):formatter("shfmt")
