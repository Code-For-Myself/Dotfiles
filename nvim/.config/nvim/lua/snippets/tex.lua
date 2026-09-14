local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

ls.add_snippets("tex", {
  s(
    { trig = "beg", snippetType = "autosnippet" },
    fmta(
      [[
\begin{<>}
	<>
\end{<>}
]],
      {
        i(1, "environment"),
        i(0),
        rep(1), -- mirrors whatever you type in the environment name
      }
    )
  ),
  s({ trig = "dv", snippetType = "autosnippet" }, fmta([[\dv{<>}{<>}]], { i(1), i(2) })),

  -- Partial derivative: pdv{}{}
  s({ trig = "pdv", snippetType = "autosnippet" }, fmta([[\pdv{<>}{<>}]], { i(1), i(2) })),

  -- Second-order partial derivative: pdv[2]{}{}
  s({ trig = "pdv2", snippetType = "autosnippet" }, fmta([[\pdv[2]{<>}{<>}]], { i(1), i(2) })),

  -- Vector (bold, physics package style)
  s({ trig = "vec", snippetType = "autosnippet" }, fmta([[\vb{<>}]], { i(1) })),

  -- Bra
  s({ trig = "bra" }, fmta([[\bra{<>}]], { i(1) })),

  -- Ket
  s({ trig = "ket", snippetType = "autosnippet" }, fmta([[\ket{<>}]], { i(1) })),

  -- Braket
  s({ trig = "braket", snippetType = "autosnippet" }, fmta([[\braket{<>}{<>}]], { i(1), i(2) })),

  -- Expectation value
  s({ trig = "expval", snippetType = "autosnippet" }, fmta([[\expval{<>}]], { i(1) })),

  -- Commutator
  s({ trig = "comm", snippetType = "autosnippet" }, fmta([[\comm{<>}{<>}]], { i(1), i(2) })),

  -- Gradient / divergence / curl (physics package)
  s({ trig = "grad", snippetType = "autosnippet" }, fmta([[\grad{<>}]], { i(1) })),
  s({ trig = "div", snippetType = "autosnippet" }, fmta([[\div{<>}]], { i(1) })),
  s({ trig = "curl", snippetType = "autosnippet" }, fmta([[\curl{<>}]], { i(1) })),
  s({ trig = "mrm", snippetType = "autosnippet" }, fmta([[<>_{\text{<>}}]], { i(1), i(2) })),
})
