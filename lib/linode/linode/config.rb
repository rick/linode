class Linode::Linode::Config < Linode
  documentation_category 'linode'
  has_method :create, :delete, :update, :list
end