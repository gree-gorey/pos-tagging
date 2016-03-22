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

word = u'сьрдьце'
print hawlik_low(word)
word = u'отьць'
print hawlik_low(word)
word = u'отьца'
print hawlik_low(word)