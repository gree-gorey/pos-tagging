# -*- coding:utf-8 -*-

import os
import re
import time
import codecs
import pickle
from lxml import etree

__author__ = 'gree-gorey'


RE_NOUN = re.compile(u'(N),?(m|f|n)?,?((?:anim)|(?:inan))?,?(persn)?,?((?:sg)|(?:du)|(?:pl))?,?((?:acc)|(?:nom)|'
                     u'(?:loc)|(?:voc)|(?:ins)|(?:dat)|(?:gen))?', re.U)

RE_VERB = re.compile(u'(V),?((?:ipf)|(?:pf))?,?((?:intr)|(?:tr))?,?(med)?,?(analyt)?,?((?:indic)|(?:imper)|(?:inf))?,?'
                     u'((?:aor)|(?:perf)|(?:praes)|(?:imperf))?,?((?:sg)|(?:du)|(?:pl))?,((?:1p)|(?:2p)|(?:3p))?', re.U)


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
        self.gender = morphology.group(2)
        self.animacy = morphology.group(3)
        self.proper_name = morphology.group(4)
        self.number = morphology.group(5)
        self.case = morphology.group(6)


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
        self.aspect = morphology.group(2)
        self.transitivity = morphology.group(3)
        self.voice = morphology.group(4)
        self.analyticity = morphology.group(5)
        self.mood = morphology.group(6)
        self.tense = morphology.group(7)
        self.number = morphology.group(8)
        self.person = morphology.group(9)


class Adjective:
    def __init__(self):
        self.number = None
        self.gender = None
        self.case = None
        self.fullness = None


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
        # print line
        if len(line) > 1:
            new_word = Word()
            text.words.append(new_word)
            line = line.split(u'\t')
            new_word.content = line[1]
            new_analysis = Analysis()
            new_word.analyses.append(new_analysis)
            new_analysis.lemma = line[2]
            new_analysis.pos = line[3]


def main():
    t1 = time.time()

    for conll, filename in read_files(u'./gold_from/', u'conll'):
        parse_conll(conll, filename, u'./gold_into/')

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()
