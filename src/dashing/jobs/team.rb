require 'net/http'
require 'json'
require 'pp' 

SCHEDULER.every '5s', :first_in => 0 do |job|

  uriSpecs = URI('https://api.launchpad.net/devel/solum/all_specifications')
  uriBugs = URI('https://api.launchpad.net/devel/solum/all_specifications')
  # http = Net::HTTP.new(uri.host, uri.port, :use_ssl => uri.scheme == 'https')

  # request = Net::HTTP::Get.new uri
  # response = http.request request

  # bp_assignees = JSON.parse( response.body )["entries"].map { |s|
  #   assignee = ( s["milestone_link"] || '/unassigned' )
  #   {
  #       :isComplete => s["is_complete"], 
  #       :isStarted =>  s["is_started"], 
  #       :assignee => assignee[assignee.rindex('/')+1 .. -1]
  #   }
  # }.find_all{ |bp| bp[:isStarted] && !bp[:isComplete] }.group_by{ |bp| bp[:assignee] }.entries

  # puts bp_assignees


end

