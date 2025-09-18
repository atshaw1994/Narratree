if defined?(Aws::S3::Object)
  Aws::S3::Object.class_eval do
    alias_method :orig_put, :put

    def put(options = {}, &block)
      options = options.dup
      # Remove all possible checksum-related keys
      options.keys.each do |k|
        options.delete(k) if k.to_s.include?("checksum")
      end
      options.delete(:content_md5)
      options.delete(:checksum_algorithm)
      puts "=== AWS S3 put options (final filter): #{options.inspect}"
      Rails.logger.warn "=== AWS S3 put options (final filter): #{options.inspect}" if defined?(Rails)
      orig_put(options, &block)
    end
  end
  Rails.logger.info "AWS S3 Object put method patched to remove checksum headers" if defined?(Rails)
end
