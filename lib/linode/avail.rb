class Linode::Avail < Linode
  documentation_category 'utility'
  has_method :datacenters, :kernels, :linodeplans, :distributions, :stackscripts
end