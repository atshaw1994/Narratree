if defined?(Aws::S3::Object)
  Aws::S3::Object.class_eval do
    alias_method :orig_put, :put

    def put(options = {}, &block)
      options = options.dup
      # Log all option keys and values for debugging
      puts "=== AWS S3 put options: #{options.inspect}"
      Rails.logger.warn "=== AWS S3 put options: #{options.inspect}" if defined?(Rails)
      # Remove any key that includes 'checksum'
      options.keys.each do |k|
        options.delete(k) if k.to_s.include?("checksum")
      end
      options.delete(:content_md5)
      orig_put(options, &block)
    end
  end
  Rails.logger.info "AWS S3 Object put method patched to remove checksum headers" if defined?(Rails)
end
