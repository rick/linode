class Linode::Linode::Disk < Linode
  has_method :update, :create, :list, :createfromdistribution, :createfromstackscript, :duplicate, :delete, :resize
end