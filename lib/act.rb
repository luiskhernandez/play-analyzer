class Act
  def initialize(act_element)
    @act_element = act_element
  end

  def title
    grouped["TITLE"].first.text
  end

  def speech_elements
    act_element.xpath("SCENE//SPEECH")
  end

  attr_reader :act_element
  def grouped
    act_element.elements.group_by(&:name)
  end
end

