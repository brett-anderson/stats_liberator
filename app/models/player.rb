class Player < ActiveRecord::Base
  require 'open-uri'
  validates :yahoo_id, uniqueness: true

  after_create :generate_columns_from_html


  def generate_columns_from_html
    html = Nokogiri::HTML(self.yahoo_link)
    worked = self.update(
    html: html.to_s,
    height: height_query(html),
    weight: weight_query(html),
    name:   name_query(html)
    )
    unless worked
      html = Nokogiri::HTML(self.yahoo_link)
      self.update(
        html: html.to_s,
        height: height_query(html),
        weight: weight_query(html),
        name: name_query(html)
      )
    end
  end

  protected

  def height_query(html)
    dd = html.at_css('.bio .height dd')
    dd.text if dd

  end

  def weight_query(html)
    dd = html.at_css('.bio .weight dd')
    dd.text if dd
  end

  def name_query(html)
    doc = html.at_css('.player-info h1')
    doc.text if doc
  end

  def yahoo_link
      "http://sports.yahoo.com/nhl/players/#{self.yahoo_id}/"
  end

end
