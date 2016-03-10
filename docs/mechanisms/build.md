## BuildMechanism

### Script

The Script BuildMechanism will execute a local shell script, with certain
expectations. The script will run with some environment variables:

- `VERSION`: The named version string passed to `build-version`.
- `OUTPUT_FILE`: The file that the script is expected to produce.

If the file is not created by the build script, deployment will fail. Otherwise,
the output file will be uploaded using the ArtifactRepository.
