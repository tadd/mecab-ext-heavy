require 'mkmf'
require 'mini_portile'

require_relative 'parallel_make.rb'

def cook_internal(name, version, url, patches = [])
  recipe = MiniPortile.new(name, version)
  recipe.files = [url]
  recipe.configure_options += %w[--with-charset=utf8]
  recipe.patch_files += patches.map(&File.method(:expand_path)) unless patches.empty?
  recipe.cook
  recipe.activate
end

def cook_mecab
  cook_internal('mecab', '0.996', 'https://mecab.googlecode.com/files/mecab-0.996.tar.gz')
end

def cook_naist_jdic
  cook_internal('mecab-naist-jdic', '0.6.3b-20111013',
                'http://jaist.dl.sourceforge.jp/naist-jdic/53500/mecab-naist-jdic-0.6.3b-20111013.tar.gz',
                %w[patch/prefix.patch])
end

cook_mecab
cook_naist_jdic

create_makefile 'mecab-ext-heavy'
