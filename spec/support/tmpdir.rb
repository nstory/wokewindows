RSpec.shared_context "tmpdir", :shared_context => :metadata do
  around(:each) do |example|
    Dir.mktmpdir do |dir|
      @tmpdir = dir
      files.each do |filename, content|
        IO.write("#{dir}/#{filename}", content)
      end
      example.run
    end
  end
end
