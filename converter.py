# -*- coding:utf-8 -*-

import os
import re
import time
import codecs
import pickle
from lxml import etree

__author__ = 'gree-gorey'


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
            new_analysis.pos = analysis.get(u'gr')
            # print new_analysis.lemma, new_analysis.pos

    write_name = path + filename.replace(u'xml', u'p')
    with codecs.open(write_name, u'w', u'utf-8') as w:
        pickle.dump(text, w)


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
            # print new_analysis.lemma, new_analysis.pos

    write_name = path + filename.replace(u'conll', u'p')
    with codecs.open(write_name, u'w', u'utf-8') as w:
        pickle.dump(text, w)


def main():
    t1 = time.time()

    for xml_tree, filename in read_files(u'./tested_from/', u'xml'):
        parse_xml(xml_tree, filename, u'./tested_into/')

    for conll, filename in read_files(u'./gold_from/', u'conll'):
        parse_conll(conll, filename, u'./gold_into/')

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()
