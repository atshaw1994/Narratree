Rails.application.config.to_prepare do
  if defined?(ActiveStorage::Service::S3Service)
    ActiveStorage::Service::S3Service.class_eval do
      private

      def upload(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          sanitized_options = options.dup
          sanitized_options.delete(:checksum_sha256)
          sanitized_options.delete(:checksum_sha1)
          sanitized_options.delete(:checksum_crc32)
          sanitized_options.delete(:checksum_crc32c)
          sanitized_options.delete(:content_md5)
          sanitized_options.delete(:checksum)
          object_for(key).put(body: io, **sanitized_options)
        end
      end

      def upload_without_unfurling(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          sanitized_options = options.dup
          sanitized_options.delete(:checksum_sha256)
          sanitized_options.delete(:checksum_sha1)
          sanitized_options.delete(:checksum_crc32)
          sanitized_options.delete(:checksum_crc32c)
          sanitized_options.delete(:content_md5)
          sanitized_options.delete(:checksum)
          object_for(key).put(body: io, **sanitized_options)
        end
      end
    end
  end
  Rails.logger.info "ActiveStorage S3Service patch loaded" if defined?(Rails)
end
