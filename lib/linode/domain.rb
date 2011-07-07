class Linode::Domain < Linode
  documentation_category 'dns'
  has_namespace :resource
  has_method :update, :create, :list, :delete
end