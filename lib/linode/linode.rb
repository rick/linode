class Linode::Linode < Linode
  has_namespace :config, :disk
  has_method :update, :create, :list, :shutdown, :boot, :delete, :reboot
end