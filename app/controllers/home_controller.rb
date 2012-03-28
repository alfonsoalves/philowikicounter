['nokogiri', 'restclient'].each {|x| require x}
class HomeController < ApplicationController
  def findSteps(url)
		page = url
		page = page.chomp().gsub(/\s/,'_')
		urllist = []
		baseUrl = "http://en.wikipedia.org"
		url = baseUrl + "/wiki/"+page
		url = url.chomp()
		counter = 0
		nextLink = ""
		firstPara = ""
		status = ""
		urllist.append(url)
		while nextLink!='/wiki/Philosophy'
			if urllist.include?(nextLink)
				status = "loop"
				break 
			end
				
			p url
			doc = Nokogiri::HTML(RestClient.get(url))
			paragraphs = []

			
			paragraphs.push(doc.xpath('//div[@id="mw-content-text"]/p')[0],doc.xpath('//div[@id="mw-content-text"]/p')[1],doc.xpath('//div[@id="mw-content-text"]/p')[2])
			
			
			paragraphs.each do |para| 
				x = para.to_s()
				paraLength = x.scan(/display:none/).length
				if paraLength == 0
					firstPara = para.to_s
					break 
				end
			end
			
			
			loop_condition = firstPara
			while loop_condition.sub!(/\s\(.*?\)/,"") || loop_condition.sub!(/<i>.*<\/i>\)/,"")
				firstPara = firstPara.sub(/\s\(.*\)/,"")
				firstPara = firstPara.sub(/<i>.*<\/i>\)/,"")
			end
			
			
			firstPara = firstPara.match(/<a.*>.*<\/a>/)[0]
			
			firstLinkUrl = firstPara.split(/"/)
			firstLinkUrl.each do |link| 
									linkTest1 = link.scan('wiki')
									linkTest2 = link.scan('#')
									if ( linkTest1.length == 1 and linkTest2.length == 0)
										nextLink = link 
										break
									end
								end
			url = baseUrl + nextLink
			nextTitle = nextLink.sub(/\/wiki\//,"")
			urllist.append(nextTitle)
			counter = counter + 1
		end
		p counter
		if status == "loop"
			urllist.append("A loop was entered after " + counter.to_s + " steps")
		else
			urllist.append("Philosophy was found in " + counter.to_s + " steps")
		end
		return urllist
	  end
end
