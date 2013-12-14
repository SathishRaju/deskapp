module Desk
	class API

		def self.authenticate
			
			@consumer ||= OAuth::Consumer.new(
	        ENV["DESK_CONSUMER_KEY"],
	        ENV["DESK_CONSUMER_SECRET"],
	        :site => ENV["DESK_SITE"],
	        :scheme => :header
			)

			@access_token ||= OAuth::AccessToken.from_hash(
			        @consumer,
			        :oauth_token => ENV["DESK_TOKEN_KEY"],
			        :oauth_token_secret => ENV["DESK_TOKEN_SECRET"]
			)
		end

		def self.filters
			authenticate
			filters_response = @access_token.get(ENV["FILTERS_URL"])
			parsed_filters = JSON.parse(filters_response.body)
			filters = parsed_filters['_embedded']['entries']
		end

		def self.cases_for_filter(filter)
			authenticate

			filter_cases_url = filter['_links']['cases']['href']
			puts "filter_cases_url #{filter_cases_url}"

			case_response = @access_token.get( ENV["DESK_SITE"] + "#{filter_cases_url}")
			parsed_cases = JSON.parse(case_response.body)
			cases = parsed_cases['_embedded']['entries']
			cases
		end

		def self.labels
			authenticate
			labels_response = @access_token.get(ENV["LABELS_URL"] )
			parsed_labels = JSON.parse(labels_response.body)
			labels = parsed_labels['_embedded']['entries']
			labelnames = labels.collect {|l| l["name"]}
			labelnames

		end

		def self.addlabel labelname
			authenticate
			label =	{
				  name: labelname,
				  description: "Label created through API",
				  types:  [
				    "case",
				    "macro"
				  ],
				  color: "blue"
						}.to_json
			labels_response = @consumer.request(:post,ENV["LABELS_URL"],@access_token, {},label,{ 'Content-Type' => 'application/json' })
			
			status = labels_response.to_hash["status"][0]

			puts status

			if status == "201 Created"
				true
			else
				false
			end
		end

		def self.attachlabel caseitem, labelname
			authenticate
			case_url = ENV["DESK_SITE"] + caseitem["_links"]["self"]["href"]
			label =	{
				  name: labelname,
				  description: "Label created through API",
				  types:  [
				    "case",
				    "macro"
				  ],
				  color: "blue"
						}.to_json
			labels_response = @consumer.request(:patch, case_url,@access_token, {},label,{ 'Content-Type' => 'application/json' })
			
			status = labels_response.to_hash["status"][0]

			if status == "201 created"
				true
			else
				false
			end
		end
	end
end