if defined?(Aws::S3::Object)
  Aws::S3::Object.class_eval do
    alias_method :orig_put, :put

    def put(options = {}, &block)
      # Remove all possible checksum options
      options = options.dup
      options.delete(:checksum_sha256)
      options.delete(:checksum_sha1)
      options.delete(:checksum_crc32)
      options.delete(:checksum_crc32c)
      options.delete(:content_md5)
      options.delete(:checksum)
      orig_put(options, &block)
    end
  end
  Rails.logger.info "AWS S3 Object put method patched to remove checksum headers" if defined?(Rails)
end
