class Linode::Linode::Disk < Linode
  documentation_category 'linode'
  has_method :update, :create, :list, :createfromdistribution, :createfromimage, :createfromstackscript, :duplicate, :delete, :resize, :imagize
end
