class Linode::Avail < Linode
  has_method :datacenters, :kernels, :linodeplans, :distributions
end