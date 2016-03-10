## ArtifactRepository

Supported ArtifactRepositories:
- S3

### S3Bucket

To create a new S3Bucket ArtifactRepository:
```ruby
class MyApplication < Moonshot::CLI
  self.artifact_repository = S3Bucket.new('my-bucket-name')
end
```

The store action will simply upload the file using the S3 PutObject API call.
The local environment must be configured with appropriate credentials.
