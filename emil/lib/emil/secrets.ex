defmodule Emil.Secrets do
  use AshAuthentication.Secret

  @impl AshAuthentication.Secret
  def secret_for([:authentication, :tokens, :signing_secret], Emil.Accounts.User, _opts, _context) do
    Application.fetch_env(:emil, :token_signing_secret)
  end
end
