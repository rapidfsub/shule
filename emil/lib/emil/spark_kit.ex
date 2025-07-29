defmodule Emil.SparkKit do
  use Mixin

  mixin Ash.Resource.Builder
  mixin Spark.Dsl.Transformer
end
