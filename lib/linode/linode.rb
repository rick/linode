class Linode::Linode < Linode
  has_method :update, :create, :list, :shutdown, :boot, :delete, :reboot
end