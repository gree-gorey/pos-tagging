#-*- coding: utf-8 -*-
import re
import codecs

def hawlik_low(word):
    isodd = False
    word = list(word)
    vowels = list(u'уеыаоэяию')
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


def indent(goldlemma, unilemma):
    goldlemma = letterchange(goldlemma)
    goldlemma = hawlik_low(goldlemma)
    unilemma = letterchange(unilemma)
    if unilemma == goldlemma:
        return True
    return False

word = u'сьрдьце'
print hawlik_low(word)
word = u'отьць'
print hawlik_low(word)
word = u'отьца'
print hawlik_low(word)
