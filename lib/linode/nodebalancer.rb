class Linode::Nodebalancer < Linode
  documentation_category 'nodebalancer'
  has_namespace :config, :node
  has_method :update, :create, :list, :delete
end