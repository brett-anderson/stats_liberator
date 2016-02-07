class Player < ActiveRecord::Base

  validates :name, uniqueness: true

  after_create :generate_columns_from_html


  def generate_columns_from_html
    html = self.html
    self.update(
    height: height_query(html),
    weight: weight_query(html),
    name:   name_query(html)
    )
  end

  private

  def height_query(html=self.html)
    dd = Nokogiri::HTML(html).at_css('.bio .height dd')
    dd.text if dd

  end

  def weight_query(html=self.html)
    dd = Nokogiri::HTML(html).at_css('.bio .weight dd')
    dd.text if dd
  end

  def name_query(html=self.html)
    doc = Nokogiri::HTML(html)
    doc.at_css('.player-info h1') ? doc.at_css('.player-info h1').attributes['data-name'].value : nil
  end


end
