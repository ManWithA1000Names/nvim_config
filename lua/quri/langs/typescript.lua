local lang = require("quri.langs.setup")

return lang("typescript"):server("tsserver"):server("eslint"):formatter("prettier")
