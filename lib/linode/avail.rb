class Linode::Avail < Linode
  def datacenters(data ={})
    send_request('avail.datacenters', data)
  end
  
  def kernels(data ={})
    send_request('avail.kernels', data)
  end
  
  def linodeplans(data ={})
    send_request('avail.linodeplans', data)
  end
  
  def distributions(data ={})
    send_request('avail.distributions', data)
  end
end