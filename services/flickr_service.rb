# frozen_string_literal: true

class FlickrService
  def get_pictures(userid)
    # response = HTTP.get("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=#{ENV['FLICKR_API_KEY']}&user_id=#{userid}&format=rest")
    # parsed_response = JSON.parse(response)
    formatted_user_id = userid.index('@').nil? ? get_flickr_id(userid) : userid.sub('@', '%40')
    response = HTTP.get("https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=#{ENV['FLICKR_API_KEY']}&user_id=#{formatted_user_id}&format=json&nojsoncallback=1")

    if response.parse['stat'] == 'fail'
      response.parse['message']
    else
      parsed_response = JSON.parse(response.to_s)
      parsed_response['photos']['photo']
    end
  end

  def get_flickr_id(userid)
    userid.gsub!(' ', '+') if userid.split.length > 1
    response = HTTP.get("https://www.flickr.com/services/rest/?method=flickr.people.findByUsername&api_key=#{ENV['FLICKR_API_KEY']}&username=#{userid}&format=json&nojsoncallback=1").to_s
    parsed_response = JSON.parse(response)
    parsed_response['user']['id'].sub('@', '%40')
  end
end
