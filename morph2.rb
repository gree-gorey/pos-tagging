# -*- coding: utf-8 -*-

require "rubygems"
require 'nokogiri'

g = File.open('serg_gold_new.xml')
o = File.open('serg.xml')
#moscow = File.open('parsed_sergij.csv')
align = File.open('aligned_for_morph34_tokennorm.csv')


gold = Nokogiri::XML(g,nil,'utf-8')
oslo = Nokogiri::XML(o,nil,'utf-8')


CASUS = {'a' => 'acc',
  'n' => 'nom',
  'l' => 'loc',
  'v' => 'voc',
  'i' => 'ins',
  'd' => 'dat',
  'g' => 'gen'}

NUMBER = {'d' => 'du',
  's' => 'sg',
  'p' => 'pl'}

PERSON = {'1' => '1p',
  '2' => '2p',
  '3' => '3p'}

MOOD = {'i' => 'indic',
  'm' => 'imper',
  'n' => 'inf'}

TENSE = {'s' => 'perf',
  'p' => 'praes',
  'i' => 'imperf',
  'a' => 'aor',
  'f' => 'analyt'
}

def gen(gen)
  if ['q','p','o'].include?(gen)
    gen = 'm'
  else
    gen
  end
end


#skipping degree and strength, I think
#seems to be skipping all participles!



def moscowmorph(w)
  feats = w['morphology'].split(//)
  cas = feats[6]
  num = feats[1]
  per = feats[0]
  mod = feats[3]
  tns = feats[2]
  inf = feats[9]
  gen = feats[5]
  
  if w['part-of-speech'] == 'V-'
    if mod == 'i'
      mtag = [MOOD[mod],TENSE[tns],NUMBER[num],PERSON[per]].join(',')
    elsif mod == 'm'
      mtag = [MOOD[mod],NUMBER[num],PERSON[per]].join(',')
    elsif mod == 'p'
       if tns == 's'
        STDERR.puts "#{w['form']} is an l-participle"
        mtag = [TENSE[tns],NUMBER[num],gen(gen)].join(',')
      else
        mtag = 'participle'
      end
    elsif mod == '-'
      mtag = 'noninfl'
    else
      mtag = MOOD[mod]
    end
  elsif ['Nb','Ne'].include?(w['part-of-speech'])
    mtag = [gen(gen),NUMBER[num],CASUS[cas]].join(',')
  elsif ['A-',"Pd",  "Pr", "Ps", "Pt"].include?(w['part-of-speech'])
    mtag = [NUMBER[num],gen(gen),CASUS[cas]].join(',')
  elsif ["Px","Ma","Mo"].include?(w['part-of-speech'])
    mtag = [NUMBER[cas],CASUS[cas]].join(',')
  elsif ['Pk', 'Pp', 'Pi'].include?(w['part-of-speech'])
    mtag = CASUS[cas]
  elsif w['part-of-speech'] == "Df"
    mtag = 'noninfl'
  else
    if inf == 'n'
      mtag = 'noninfl'
    else
      STDERR.puts "what to do with tag #{w['morphology']}?"
    end
  end
  return mtag
end


NOTAG = ['intr','tr','pf','ipf','med','inan','anim','brev','PART','persn','comp']

def simplemos(hsh)
  if hsh['tag'] == ''
    ms = 'noninfl'
  else
    feats = hsh['tag'].split(',')
    sp = []
    feats.each do |f|
      sp << f unless NOTAG.include?(f)
    end
    ms = sp.join(',')
  end
  return ms
end

def accurate(w,analyses,manal) 
  gmorph = moscowmorph(w) 
  eval = []
  manal.each_with_index do |a,i|
    if a == gmorph
      STDERR.puts w['form'] if gmorph == 'sg,gen'
      eval << 1
    elsif gmorph == 'm,sg,gen' and a == 'm,sg,acc' and analyses[i]['tag'].split(',').include?('anim')
      STDERR.puts "#{w['form']} is potentially a genitive-accusative"
      eval << 1
    elsif gmorph == 'sg,gen' and a == 'sg,acc' and analyses[i]['tag'].split(',').include?('anim')
      STDERR.puts "#{w['form']} is potentially a genitive-accusative"
      eval << 1
    else
      #STDERR.puts "Moscow guess number #{i}, #{a}, is not like gold #{gmorph}"
      eval << 0
    end
  end
  eval
end

def stats(eval)
  if eval.size == 1
    if eval.first == 1
      full_match = 1
    else
      full_match = 0
    end
  else 
    full_match = 0
  end
  if eval.first == 1
    first_match = 1
  else
    first_match = 0
  end
  if eval.include?(1)
    any_match = 1
  else
    any_match = 0
  end
  return [full_match,first_match,any_match,eval.count(1).to_f/eval.size]
end


osl = []
(oslo/"sentence").each do |s|
  s.children.each do |w|
    if w.name == 'token' and !w['empty-token-sort']
      osl << w
    end
  end
end

al = []
align.each_line do |w|
  al << w.split(';')
end


def guesses(line)
  a = line[10].split("<ana")
  analyses = []
  a.each do |g|
    unless g =~ /<w>/
      g.gsub(/><\/ana>.*/,'').split(' ').each do |f|
        if f =~ /lex/
          @lemma = f.gsub(/lex="/,'').gsub(/"/,'')
        end
        if f =~ /gr/
          @pos = f.split(',').first.gsub(/gr="/,'').gsub(/"/,'')
          @tag = f.gsub(/"/,'').split(',').drop(1).join(',')
        end
      end
      h = {'lemma' => @lemma, 'pos' => @pos, 'tag' => @tag}
      analyses << h
    end
  end
  analyses
end

def hamming(gold, oslo)
  dist = 0
  gs = gold.split(//)
  os = oslo.split(//)
  gs.each_with_index do |f,i|
    if f != os[i]
      dist += 1
    end
  end
  dist
end



STDOUT.puts "id;form;gold_lemma;gold_pos;gold_morph;gold_moscow_morph;oslo_morph;oslo_moscow_morph;moscow_analyses;gold_oslo_dist;moscow_first_lemma;full_match;first_match;any_match;relative_match"


(gold/"sentence").each do |s|
  s.children.each do |w|
    if w.name == 'token' and !w['empty-token-sort']
      line = al.select { |l| l[0] == w['id'] }.flatten
      #STDERR.puts line[10]
      #STDERR.puts [w['id'],w['form'], w['lemma'], w['part-of-speech'],w['morphology']].join(',')
      o = osl.select { |ow| ow['id'] == line[5] }
      #STDERR.puts line[5]
      analyses = guesses(line) if line[10].chomp != ''
      #m = mt.select { |mw| mw[0] == w['id'] }
      manal = []
      if analyses
        analyses.each do |an|
          manal << simplemos(an)
        end
      else #STDERR.puts line
      end
      if o.any? and (o.first['morphology'] != w['morphology'])
        #STDERR.puts "guess #{o.first['morphology']} deviates from gold #{w['morphology']}"
      end
      #STDERR.puts hamming(w['morphology'],o.first['morphology']) if o.any?
     # STDERR.puts accurate(w,m, manal).inspect if m.any?
      STDOUT.puts [w['id'],w['form'], w['lemma'], w['part-of-speech'],w['morphology'],moscowmorph(w),(o.any? ? o.first['morphology'] : nil),(o.any? ? moscowmorph(o.first) : nil) ,manal.join('|'),(o.any? ? hamming(w['morphology'],o.first['morphology']) : nil), (analyses ? analyses.first['lemma'] : nil),analyses ? stats(accurate(w,analyses,manal)).join(';') : '0;0;0;0'].join(';')
     end
  end
end

