require 'pry'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w{ .. vendor jekyll lib })
require 'jekyll'

ROOT_DIR = File.expand_path(File.dirname(__FILE__))
puts ROOT_DIR

def dest_dir(*subdirs)
  root_dir('dest', *subdirs)
end

def source_dir(*subdirs)
  root_dir('src', *subdirs)
end

def root_dir(*subdirs)
  File.join(ROOT_DIR, *subdirs)
end

def fixture_site(overrides = {})
  Jekyll::Site.new(site_configuration(overrides))
end

def build_configs(overrides)
  Jekyll.configuration(overrides)
end

def site_configuration(overrides = {})
  build_configs({
    "source"      => source_dir,
    "destination" => dest_dir
  })
end

def site
  @site ||= fixture_site
end

def init(site)
  site.reset
  site.read
  site.generate
  site.render
  site.cleanup
end

module Jekyll
  binding.pry

end
