require 'open-uri'
require 'nokogiri'
require_relative 'lib/file_downloader'
require_relative 'lib/speech'
require_relative 'lib/act'

class PlayAnayzer
  IGNORE_SPEAKERS= %w(ALL)
  def initialize(url)
    @url ||= url
  end

  def lines_per_speaker
    @lines_per_speaker_in ||= lines_per_speaker_in(speech_elements)
  end

  def lines_per_speaker_in(elements)
    elements.each_with_object(Hash.new(0)) do |speech_element, results|
      speech = Speech.new(speech_element)
      unless IGNORE_SPEAKERS.include?(speech.speaker)
        results[speech.speaker] += speech.lines.count
      end
    end
  end

  def lines_by_speaker_per_act
    @lines_by_speaker_per_act ||= play.xpath("//ACT").map do |act_element|
      act = Act.new(act_element)
      {title: act.title, results: lines_per_speaker_in(act.speech_elements)}
    end
  end

  private
  def play
    @play ||= Nokogiri::XML(load_play)
  end

  def load_play
    FileDownloader.new(@url).full_text
  end

  def speech_elements
    play.xpath("//SPEECH")
  end
end

play_analyzer =  PlayAnayzer.new("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml")
puts play_analyzer.lines_per_speaker
puts play_analyzer.lines_by_speaker_per_act
