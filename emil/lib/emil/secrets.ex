defmodule Emil.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Emil.Accounts.User, _opts) do
    Application.fetch_env(:emil, :token_signing_secret)
  end
end
