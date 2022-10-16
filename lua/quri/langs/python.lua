local lang = require("quri.langs.setup")

return lang("python"):server("pyright"):formatter("black"):linter("flake8")
