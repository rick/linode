class Linode::Nodebalancer::Config < Linode
  documentation_category 'nodebalancer'
  has_method :create, :delete, :update, :list
end