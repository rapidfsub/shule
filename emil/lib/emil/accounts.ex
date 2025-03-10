defmodule Emil.Accounts do
  use Ash.Domain,
    otp_app: :emil

  resources do
    resource Emil.Accounts.Token
    resource Emil.Accounts.User
  end
end
