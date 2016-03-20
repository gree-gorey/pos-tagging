# -*- coding:utf-8 -*-

import time
import codecs
import pickle

__author__ = 'gree-gorey'


def write_adjacent():
    # with open(u'./gold_into/gold.p', u'r') as f:
    #     gold_text = pickle.load(f)

    with open(u'./tested_into/tested.p', u'r') as f:
        tested_text = pickle.load(f)

    write_name = u'./result/adjacent.csv'
    with codecs.open(write_name, u'w', u'utf-8') as w:
        for word in gold_text.words:
            if word.index in tested_text.words:
                print word.index, word.content, tested_text.words[word.index].content


def main():
    t1 = time.time()

    write_adjacent()

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()