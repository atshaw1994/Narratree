Rails.application.config.to_prepare do
  if defined?(ActiveStorage::Service::S3Service)
    ActiveStorage::Service::S3Service.class_eval do
      private

      def upload(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          options.delete(:checksum_sha256)
          options.delete(:checksum_sha1)
          options.delete(:checksum_crc32)
          options.delete(:checksum_crc32c)
          object_for(key).put(body: io, **options)
        end
      end

      def upload_without_unfurling(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          options.delete(:checksum_sha256)
          options.delete(:checksum_sha1)
          options.delete(:checksum_crc32)
          options.delete(:checksum_crc32c)
          object_for(key).put(body: io, **options)
        end
      end
    end
  end
  Rails.logger.info "ActiveStorage S3Service patch loaded" if defined?(Rails)
end
