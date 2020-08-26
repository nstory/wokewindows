namespace :exports do
  task :export, [:cls, :s3_path] => [:environment] do |t,args|
    cls = args.fetch(:cls)
    s3_path = args.fetch(:s3_path, nil)
    exporter = cls.constantize.new
    if !s3_path
      exporter.export($stdout)
    else
      Tempfile.create("exports") do |tmpfile|
        exporter.export(tmpfile)
        tmpfile.flush
        system("aws", "s3", "cp", tmpfile.path, s3_path, "--acl", "public-read")
      end
    end
  end
end
