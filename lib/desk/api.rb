module Desk
	class API

		def self.authenticate
			
			@consumer ||= OAuth::Consumer.new(
	        "Gi8WIg43Sm8doEmBjquC",
	        "2ZwRhQl9H5MyGU7zNNQKo4gf6QO9Zi7LpdIj1G9R",
	        :site => "https://xl2db.desk.com",
	        :scheme => :header
			)

			@access_token ||= OAuth::AccessToken.from_hash(
			        @consumer,
			        :oauth_token => "tCoJQ1tZUjibMItM2PiI",
			        :oauth_token_secret => "iQG7Xq3IIfMIaita4im8QoMXDCewEtefZISVXJb9"
			)
		end

		def self.filters
			authenticate
			base_url = 'https://xl2db.desk.com'
			filters_url = '/api/v2/filters.json'
			filters_response = @access_token.get("#{base_url}#{filters_url}")
			parsed_filters = JSON.parse(filters_response.body)
			filters = parsed_filters['_embedded']['entries']
		end

		def self.cases_for_filter(filter)
			authenticate

			base_url = 'https://xl2db.desk.com'			
			filter_cases_url = filter['_links']['cases']['href']
			puts "filter_cases_url #{filter_cases_url}"

			case_response = @access_token.get("#{base_url}#{filter_cases_url}")
			parsed_cases = JSON.parse(case_response.body)
			cases = parsed_cases['_embedded']['entries']
			cases
		end

		def self.labels
			authenticate

			base_url = 'https://xl2db.desk.com'
			labels_url = '/api/v2/labels.json'
			labels_response = @access_token.get("#{base_url}#{labels_url}")
			parsed_labels = JSON.parse(labels_response.body)
			labels = parsed_labels['_embedded']['entries']
			labelnames = labels.collect {|l| l["name"]}
			labelnames

		end

		def self.addlabel labelname
			authenticate
			base_url = 'https://xl2db.desk.com'
			labels_url = '/api/v2/labels'
			label =	{
				  name: labelname,
				  description: "Label created through API",
				  types:  [
				    "case",
				    "macro"
				  ],
				  color: "blue"
						}.to_json
			labels_response = @consumer.request(:post,"#{base_url}#{labels_url}",@access_token, {},label,{ 'Content-Type' => 'application/json' })
			
			status = labels_response.to_hash["status"][0]

			if status == "201 created"
				true
			else
				false
			end
		end

		def self.attachlabel caseitem, labelname
			authenticate
			base_url = 'https://xl2db.desk.com'
			cases_url = '/api/v2/cases'
			label =	{
				  name: labelname,
				  description: "Label created through API",
				  types:  [
				    "case",
				    "macro"
				  ],
				  color: "blue"
						}.to_json
			labels_response = @consumer.request(:patch,"#{base_url}#{labels_url}",@access_token, {},label,{ 'Content-Type' => 'application/json' })
			
			status = labels_response.to_hash["status"][0]

			if status == "201 created"
				true
			else
				false
			end
		end
	end
end