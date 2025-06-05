defmodule Void.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Void.Accounts.User, _opts, _context) do
    Application.fetch_env(:void, :token_signing_secret)
  end
end
