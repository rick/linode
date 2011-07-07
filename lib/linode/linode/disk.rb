class Linode::Linode::Disk < Linode
  documentation_category 'linode'
  has_method :update, :create, :list, :createfromdistribution, :createfromstackscript, :duplicate, :delete, :resize
end