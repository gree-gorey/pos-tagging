# -*- coding: utf-8 -*-

ver = "34"

norm = true #use normalised input 
moscowlemmanorm = true #normalise Moscow lemmas

require "rubygems"
require 'nokogiri'

#for the conversion of yers
YERS = ["ь", "ъ", "Ъ","Ь"]
FVOWELS = ["е", "о", "ѣ", "и", "ѧ", "ы", "у", "а", "я",  "ю", "ѡ", "А", "і", "И", "ѥ", "ѹ", "ї", "Я", "О", "Ю", "Ѡ", "Е", "У", "Ѣ", "Ы", "ι", "i"]
LIQUIDS = ["р", "л", "Л", "Р"]
CONSONANTS = ["С", "п", "в", "с", "т", "р", "м", "н", "х", "л", "к",  "д", "ш",  "з",  "ч", "ж",  "ф", "г", "щ", "Х", "ц", "б", "В", "Г", "ѥ", "П", "ѕ", "ѯ", "ѳ", "М", "Л", "К", "Р", "Н", "ѱ", "ҁ",  "Ц", "Ч", "З", "Б", "Ѳ", "Т", "Д", "й",  "Ф", "Ж", "Й", "Щ", "c"]
FALL = {"ь" => "е", "Ь" => "е", 'ъ' => 'о', 'Ъ' => 'о'}
TEMP = {"ь" => "Ь", "Ь" => "Ь", 'ъ' => 'Ъ', 'Ъ' => 'Ъ'}

#for POS comparison
POSTAGS = {"A" => ["A-"],
"A-PRO" => ["A-", "Pd", "Pi", "Pk", "Pp", "Pr", "Ps", "Pt", "Px"],
"ADV" => ["Df"],
"ADV-PRO" => ["Df", "Du"],
"ADV?" => ["Df"],
"CONJ" => ["C-","G-","Df"],
"CONJ/PART" => ["Df","G-"],
"INTJ" => ["I-"],
"N" => ["Nb","Ne"],
"N-PRO" => ["Pp","Pk","Pi","Px"],
"NUM" => ["Ma"],
"PART" => ["Df"],
"PREP" => ["R-"],
"V" => ["V-"]
}

#for normalisation
RUSNORMAL = {" "  => "",  "ѣ" => "е", "ѧ" => "я", "ѿ" => "от", "ѡ" => "о", "-" => "", "і" => "и", "҃" => "", "." => "",  ":" => "",  "ѥ" => "е", "ѕ" => "з", "ѯ" => "кс",  "ѳ" => "ф", "·" => "", "ѱ" => "пс",  "ҁ" => "с",  "ѹ" => "у",  "+" => "",  "ї" => "и",  "/" => "",  "Ѿ" => "от",  "Б" => "б",  "Ю" => "ю",  "Ѳ" => "Ф",  "Т" => "т",  "Ѡ" => "о",  "Е" => "е",  "Д" => "д", "С" => "с", "Х" => "х", "А" => "а", "И" => "и", "В" => "в", "Г" => "г", "П" => "п", "М" => "м", "Л" => "л",  "К" => "к",  "Р" => "р",  "Н" => "н", "Ц" => "ц",  "Ч" => "ц", "Я" => "я", "ꙇ" => "и",  "ѫ" => "у",  "ѩ" => "я", "҃" => "",  "ѭ" => "ю",  "ꙑ" => "ы",  "ⷭ" => "с",  "҇" => "", "ꙉ" => "г",  "҄" => "",  "ⷬ" => "р",  "й" => "и",  "҅" => "",   "ѵ" => "у",  "ⷣ" => "д",  "ⷮ" => "т", "Ꙇ" => "и",  "̆" => "",  "ⷦ" => "к",  "ⷩ" => "н",  "ⷫ" => "п",  "О" => "о",  "И" => "и",  "Ф" => "ф",  "̈" => "",  "ⷱ" => "ч",  "Ж" => "ж",  "ⷠ" => "б",  "?" => "",  "Ш" => "ш",  "Ю" => "ю",  "-" => "",  "Ѣ" => "е",  "ⷢ" => "г",  "." => "",  "ⷡ" => "в",  "Ъ" => "ъ",  "ⷸ" => "г",  "ⷰ" => "ц",  "Ь" => "ь",  "Ꙉ" => "г",  "З" => "з",  "Ꙑ" => "ы",  "І" => "и",  "ⷧ" => "л",  "ⷯ" => "х",  "ꙙ" => "я",  "ѳ" => "ф",  "=" => "",  "ⷪ" => "о",  "ꙗ" => "я",  "ѥ" => "е",  "ꙋ" => "у",  "’" => "",  "͑" => "",  "͗" => "",  "ⱕ" => "я",  "ʼ" => "",  "͆" => "",  "ⰹ" => "и",  ":" => "",  "̒" => "",  "̓" => "",  "Ї" => "и",  "ӱ" => "у",  "̑" => "",  "̂" => "",  "͞" => "",  "ͨ" => "",  "̕" => "",  "̔" => "",  "a" => "a",  "͛" => "",  "ѱ" => "пс",  "ѻ" => "o",  "꙯" => "",  "҆" => "",  "ꙁ" => "з",  "'" => "",  "ӑ" => "a",  "x" => "х",  "[" => "",  "]" => "",  "ћ" => "г",  "ꙃ" => "з",  "X" => "х",  "!" => "",  "(" => "",  ")"=> "", "Й" => "и", "Ѣ" => "е", "Ъ" => "ъ", "Щ" => "щ", "Ы" => "ы",  "У" => "у",  "Ж" => "ж", "̋" => "",  "ι" => "и",  "й" => "и",  "i" => "и", "ȣ" => "у", "͠" => "", "ᴤ" => "з", "ʼ" => "ъ", "є" => "е",  "ѩ" => "я",  "ѷ" => "у",  "ѻ" => "о",  "⁜" => "",  "ꙋ" => "у", "ꙿ" => "ъ"}

def harmonize_oslo(oslolemma)
  oslo_harm = removedoublecons(modernize_oslo(yer_killer(cluster_yers(turt(havlik(oslolemma, true, -1, "").strip).strip).strip).strip).strip).strip
  return oslo_harm
end

def harmonize_moscow(moscowlemma)
  moscow1 = moscow_prefix_yers(moscowlemma)
  moscow1 = yer_killer(moscow1).strip
  moscow1.gsub!("зс","сс")
  moscow1 = removedoublecons(moscow1)
  moscow1.gsub!("жде","же")
  if moscow1 == "сеи"
    moscow1 = "сии"
  end
  if moscow1 == "тои"
    moscow1 = "тыи"
  end
  if moscow1 == "перед"
    moscow1 = "пред"
  end
  if moscow1 == "писати"
    moscow1 = "псати"
  end
  return moscow1
end

def removedoublecons(moscowlemma)
  prevchar = ""
  newlemma = ""
  if moscowlemma
    moscowlemma.each_char do |char|
      newlemma << char unless char == prevchar and CONSONANTS.include?(char)
	  
	  prevchar = char
    end
  end	
  return newlemma
end

def comparelemma(moscowlemma,goldlemma)
  gold1 = harmonize_oslo(goldlemma).strip#modernize_oslo(yer_killer(turt(havlik(goldlemma, true, -1, "").strip).strip).strip).strip
  moscow1 = harmonize_moscow(moscowlemma).strip

  if moscow1 == gold1
    result = true
  else 
    result = false
  end
  return result  
end 

def comparepos(moscowpos,goldpos)
  if POSTAGS[moscowpos].include?(goldpos)
    result = true
  else 
    result = false
  end
  return result  
end 

def modernize_oslo(word2)
  word = word2.clone
  word.gsub!("ѣ","е")
  word.gsub!("кы","ки")
  word.gsub!("гы","ги")
  word.gsub!("хы","хи")
  return word  
end

def moscow_prefix_yers(word2) 
  if (word2[0]=="в" or word2[0]=="с") and word2[1]=="о" and  word2.length > 4 
  	word2[1] = "ъ"
  end
  return word2
end


def prefix_yers(word2) 
  if word2[0]=="в" and word2[1]=="Ъ" and  word2.length > 8 and ((word2[2] == "з") or (word2[2] == "с")) 
  	word2[1] = "о"
  end
  return word2
end

def cluster_yers(word2) 
  word3 = word2.clone
  word3.gsub!("чЬст","чест")
  word3.gsub!("чЬск","ческ")
  return word3
end


def turt(word2) 
  word = word2.clone
  for index in 1..word.length-2
    if YERS.include?(word[index]) and ( (CONSONANTS.include?(word[index-1]) and LIQUIDS.include?(word[index+1]) and CONSONANTS.include?(word[index+2].to_s)) or (CONSONANTS.include?(word[index-2].to_s) and LIQUIDS.include?(word[index-1]) and CONSONANTS.include?(word[index+1].to_s)))
	  word[index]=FALL[word[index]]
	end
  end
  return word
end

def havlik(word,weak,index,output) #without yer killer: to preserve output for turt
  if -index <= word.length
    if YERS.include?(word[index]) #if it's a yer...
	  if !weak
	    output.insert(0, FALL[word[index]])  #...output its vocalization if it's strong
	  else
        output.insert(0, TEMP[word[index]])	  #...or ъ itself if it's weak
	  end
	  weak = !weak #change position value
	else #otherwise...
	  output.insert(0, word[index]) #...just output it
	  if FVOWELS.include?(word[index]) and !weak
	    weak=true #...but make position weak if a full vowel disrupts the yer chain
	  end
	end
    index = index - 1 #one symbol back
	havlik(word,weak,index,output) #recursive call
  end
  return output 
end

def yer_killer(word2)
  word3 = word2.clone
  word3.gsub!("ъ","")
  word3.gsub!("ь","")
  word3.gsub!("Ъ","")
  word3.gsub!("Ь","")
  return word3
end

def normal_rus(tk)
  lt = []
  chs = tk.split(//u)
  chs.each do |c|
    if RUSNORMAL.keys.include?(c)
      lt <<  RUSNORMAL[c]
    else 
      lt << c
    end
  end 
  return lt.join.gsub(/оу/,'у')
end

def torotextract(line,norm)
  lemma = line.split(";")[0]
  pos = line.split(";")[1]
  form = line.split(";")[2]
  if norm
    form = normal_rus(form)
  end
  id = line.split(";")[3]
  morph = line.split(";")[4]
  return [lemma, pos, form, id, morph]
end

def moscowextract(moscowline,moscowlemmanorm)
  moscowlemmas = []
  moscowpos = []
  tocheck = []  
  lemmaore = moscowline.split("ana lex=")
  lemmaore[1..-1].each do |lemmagem| 
    currentlemma = lemmagem[1..lemmagem[1..-1].index(lemmagem[0])].gsub("́","")
	if moscowlemmanorm
	  currentlemma = normal_rus(currentlemma)
	end
    forgram = lemmagem[lemmagem.index("gr=")+4..-1]
    gram = forgram[0..forgram.index(lemmagem[0])-1]
    currentpos = ""
    if gram.include?(",")
     currentpos << gram[0..gram.index(",")-1]
    else
     currentpos << gram
    end
  
    if !tocheck.include?("#{currentlemma}#{currentpos}")
      tocheck << "#{currentlemma}#{currentpos}"
      moscowlemmas << currentlemma
      moscowpos << currentpos
    end
  end
  moscowout = ""
  moscowlemmas.each_index do |ind|
    moscowout << ";" + moscowlemmas[ind] + ";" + moscowpos[ind]
  end 
  return moscowout    
end

def moscowextract2(moscowline,moscowlemmanorm) #adding harmonised forms to output for manual control
  moscowlemmas = []
  moscowpos = []
  tocheck = []  
  
  lemmaore = moscowline.split("ana lex=")
  lemmaore[1..-1].each do |lemmagem| 
    currentlemma = lemmagem[1..lemmagem[1..-1].index(lemmagem[0])].gsub("́","")
	if moscowlemmanorm
	  currentlemma = normal_rus(currentlemma)
	end
    forgram = lemmagem[lemmagem.index("gr=")+4..-1]
    gram = forgram[0..forgram.index(lemmagem[0])-1]
    currentpos = ""
    if gram.include?(",")
     currentpos << gram[0..gram.index(",")-1]
    else
     currentpos << gram
    end
  
    if !tocheck.include?("#{currentlemma}#{currentpos}")
      tocheck << "#{currentlemma}#{currentpos}"
      moscowlemmas << currentlemma
      moscowpos << currentpos
    end
  end
  moscowout = ""
  moscowlemmas.each_index do |ind|
    moscowout << ";" + moscowlemmas[ind] + ";" + harmonize_moscow(moscowlemmas[ind])+ ";" + moscowpos[ind]
  end 
  return moscowout    
end

def readfromxml(file)
  f = File.open(file)
  doc = Nokogiri::XML(f,nil,'utf-8')
  f.close

  lines = []
  (doc/"sentence").each do |s|
    sentence_id = s['id'] #can potentially be used for alignment
    s.children.each do |w|
      if w.name == 'token' and !w['empty-token-sort']
  	    line = ""
        line << "#{w['lemma']};"
        line << "#{w['part-of-speech']};" 
  	    line << "#{w['form']};"
  	    line << "#{w['id']};"
        line << "#{w['morphology']}"
  	    lines << line
  	  end
    end 
  end
  return lines
end

def align(ver,norm,moscowlemmanorm)
  outnorm = ""
  if norm
    moscowfile = File.open("parsed_sergij_normalised.csv", "r:utf-8")
    outnorm = "_tokennorm"
  else
    moscowfile = File.open("parsed_sergij.csv", "r:utf-8")
  end
  
  moscow = moscowfile.readlines
  sourcetext = File.open("serg1_full.txt", "r:utf-8")
  source = sourcetext.readlines
  goldfile = "serg_gold.xml"
  gold = readfromxml(goldfile)
  oslofile = File.open("serg_oslo.xml","r:utf-8")
  oslo = readfromxml(oslofile)
  
  output = File.open("aligned#{ver}#{outnorm}.csv","w")
  output_manual = File.open("aligned_for_manual#{ver}#{outnorm}.csv","w")
  output_formorph = File.open("aligned_for_morph#{ver}#{outnorm}.csv","w")
  output.puts "id (gold);id (oslo);gold form;gold lemma;gold pos;oslo lemma;oslo pos;moscow lemma;moscow pos;moscow lemma;moscow pos;moscow lemma;moscow pos;moscow lemma;moscow pos;moscow lemma;moscow pos;moscow lemma;moscow pos;moscow lemma;moscow pos"
  
  output_manual.puts "id (gold);id (oslo);gold form;gold lemma;gold lemma harmonized;gold pos;oslo lemma;oslo lemma harmonized;oslo pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos;moscow lemma;moscow lemma harmonized;moscow pos"
  output_formorph.puts "gold token id;gold form;gold lemma;gold pos;gold morphology;oslo token id;oslo form;oslo lemma;oslo pos;oslo morphology;moscow guess"
  
  moscowcounter = 0
  oslocounter = 0
  moscowhsh = {}
  oslohsh = {}
  osloids = []
  flag = false
  
  #mark existing moscow guesses with oslo ids
  source.each_index do |lineindex|
    osloline = oslo[oslocounter].strip
	osloarray = torotextract(osloline,norm)
	if osloarray[3] == "2205925"
	  flag = true
	  #moscowcounter = moscowcounter - 1
	end
	if osloarray[3] == "2205931"
	  flag = false
	  #moscowcounter = moscowcounter + 1
	  
	end
	
	if flag
	  lineindex = lineindex - 1
	end
	line = source[lineindex]
    sourceform = line.strip
    
    oslocounter += 1
    
    oslohsh[osloarray[3]] = osloarray
    osloids << osloarray[3]
    moscowline = moscow[moscowcounter].strip
    moscowform = moscowline.reverse[4..moscowline.reverse.index("ana")-2].reverse
	if norm
      sourceform = normal_rus(sourceform)
  	  moscowform = normal_rus(moscowform)
    end
	    
    if moscowform == sourceform
      moscowcounter += 1
  	  moscowhsh[osloarray[3]]	= moscowline
	  
    end
  end
  moscowhsh["2205925"] = nil
  
  goldhsh = {}
  goldids = []
  gold.each do |line|
    goldarray = torotextract(line.strip,norm)
    goldids << goldarray[3]
    goldhsh[goldarray[3]] = goldarray
  end
  
  ids = osloids.concat(goldids).uniq
  ids. each do |id|
      
  end
  
  
  #align gold, oslo and moscow
  ids.each do |id|
    if goldhsh[id]
      goldarray = goldhsh[id]
    else
      goldarray = ["","","","",""]
    end
    if oslohsh[id]
      osloarray = oslohsh[id]
  	if moscowhsh[id]
  	  moscowline = moscowhsh[id]
  	  moscowout = moscowextract(moscowline,moscowlemmanorm)
      moscowout2 = moscowextract2(moscowline,moscowlemmanorm)
  	end
    else
      osloarray = ["","","","",""]
    end
    
    output.puts "#{goldarray[3]};#{osloarray[3]};#{goldarray[2]};#{goldarray[0]};#{goldarray[1]};#{osloarray[0]};#{osloarray[1]}#{moscowout}" 
    output_manual.puts "#{goldarray[3]};#{osloarray[3]};#{goldarray[2]};#{goldarray[0]};#{harmonize_oslo(goldarray[0])};#{goldarray[1]};#{osloarray[0]};#{harmonize_oslo(osloarray[0])};#{osloarray[1]}#{moscowout2}" 
    output_formorph.puts "#{goldarray[3]};#{goldarray[2]};#{goldarray[0]};#{goldarray[1]};#{goldarray[4]};#{osloarray[3]};#{osloarray[2]};#{osloarray[0]};#{osloarray[1]};#{osloarray[4]};#{moscowline}"
  end
  
  output.close
  moscowfile.close
  oslofile.close
  output_formorph.close
  
end

def compare(ver,norm,torotlemmas,torotlemmas_h,torotposes)
  outnorm = ""
  if norm
    outnorm = "_tokennorm"
  end
  f = File.open("aligned#{ver}#{outnorm}.csv","r:utf-8")
  comp_output = File.open("comparison#{ver}#{outnorm}.csv","w")
  comp_output2 = File.open("results#{ver}#{outnorm}.csv","w")
  comp_output.puts ("gold id;oslo id;oslo;Fixme?;moscowguess;moscow exact;moscow fuzzy")
  oslolemmaright = 0.0
  osloposright = 0.0
  osloright = 0.0
  osloposrightcertain = 0.0
  total = 0.0
  totalcertain = 0.0
  moscowexact = 0.0
  moscowfuzzy = 0.0
  totalfixme = 0.0
  noguessmoscow = 0.0
  noguessmoscowosloright = 0.0
  moscowexactfixme = 0.0
  fixmemoscowexact = 0.0
  moscowfixesfixme = 0.0
  fixmemoscowfuzzy = 0.0
  oslowrongmoscowexact = 0.0 
  oslowrongmoscowfuzzy = 0.0 
  fixmetotal = 0.0
  fixmemoscowguess = 0.0
  noguessmoscowosloright = 0.0
  noguessmoscownofixme = 0.0
  moscowpose = 0.0
  moscowposf = 0.0
  noguessmoscowosloposright = 0.0
  moscowattemptsfixme = 0.0
  posboost = 0.0
  moscowfixesfixmepos = 0.0
    
  f.each_line do |line|
    line1 = line.strip
    line2 = line1.split(";")
    moscowguess = {}
      
    if line2[0][0..1]!="id"
      goldid = line2[0]
	  osloid = line2[1]
	  goldform = line2[2]
  	  total += 1.0
      goldflemma = line2[3]
  	  goldfpos = line2[4]
  	  osloglemma = line2[5]
  	  oslogpos = line2[6]
  	  ms = 7	
  	  counter = 1
  	  while line2[ms]
        moscowguess[counter]=[line2[ms],line2[ms+1]]
  	    ms += 2
  	    counter += 1
  	  end
      	
      if goldflemma==osloglemma
        olg = 1
  	    oslolemmaright += 1.0
      else 
        olg = 0
      end
      if goldfpos==oslogpos
        opg = 1
  	    osloposright += 1.0
      else 
        opg = 0
      end
      if olg == 1 and opg == 1
        og = 1
  	    osloright += 1.0
  	  else 
        og = 0	
      end
  
  	  moscowhasguess = 1	
	  me = 0
  	  mp = 0
	  posme = 0 
	  posmf = 0  #everything is wrong by default
  	  
	  if moscowguess.length == 0
  	    moscowhasguess = 0
  	    
  	    noguessmoscow += 1
  	    if og == 1
  	      noguessmoscowosloright += 1
  	    end
		if opg == 1
		  noguessmoscowosloposright += 1
		end
		
  	    if osloglemma != "FIXME"
  	      noguessmoscownofixme += 1
  	    end
  	  
  	  elsif moscowguess.length == 1
  	  
  	    moscowguess.each_value do |value| 
  	      if comparepos(value[1],goldfpos) 
            posme = 1
		    posmf = 1
			if comparelemma(value[0],goldflemma)
			  me = 1
  		      mp = 1
            end 
		  end
		end
      else
  	  
		flagpos = true
		flaglemma = true
  	    moscowguess.each_value do |value| #going through all guesses
		  if comparepos(value[1],goldfpos) #if there is a correct pos guess 
		    posmf = 1 #pos fuzzy match. Can be assigned 1 several times, no big deal
			
			if flagpos
			  posme = 1 #if there were no incorrect pos guesses, it's an exact match (i.e. all variants have the same POS)
			end
			
			if comparelemma(value[0],goldflemma) #check also lemma
              mp = 1 #lemma fuzzy match
			  if flaglemma
			    me = 1 #if there were no incorrect pos guesses, it's an exact match (i.e. all variants have the same lemma+POS, different morphology. I don't think there are such examples, but not impossible)
			  end
  	        else #if lemma guess is incorrect 
			  me = 0 #no exact match
			  flaglemma = false #prevent assigning 1 to me later
			end		
		  else
		    posme = 0  #no exact pos match
			me = 0
			flagpos = false #prevent assigning 1 to posme later
			flaglemma = false
		  end
  	    end
	  end
  	  moscowexact += me
  	  moscowfuzzy += mp
	  moscowpose += posme
	  moscowposf += posmf
  	
  	  if osloglemma == "FIXME"
        fixme = "fixme"
  	    fixmetotal += 1.0
  	    if me == 1
  	      fixmemoscowexact += 1.0
  	      fixmemoscowfuzzy += 1.0
 	    elsif mp == 1
  	      fixmemoscowfuzzy += 1.0
  	    end
  	  
  	    if moscowhasguess == 1
		  fixmeresult = fix_fixme(goldid,goldform,moscowguess,goldflemma,goldfpos,torotlemmas,torotlemmas_h,torotposes)
		  moscowfixesfixme += fixmeresult[0]
		  moscowattemptsfixme += fixmeresult[1]
  	      moscowfixesfixmepos += fixmeresult[2]
		  if opg == 0 and fixmeresult[2]== 1
		    posboost += 1
		  end
		  
		  fixmemoscowguess += 1.0
		  		  
  	    end
  	  else
        fixme = ""
  	    totalcertain += 1.0
        if opg == 1
  	      osloposrightcertain += 1.0 #no need to do that for lemma and right, they are 0 for FIXMEs anyway
  	    end
      end	
  	
  	  if og == 0
  	    if me == 1
  	      oslowrongmoscowexact += 1.0
  	      oslowrongmoscowfuzzy += 1.0
  	    elsif mp == 1
  	      oslowrongmoscowfuzzy += 1.0
  	    end
  	  end
  	 	
      comp_output.puts "#{goldid};#{osloid};#{og};#{fixme};#{moscowhasguess};#{me};#{mp}" 
    end
  end  
  comp_output2.puts ";lemma+POS;lemma+POS;POS;POS;out of"
  comp_output2.puts "metric;rate;hits;rate;hits;out of"
  #comp_output2.puts "Total;;#{total}"
  comp_output2.puts "Oslo does not have a FIXME;#{((total-fixmetotal)/total).round(3)};#{total-fixmetotal};#{((total-fixmetotal)/total).round(3)};#{total-fixmetotal};#{total}"
  comp_output2.puts "Moscow has a guess;#{((total-noguessmoscow)/total).round(3)};#{(total-noguessmoscow)};#{((total-noguessmoscow)/total).round(3)};#{(total-noguessmoscow)};#{total}"
  comp_output2.puts "Oslo accuracy;#{(osloright/total).round(3)};#{osloright};#{(osloposright/total).round(3)};#{osloposright};#{total}"
  comp_output2.puts "Oslo accuracy (when not a FIXME);#{(osloright/totalcertain).round(3)};#{osloright};#{(osloposrightcertain/totalcertain).round(3)};#{osloposrightcertain};#{totalcertain}"
  comp_output2.puts "Moscow accuracy (exact);#{(moscowexact/total).round(3)};#{moscowexact};#{(moscowpose/total).round(3)};#{moscowpose};#{total}"
  comp_output2.puts "Moscow accuracy (fuzzy);#{(moscowfuzzy/total).round(3)};#{moscowfuzzy};#{(moscowposf/total).round(3)};#{moscowposf};#{total}"
  comp_output2.puts "Moscow accuracy (exact, when there is a guess);#{(moscowexact/(total-noguessmoscow)).round(3)};#{moscowexact};#{(moscowpose/(total-noguessmoscow)).round(3)};#{moscowpose};#{(total-noguessmoscow)}"
  comp_output2.puts "Moscow accuracy (fuzzy, when there is a guess);#{(moscowfuzzy/(total-noguessmoscow)).round(3)};#{moscowfuzzy};#{(moscowposf/(total-noguessmoscow)).round(3)};#{moscowposf};#{(total-noguessmoscow)}"
  comp_output2.puts "Moscow accuracy (exact, when Oslo has a FIXME);#{(fixmemoscowexact/fixmetotal).round(3)};#{fixmemoscowexact};;;#{fixmetotal}"
  comp_output2.puts "Moscow accuracy (exact, when Oslo has a FIXME and Moscow has a guess);#{(fixmemoscowexact/fixmemoscowguess).round(3)};#{fixmemoscowexact};;;#{fixmemoscowguess}"
  comp_output2.puts "Oslo accuracy (when Moscow doesn't have a guess);#{(noguessmoscowosloright/(noguessmoscow)).round(3)};#{noguessmoscowosloright};#{(noguessmoscowosloposright/noguessmoscow).round(3)};#{noguessmoscowosloposright};#{noguessmoscow}"
  comp_output2.puts "Oslo accuracy (when Moscow doesn't have a guess and Oslo doesn't have a FIXME);#{(noguessmoscowosloright/(noguessmoscownofixme)).round(3)};#{noguessmoscowosloright};;;#{noguessmoscownofixme}"
  comp_output2.puts "Boost: Moscow fixes a FIXME;#{(moscowfixesfixme/moscowattemptsfixme).round(3)};#{moscowfixesfixme};#{(moscowfixesfixmepos/moscowattemptsfixme).round(3)};#{moscowfixesfixmepos};#{moscowattemptsfixme}"
  comp_output2.puts "After boost: Oslo accuracy;#{((osloright+moscowfixesfixme)/total).round(3)};#{osloright+moscowfixesfixme};#{((osloposright+posboost)/total).round(3)};#{osloposright+posboost};#{total}"
  comp_output2.puts "After boost: Oslo accuracy (when not a FIXME);#{((osloright+moscowfixesfixme)/(totalcertain+moscowattemptsfixme)).round(3)};#{(osloright+moscowfixesfixme)};#{((osloposrightcertain+posboost)/(totalcertain+moscowattemptsfixme)).round(3)};#{osloposrightcertain+posboost};#{(totalcertain+moscowattemptsfixme)}"
  f.close
  comp_output.close
  comp_output2.close
end

def fix_fixme(goldid,goldform,moscowguess,goldlemma,goldpos,torotlemmas,torotlemmas_h,torotposes)
  fixed = 0
  found = false
  attempt = 0
  posfixed = 0
  lemmaguess = ""
  posguess = ""
  moscowguess.each_value do |value|
    moscowlemma = value[0]
	moscowpos = value[1]
    ind = torotlemmas_h.index(harmonize_moscow(moscowlemma))
	if ind
	  if comparepos(moscowpos,torotposes[ind]) 
        lemmaguess = torotlemmas[ind]  
	    posguess = torotposes[ind]
	    found = true
		break
	  end
    end
  end
  
  if found
    attempt = 1  
    if posguess == goldpos 
	  posfixed = 1
      if lemmaguess == goldlemma
  	    fixed = 1
	  end
    end
	@guessfile.puts "#{goldid};#{goldform};#{lemmaguess};#{posguess};#{goldlemma};#{goldpos};#{fixed}" 
  end
  return [fixed,attempt,posfixed]
end

def gettorotdata
  torotlemmas = []
  torotlemmas_h = []
  torotposes = []
  f = File.open("torotlemmata.csv","r:utf-8")
  f.each_line do |line|
    line1 = line.strip
	if line1 != "---"
	  line2 = line1.split(";")
	  torotlemmas << line2[0]
	  torotlemmas_h << harmonize_oslo(line2[0])
	  torotposes << line2[1]
	end
  end
  f.close
  return [torotlemmas,torotlemmas_h,torotposes]
end

align(ver,norm,moscowlemmanorm)
torotdata = gettorotdata
@guessfile = File.open("guess_fixme#{ver}.csv","w")
@guessfile.puts "gold id;gold form;lemma guess;pos guess;gold lemma;gold pos;correct"
compare(ver,norm,torotdata[0],torotdata[1],torotdata[2])
@guessfile.close