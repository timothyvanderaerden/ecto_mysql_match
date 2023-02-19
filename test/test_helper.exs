Code.require_file("support/test_repo.exs", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: [:integration])
