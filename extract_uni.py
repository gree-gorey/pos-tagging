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


def parse_xml(tree, filename, path):
    text = Text()
    words = tree.xpath('/xml/w')
    for word in words:
        new_word = Word()
        text.words.append(new_word)
        analyses = word.xpath('./ana')
        content = analyses[-1].tail
        content = re.sub(u' +', u'', content, re.U)
        content = re.sub(u'\r\n+', u'', content, re.U)
        content = re.sub(u'\n+', u'', content, re.U)
        new_word.content = content
        for analysis in analyses:
            new_analysis = Analysis()
            new_word.analyses.append(new_analysis)
            new_analysis.lemma = analysis.get(u'lex')
            features = analysis.get(u'gr')
            new_analysis.pos = features.split(u',')[0]
            if new_analysis.pos == u'N':
                morphology = Noun()
                morphology.get_features(features)
                new_analysis.morphology = morphology
            elif new_analysis.pos == u'V':
                morphology = Verb()
                morphology.get_features(features)
                new_analysis.morphology = morphology
            # print new_analysis.lemma, new_analysis.pos

    # write_name = path + filename.replace(u'xml', u'p')
    # with codecs.open(write_name, u'w', u'utf-8') as w:
    #     pickle.dump(text, w)


def main():
    t1 = time.time()

    for xml_tree, filename in read_files(u'./tested_from/', u'xml'):
        parse_xml(xml_tree, filename, u'./tested_into/')

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()
