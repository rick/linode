class Linode::Domain::Resource < Linode
  documentation_category 'dns'
  has_method :create, :delete, :update, :list
end