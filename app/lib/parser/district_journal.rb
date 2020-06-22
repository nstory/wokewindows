# parses incident information out of public_journal*.pdf and
# district_journal*.pdf files distributed on bpdnews.com
class Parser::DistrictJournal < Parser::Parser
  def category
    "district_journal"
  end

  def url
    "https://bpdnews.com/s/#{pathname.basename.to_s}"
  end

  def likely_journal?
    contents = IO.read(@filename, mode: "rb")
    contents.include?("Microsoft Reporting Services")
  end

  # the number of records the document claims to contain
  def record_count
    pair = text_blocks.each_cons(2)
      .select { |cons| cons[1] == "Record Count:" }.first
    pair && pair[0].to_i
  end

  def records
    blocks = stripped_text_blocks
    data = []
    # blanks at end for case where last record is shorter (b/c it doesn't have arrest)
    (blocks + [" "]*16).each_with_index.each_cons(16) do |cons|
      strings = cons.map(&:first)
      indices = cons.map(&:second)

      signature = strings[0...4].join(" ").strip

      if /^Report Date & Time.*Officer$/ =~ signature && "Record Count:" != strings[6]
        # new-style record
        datum = {
          report_date_time: strings[4],
          complaint_number: strings[5],
          occurrence_date_time: strings[6],
          officer: strings[7],
          location_of_occurrence: strings[9],
          nature_of_incident: strings[11],
          arrests: []
        }
        if "Arrests" == strings[12]
          datum[:arrests] = get_new_style_arrests(blocks.slice(indices[13], 9999))
        end
        data << normalize_hash(datum)
      elsif /^Report Date & Time.*Location of Occurrence$/ =~ signature
        # old-style record
        datum = {
          report_date_time: strings[4],
          complaint_number: strings[5],
          occurrence_date_time: strings[6],
          location_of_occurrence: strings[7],
          nature_of_incident: strings[9],
          officer: strings[11],
          arrests: []
        }
        datum[:arrests] = get_old_style_arrests(blocks.slice(indices[12], 9999))
        data << normalize_hash(datum)
      end
    end
    data
  end

  private
  def pdf
    # result is memoized so PDF is only parsed once
    @pdf ||= Origami::PDF.read(@filename)
  end

  # returns array of strings
  def text_blocks
    pdf.each_object
      .select {|o| o.instance_of? Origami::ContentStream}
      .flat_map(&:instructions)
      .select {|i| i.operator == "Tj"}
      .map(&:operands)
      .map { |operands| operands.join(" ") }
  end

  # text blocks with irrelvant content (e.g. headers, footers) removed
  def stripped_text_blocks
    stripped = []
    text_blocks.each do |tb|
      if "Boston Police Department" == tb && %r{^\d+/\d+/\d{4} } =~ stripped.last
        # skip
        stripped.pop
      elsif /, Police Commissioner/ =~ tb
        # skip
      elsif /^Selected & Sorted By:/ =~ tb
        # skip
      elsif /^Record Count:/ =~ tb
        # skip
        stripped.pop if /^\d+$/ =~ stripped.last
      elsif /^(Date:|Reported|Occurred)$/ =~ tb
        # skip
      else
        stripped << tb
      end
    end
    stripped
  end

  # trim all strings and return a new hash
  def normalize_hash(h)
    h.map do |k,v|
      v = v.strip if v.respond_to?(:strip)
      v = v.gsub(/[^[[:ascii:]]]/, "") if v.respond_to?(:gsub)
      [k, v]
    end.to_h
  end

  def get_new_style_arrests(blocks)
    arrests = []
    blocks.each_slice(3) do |slice|
      break if slice.count < 3
      break if /Report Date/ =~ slice.join(" ")
      arrests << normalize_hash({
        name: slice[0],
        address: slice[1],
        charge: slice[2]
      })
    end
    arrests
  end

  def get_old_style_arrests(blocks)
    arrests = []
    blocks.each_slice(4) do |slice|
      break if slice.count < 4
      break if "Arrests" != slice[0].strip
      arrests << normalize_hash({
        name: slice[1],
        address: slice[2],
        charge: slice[3]
      })
    end
    arrests
  end
end
