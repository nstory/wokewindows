# minimal wrapper around AWS S3 API
class S3
  def initialize(region = "us-east-1", bucket)
    @bucket = Aws::S3::Resource.new(region: region).bucket(bucket)
  end

  def download_object(key, path)
    out = @bucket.object(key).get
    IO.copy_stream(out.body, path)
  end

  def get_body(key)
    @bucket.object(key).get.body
  end

  def objects(path)
    @bucket.objects({prefix: path}).to_a
  end

  def object_exists?(key)
    @bucket.object(key).exists?
  end

  def upload_object(key, path)
    @bucket.object(key).put(body: path)
  end
end
