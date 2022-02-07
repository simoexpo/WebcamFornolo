defmodule WebcamFornolo.Util.SshKeyUtil do
  if Mix.env == :prod do

    @ssh_key Application.compile_env!(:webcam_fornolo, :ssh_key)
    @ssh_dir "~/.ssh/"
    @ssh_file "id_rsa"

    @spec set_up_ssh_key() :: :error | :ok
    def set_up_ssh_key() do
      with :ok <- :filelib.ensure_dir(@ssh_dir),
          :ok <- :file.write_file("#{@ssh_dir}#{@ssh_file}", @ssh_key) do
        :ok
      else
        _ -> :error
      end
    end

  else

    @spec set_up_ssh_key() :: :error | :ok
    def set_up_ssh_key(), do: :ok

  end
end
