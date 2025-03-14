# Used by "mix format"
locals_without_parens = [delegate_to: 1, delegate_to: 2, delegate_to: 3]

[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]
