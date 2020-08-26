class Exporter::Exporter
  def export(io)
    @definitions = {}
    column_definitions

    io.puts(@definitions.keys.to_csv)
    records.each do |record|
      values = @definitions.values.map do |prc|
        @record = record
        instance_eval(&prc)
      end
      io.puts(values.to_csv)
    end
  end

  private
  def column(name, &prc)
    @definitions[name] = prc
  end

  def record
    @record
  end

  def write_boolean(bool)
    return "" if bool == nil
    bool ? "true" : "false"
  end

  def write_money(money)
    money ? "%0.2f" % money : nil
  end

  def write_zip_code(zip_code)
    zip_code ? zip_code.to_s.rjust(5, "0") : nil
  end
end
