class Linode::Linode < Linode
  documentation_category "linode"
  has_namespace :config, :disk, :ip, :job
  has_method :update, :create, :list, :shutdown, :boot, :delete, :reboot, :clone
end
