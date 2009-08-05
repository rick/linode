class Linode::Domain::Resource < Linode
  has_method :create, :delete, :update, :list
end