require 'fileutils'

namespace :pkg do
  desc 'Generate package source tar.bz2, supply ref=<tag> for tags'
  task :generate_source do
    File.exist?('pkg') || FileUtils.mkdir('pkg')
    ref = ENV['ref'] || 'HEAD'
    version = `git show #{ref}:VERSION`.chomp
    raise "can't find VERSION from #{ref}" if version.length == 0
    `git archive --prefix=foreman-selinux-#{version}/ #{ref} | bzip2 -9 > pkg/foreman-selinux-#{version}.tar.bz2`
  end
end
