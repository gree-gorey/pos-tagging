# -*- coding:utf-8 -*-

import os
import re
import time
import codecs
from lxml import etree

__author__ = 'gree-gorey'


RE_NOUN = re.compile(u'NUMB(.)\|GEND(.)\|CASE(.)', re.U)

RE_VERB = re.compile(u'(?:PERS(.))?\|?(?:NUMB(.))?\|?(?:TENS(.))?\|?(?:MOOD(.))?\|?(?:VOIC(.))?\|?(?:GEND(.))?\|?'
                     u'(?:CASE(.))?\|?(?:STRE(.))?\|?', re.U)

RE_ADJECTIVE = re.compile(u'NUMB(.)\|GEND(.)\|CASE(.)\|DEGR(.)\|STRE(.)', re.U)

RE_N_PRO = re.compile(u'(N-PRO),?((?:sg)|(?:du)|(?:pl))?,?((?:acc)|(?:nom)|(?:loc)|(?:voc)|(?:ins)|(?:dat)|(?:gen))?',
                      re.U)

RE_A_PRO = re.compile(u'(A-PRO),?((?:sg)|(?:du)|(?:pl))?,?(m|f|n)?,?((?:acc)|(?:nom)|(?:loc)|(?:voc)|(?:ins)|(?:dat)|'
                      u'(?:gen))?,?(anim)?', re.U)

number = {u's': u'sg',
          u'd': u'du',
          u'p': u'pl',
          None: None}

case = {u'a': u'acc',
        u'n': u'nom',
        u'l': u'loc',
        u'v': u'voc',
        u'i': u'ins',
        u'd': u'dat',
        u'g': u'gen',
        None: None}

person = {u'1': u'1p',
          u'2': u'2p',
          u'3': u'3p',
          None: None}

mood = {u'i': u'indic',
        u'm': u'imper',
        u'n': u'inf',
        None: None,
        u'p': None}

tense = {u's': u'perf',
         u'p': u'praes',
         u'i': u'imperf',
         u'a': u'aor',
         u'f': u'analyt',
         None: None,
         u'u': None}

voice = {u'a': u'act',
         u'p': u'pass',
         u'm': u'med',
         None: None}

fullness = {u's': u'brev',
            u'w': None,
            u't': None,
            None: None}


class Text:
    def __init__(self):
        self.words = []


class Word:
    def __init__(self):
        self.content = None
        self.analyses = []


class Analysis:
    def __init__(self):
        self.pos = None
        self.lemma = None
        self.morphology = None


class Noun:
    def __init__(self):
        self.gender = None
        self.animacy = None
        self.proper_name = None
        self.number = None
        self.case = None

    def get_features(self, features):
        morphology = re.search(RE_NOUN, features)
        self.number = number[morphology.group(1)]
        self.gender = morphology.group(2)
        self.case = case[morphology.group(3)]


class Verb:
    def __init__(self):
        self.aspect = None
        self.transitivity = None
        self.voice = None
        self.analyticity = None
        self.mood = None
        self.tense = None
        self.number = None
        self.person = None

    def get_features(self, features):
        morphology = re.search(RE_VERB, features)
        self.person = person[morphology.group(1)]
        self.number = number[morphology.group(2)]
        self.tense = tense[morphology.group(3)]
        self.mood = mood[morphology.group(4)]
        self.voice = voice[morphology.group(5)]


class Adjective:
    def __init__(self):
        self.number = None
        self.gender = None
        self.case = None
        self.fullness = None

    def get_features(self, features):
        if features != u'INFLn':
            morphology = re.search(RE_ADJECTIVE, features)
            self.number = number[morphology.group(1)]
            self.gender = morphology.group(2)
            self.case = case[morphology.group(3)]
            self.fullness = fullness[morphology.group(5)]


class Pronoun:
    def __init__(self):
        self.number = None
        self.case = None


class AdjectivalPronoun:
    def __init__(self):
        self.number = None
        self.gender = None
        self.case = None


def read_files(path, extension):
    for root, dirs, files in os.walk(path):
        for filename in files:
            result = None
            open_name = path + filename
            with codecs.open(open_name, u'r', u'utf-8') as f:
                if extension == u'xml':
                    result = etree.parse(f)
                elif extension == u'conll':
                    result = f.readlines()
            yield result, filename


def parse_conll(lines, filename, path):
    text = Text()
    for line in lines:
        if len(line) > 1:
            new_word = Word()
            text.words.append(new_word)
            line = line.split(u'\t')
            new_word.content = line[1]
            new_analysis = Analysis()
            new_word.analyses.append(new_analysis)
            new_analysis.lemma = line[2]
            new_analysis.pos = line[3]
            features = line[5]
            if new_analysis.pos == u'N':
                morphology = Noun()
                morphology.get_features(features)
                new_analysis.morphology = morphology
            elif new_analysis.pos == u'V':
                morphology = Verb()
                morphology.get_features(features)
                new_analysis.morphology = morphology
            elif new_analysis.pos == u'A':
                morphology = Adjective()
                morphology.get_features(features)
                new_analysis.morphology = morphology


def main():
    t1 = time.time()

    for conll, filename in read_files(u'./gold_from/', u'conll'):
        parse_conll(conll, filename, u'./gold_into/')

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()
