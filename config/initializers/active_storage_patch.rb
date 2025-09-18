# Patch Active Storage S3Service to disable checksum header for Cloudflare R2 compatibility
Rails.application.config.to_prepare do
  if defined?(ActiveStorage::Service::S3Service)
    ActiveStorage::Service::S3Service.class_eval do
      private

      def upload_with_checksum(key, io, checksum: nil, **options)
        instrument :upload, key: key, checksum: checksum do
          object_for(key).put(body: io, **options.except(:checksum))
        end
      end

      alias_method :upload, :upload_with_checksum
    end
  end
end
