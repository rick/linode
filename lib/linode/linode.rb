class Linode::Linode < Linode
  has_namespace :config, :disk, :ip, :job
  has_method :update, :create, :list, :shutdown, :boot, :delete, :reboot
end