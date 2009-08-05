class Linode::Domain < Linode
  has_method :update, :create, :list, :delete
  
  def resource
    @test ||= Linode::Domain::Resource.new(:api_key => api_key, :api_url => api_url)
  end
end