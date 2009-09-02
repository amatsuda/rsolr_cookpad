#
# Connection for standard HTTP Solr server
#
class RSolr::Connection::HTTP
  
  attr_reader :opts
  
  # opts can have:
  #   :url => 'http://localhost:8080/solr'
  def initialize(opts={}, &block)
    opts[:url] ||= 'http://127.0.0.1:8983/solr'
    @opts = opts
  end
  
  def connection
    @connection ||= RSolr::HTTPClient.connect(@opts)
  end
  
  # send a request to the connection
  # request '/update', :wt=>:xml, '</commit>'
  def request(path, params={}, data=nil)
    data = data.to_xml if data.respond_to?(:to_xml)
    if data
      http_context = connection.post(path, data, params, post_headers)
    else
      http_context = connection.get(path, params)
    end
    raise RSolr::RequestError.new(http_context[:body]) unless http_context[:status_code] == 200
    http_context
  end
  
  protected
  
  # The standard POST headers
  def post_headers
    {"Content-Type" => 'text/xml; charset=utf-8'}
  end
  
end