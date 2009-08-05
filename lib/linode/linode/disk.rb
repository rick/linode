class Linode::Linode::Disk < Linode
  has_method :update, :create, :list, :createfromdistribution, :duplicate, :delete, :resize
end