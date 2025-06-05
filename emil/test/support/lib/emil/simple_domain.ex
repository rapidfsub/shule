defmodule Emil.SimpleDomain do
  use Ash.Domain

  resources do
    resource Emil.SimpleDomain.Token
  end
end
