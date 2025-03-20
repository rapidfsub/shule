defmodule EmilWeb.Form do
  use Mixin

  mixin AshPhoenix.Form, except: [:errors_for]
end
