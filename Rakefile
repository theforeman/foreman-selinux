require 'fileutils'

namespace :pkg do
  desc 'Generate package source tar.bz2, supply ref=<tag> for tags'
  task :generate_source do
    File.exist?('pkg') || FileUtils.mkdir('pkg')
    ref = ENV['ref'] || 'HEAD'
    version = `git show #{ref}:VERSION`.chomp.chomp('-develop')
    raise "can't find VERSION from #{ref}" if version.length == 0
    `git archive --prefix=foreman-selinux-#{version}/ #{ref} | bzip2 -9 > pkg/foreman-selinux-#{version}.tar.bz2`
  end

  desc 'Compile and load policy on a remote host, supply distro & host=(user@)hostname'
  task :load do
    box = ENV['host'] || 'UNKNOWN'
    distro = ENV['distro'] || 'rhel6'
    system "rsync -rav . -e ssh --exclude .git #{box}:policy/"
    system "ssh #{box} 'cd policy && sed -i s/@@VERSION@@/99.9/ *.te && make -f /usr/share/selinux/devel/Makefile load DISTRO=#{distro} && echo OK'"
  end
end
