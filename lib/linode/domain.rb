class Linode::Domain < Linode
  has_method :update, :create, :list, :delete
end