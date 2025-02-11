defmodule Victor.Defrelay do
  use Spark.Dsl,
    default_extensions: [
      extensions: [Victor.Defrelay.DefaultDsl]
    ]
end
