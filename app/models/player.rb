class Player < ActiveRecord::Base

  validates :name, uniqueness: true

  after_create :generate_columns_from_html


  private

  def generate_columns_from_html
    html = self.html
    self.update(
      height: height_query(html),
      weight: weight_query(html),
      name:   name_query(html)
    )
  end

  def height_query(html=self.html)
    Nokogiri::HTML(html).at_css('.bio .height dd').text

  end

  def weight_query(html=self.html)
    Nokogiri::HTML(html).at_css('.bio .weight dd').text
  end

  def name_query(html=self.html)
    doc = Nokogiri::HTML(html)
    doc.at_css('.player-info h1') ? doc.at_css('.player-info h1').attributes['data-name'].value : nil
  end


end
