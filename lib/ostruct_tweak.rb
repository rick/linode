# some of our Linode API data results include a 'type' data member.
# OpenStruct will have problems providing a .type method, so we special-case this.

OpenStruct.__send__(:define_method, :type) { @table[:type] }
