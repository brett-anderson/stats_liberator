class Player < ActiveRecord::Base
  require 'open-uri'
  validates :yahoo_id, uniqueness: true

  after_create :generate_columns_from_html


  def generate_columns_from_html
    begin
      html = Nokogiri::HTML(self.html)
      worked = self.update(
        html: html.to_s,
        height: height_query(html),
        weight: weight_query(html),
        name:   name_query(html),
        position: position_query(html),
        number: number_query(html),
        team: team_query(html))
      unless worked
        html = Nokogiri::HTML(open(self.yahoo_link))
        self.update(
          height: height_query(html),
          weight: weight_query(html),
          name:   name_query(html),
          position: position_query(html),
          number: number_query(html),
          team: team_query(html))
      end
      Rails.logger.info "Processed #{self.name}" if worked
    rescue SyntaxError::NoMethodError
      html = Nokogiri::HTML(open(self.yahoo_link))
      worked = self.update(
        height: height_query(html),
        weight: weight_query(html),
        name:   name_query(html),
        position: position_query(html),
        number: number_query(html),
        team: team_query(html))
      Rails.logger.info "Processed #{self.name}" if worked
    end

  end

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

  def position_query(html)
    html.at_css('.team-info').text.strip.split(',')[1].strip
  end

  def number_query(html)
    html.at_css('.team-info').text.strip.split(',')[0][1..-1]
  end

  def team_query(html)
    html.at_css('.team-info').text.strip.split(',')[2].strip
  end

  def yahoo_link
    "http://sports.yahoo.com/nhl/players/#{self.yahoo_id}/"
  end

end
