#-*- coding: utf-8 -*-
import re
import codecs

def samelettter(word):
    word = word.replace(u'нн', u'н')
    word = word.replace(u'сс', u'с')
    word = word.replace(u'жж', u'ж')
    word = word.replace(u'зз', u'з')
    word = word.replace(u'вв', u'в')
    word = word.replace(u'тт', u'т')
    word = word.replace(u'лл', u'л')
    word = word.replace(u'дд', u'д')
    return word

def hawlik_low(word):
    isodd = False
    word = list(word)
    vowels = list(u'уеыаѣоэяию')
    for i in xrange(len(word)):
        li = len(word) - i -1
        if word[li] in vowels:
            isodd = False
        if word[li] == u'ь' or word[li] == u'ъ':
            if isodd == True:
                word[li] = word[li].replace(u'ь', u'е')
                word[li] = word[li].replace(u'ъ', u'о')
                isodd = False
            else:
                isodd = True
                word[li] = u''
    word = u''.join(word)
    return word


def letterchange(word):
    newword = word
    newword = newword.replace(u'i', u'и')
    newword = newword.replace(u'і', u'и')
    newword = newword.replace(u'ѡ', u'о')
    newword = newword.replace(u'є', u'e')
    newword = newword.replace(u'́', u'')
    newword = newword.replace(u'́', u'')
    newword = newword.replace(u'ѵ', u'и')
    newword = newword.replace(u'̂', u'')
    newword = newword.replace(u'ѻ', u'о')
    newword = newword.replace(u'ѳ', u'ф')
    newword = newword.replace(u'ѯ', u'кс')
    newword = newword.replace(u'ѱ', u'пс')
    newword = newword.replace(u'ѕ', u'з')
    newword = newword.replace(u'ѣ', u'е')
    newword = newword.replace(u'ꙋ', u'у')
    newword = newword.replace(u'ꙗ', u'я')
    newword = newword.replace(u'ѧ', u'я')
    return newword

def inter_new(word):
    newword = re.sub(u'([цкнгшщзхфвпрлджчсмтб])(ь|ъ)([цкнгшщзхфвпрлджчсмтб])', u'\\1\\3', word)
    if newword[-1] == u'ь' or newword[-1] == u'ъ':
        newword = newword[:-1]
    return newword


def modernize_oslo(word2):
  word2 = word2.replace(u"ѣ", u"е")
  word2 = word2.replace(u"кы", u"ки")
  word2 = word2.replace(u"гы", u"ги")
  word2 = word2.replace(u"хы", u"хи")
  return word2 


def indent(goldlemma, unilemma):
    goldlemma = letterchange(goldlemma)
    goldlemma = hawlik_low(goldlemma)
    goldlemma = samelettter(goldlemma)
    goldlemma = modernize_oslo(goldlemma)
    unilemma = letterchange(unilemma)
    unilemma = inter_new(unilemma)
    unilemma = samelettter(unilemma)
    if unilemma == goldlemma:
        return True
    return False

word = u'сьрдьце'
print hawlik_low(word)
word = u'отьць'
print hawlik_low(word)
word = u'отьца'
print hawlik_low(word)
print indent(u'отьць', u'отець')
