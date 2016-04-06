# -*- coding:utf-8 -*-

from extract_conll import *

__author__ = 'gree-gorey'


def write_adjacent():
    with open(u'./gold_into/gold.p', u'r') as f:
        gold_text = pickle.load(f)

    with open(u'./tested_into/tested.p', u'r') as f:
        tested_text = pickle.load(f)

    print len(gold_text.words)
    print len(tested_text.words)

    write_name = u'./result/adjacent.csv'
    # with codecs.open(write_name, u'w', u'utf-8') as w:

        # for i, word in enumerate(gold_text.words):
        #     # w.write(word.content + u'\n')
        #     # print word.content
        #     # print word.analyses[0].lemma
        #     # print word.analyses[0].get_tag()
        #     if word.index in tested_text.words:
        #         # print word.content, tested_text.words[word.index].content
        #         first_line = str(word.index) + u',' + word.content + u','\
        #                      + tested_text.words[word.index].analyses[0].get_tag() + u',' + word.analyses[0].get_tag()\
        #                      + u'\n'
        #         w.write(first_line)
        #         for analysis in tested_text.words[word.index].analyses[1::]:
        #             line = u',,' + analysis.get_tag() + u',\n'
        #             w.write(line)
        #         # print word.analyses[0].get_tag(), tested_text.words[word.index].analyses[0].get_tag()
        #
        #         # if i > 50:
        #         #     break


def main():
    t1 = time.time()

    write_adjacent()

    t2 = time.time()
    print t2 - t1


if __name__ == '__main__':
    main()