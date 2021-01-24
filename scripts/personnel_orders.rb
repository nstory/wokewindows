PDF_DIR = "/Users/nstory/Desktop/ma_police_foia_project/boston/globe"

Order = Struct.new(:pdf_file, keyword_init: true) do
  def url
    f = pdf_file.sub(/.*\//, "")
    f.gsub!(" ", "%20")
    "https://wokewindows-data.s3.amazonaws.com/personnel_orders/#{f}"
  end

  def text
    @text ||= `pdftotext "#{pdf_file}" -`
  end

  def id_numbers
    text.scan(/ID *# *(\d+)/i).map(&:first).map(&:to_i)
  end

  def name
    pdf_file.sub(/.*\//, "").sub(/.pdf/i, "")
  end

  def date
    dt = date_text
    if dt
      Chronic.parse(dt).strftime("%Y-%m-%d")
    else
      nil
    end
  end

  def date_text
    re = Regexp.new("(#{Date::MONTHNAMES.compact.join("|")})\\s+\\d+,\\s+\\d+")
    if re.match(text)
      $&
    else
      nil
    end
  end
end

def orders
  Dir.glob("#{PDF_DIR}/**/*Personnel*.pdf").lazy.map do |pdf_file|
    Order.new(pdf_file: pdf_file)
  end
end

def extract
  hs = orders.to_a.map do |o|
    {url: o.url, title: o.name, date_published: o.date, body: o.text, employee_ids: o.id_numbers}
  end
  p hs
end

def ingest
  hs = eval($stdin.read)
  hs.each do |h|
    ids = h.delete(:employee_ids)
    h[:articles_officers] = Officer.where(employee_id: ids).to_a.map do |o|
      ArticlesOfficer.new(officer: o, status: "confirmed", concerning: true)
    end
    Article.create(h) unless Article.find_by(url: h[:url])
  end
end

send(ARGV[0].to_sym)
