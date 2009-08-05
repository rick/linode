class Linode::Domain < Linode
  has_namespace :resource
  has_method :update, :create, :list, :delete
end