class Linode::Linode::Ip < Linode
  documentation_category 'linode'
  has_method :list, :addprivate, :addpublic, :setrdns, :swap
end