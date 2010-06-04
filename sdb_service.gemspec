Gem::Specification.new do |s|
  # Release Specific Information
  s.version = "0.4.0"
  s.date = "2010-06-04"

  # Gem Details
  s.name = "sdb_service"
  s.authors = ["Derek Perez", "Chris Eppstein"]
  s.summary = %q{even simpler wrapper around aws_sdb, with builtin serialization.}
  s.description = %q{even simpler wrapper around aws_sdb, with builtin serialization.}
  s.email = "derek@derekperez.com"
  s.homepage = "http://blog.derekperez.com/"

  # Gem Files
  s.files = %w(README)
  s.files += Dir.glob("lib/**/*.*")

  # Gem Bookkeeping
  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.add_dependency("uuidtools", [">= 2.1.1"])
  s.add_dependency("json_pure", [">= 1.4.1"])
  s.add_dependency("caring-aws-sdb", [">= 0.3.2.caring.1"])
end
