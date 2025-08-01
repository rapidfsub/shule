defmodule EmilWeb.Form do
  use Mixin

  mixin AshPhoenix.Form, except: [:errors_for, :pop, :get_and_update, :fetch]
end
