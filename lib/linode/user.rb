class Linode::User < Linode
  def getapikey(data ={})
    send_request('user.getapikey', data)
  end
end