require 'mkmf'
require 'mini_portile'

# from: https://github.com/grosser/parallel/blob/master/lib/parallel.rb
def processor_count
  os_name = RbConfig::CONFIG["target_os"]
  if os_name =~ /mingw|mswin/
    require 'win32ole'
    result = WIN32OLE.connect("winmgmts://").
      ExecQuery("select NumberOfLogicalProcessors from Win32_Processor")
    result.to_enum.collect(&:NumberOfLogicalProcessors).reduce(:+)
  elsif File.readable?("/proc/cpuinfo")
    IO.read("/proc/cpuinfo").scan(/^processor/).size
  elsif File.executable?("/usr/bin/hwprefs")
    IO.popen("/usr/bin/hwprefs thread_count").read.to_i
  elsif File.executable?("/usr/sbin/psrinfo")
    IO.popen("/usr/sbin/psrinfo").read.scan(/^.*on-*line/).size
  elsif File.executable?("/usr/sbin/ioscan")
    IO.popen("/usr/sbin/ioscan -kC processor") do |out|
      out.read.scan(/^.*processor/).size
    end
  elsif File.executable?("/usr/sbin/pmcycles")
    IO.popen("/usr/sbin/pmcycles -m").read.count("\n")
  elsif File.executable?("/usr/sbin/lsdev")
    IO.popen("/usr/sbin/lsdev -Cc processor -S 1").read.count("\n")
  elsif File.executable?("/usr/sbin/sysconf") and os_name =~ /irix/i
    IO.popen("/usr/sbin/sysconf NPROC_ONLN").read.to_i
  elsif File.executable?("/usr/sbin/sysctl")
    IO.popen("/usr/sbin/sysctl -n hw.ncpu").read.to_i
  elsif File.executable?("/sbin/sysctl")
    IO.popen("/sbin/sysctl -n hw.ncpu").read.to_i
  else
    1
  end
end

MiniPortile.class_eval do
  def make_cmd
    "make -j#{processor_count+1}"
  end
end

def cook_mecab
  recipe = MiniPortile.new("mecab", "0.996")
  recipe.files = %w[https://mecab.googlecode.com/files/mecab-0.996.tar.gz]
  recipe.configure_options += %w[--with-charset=utf8]
  recipe.cook
  recipe.activate
end

def cook_naist_jdic
  recipe = MiniPortile.new("mecab-naist-jdic", "0.6.3b-20111013")
  recipe.files = %w[http://jaist.dl.sourceforge.jp/naist-jdic/53500/mecab-naist-jdic-0.6.3b-20111013.tar.gz]
  recipe.configure_options += %w[--with-charset=utf8]
  recipe.cook
  recipe.activate
end

cook_mecab
cook_naist_jdic

create_makefile 'mecab-ext-heavy'
