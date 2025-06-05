defmodule Emil.FakeDateTime do
  def utc_now() do
    ~U[2000-01-02 00:00:00Z]
  end

  def seoul_now() do
    utc_now() |> DateTime.shift_zone!("Asia/Seoul")
  end
end
