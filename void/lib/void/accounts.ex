defmodule Void.Accounts do
  use Ash.Domain,
    otp_app: :void

  resources do
    resource Void.Accounts.Token
    resource Void.Accounts.User
  end
end
