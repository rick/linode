class Linode::Test < Linode
  def echo(data ={})
    send_request('test.echo', data)
  end
end