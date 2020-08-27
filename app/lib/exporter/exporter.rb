class Exporter::Exporter
  include Rails.application.routes.url_helpers

  attr_accessor :definitions, :record

  def initialize
    @definitions = {}
    column_definitions
  end

  def export(io)
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

  def prefix(name, clazz, &prc)
    e = clazz.new
    e.definitions.each do |key, eprc|
      @definitions["#{name}_#{key}"] = proc do
        r = instance_eval(&prc)
        if r
          e.record = r
          e.instance_eval(&eprc)
        else
          nil
        end
      end
    end
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
