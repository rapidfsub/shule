defmodule Victor.Delegator do
  use Spark.Dsl,
    default_extensions: [
      extensions: [Victor.Delegator.Extension]
    ]
end
