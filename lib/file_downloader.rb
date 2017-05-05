class FileDownloader
  attr_reader :file_url

  def initialize(file_url)
    @file_url = file_url
  end

  def full_text
    payload.read
  end

   private
   def payload
    @payload ||= open(file_url)
  end
end
