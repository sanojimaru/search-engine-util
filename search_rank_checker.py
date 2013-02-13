# -*- coding: utf-8 -*-
import urllib

# テスト用URL
# METAタグでcharset指定してなくてもちゃんと文字コード判別できるかもテスト
urls = [
    'http://python-history-jp.blogspot.com/',               # UTF-8
    'http://iblinux.rios.co.jp/PyJdoc/lib-j/',              # EUC-JP
    'http://osksn2.hep.sci.osaka-u.ac.jp/~taku/osx/python/encoding.html', # ISO-2022-JP
    'http://www.atmarkit.co.jp/news/200812/04/python.html', # Shift_JIS
    'http://pyunit.sourceforge.net/pyunit_ja.html',         # EUC-JP, w/o META
    'http://www.f7.ems.okayama-u.ac.jp/~yan/python/',       # ISO-2022-JP, w/o META
    'http://weyk.com/weyk/etc/OpenRPG.html', # Shift_JIS, w/o META
    ]


if __name__ == '__main__':

    # 各サイトの文字コードを判別
    detected = []
    for url in urls:
        data = ''.join(urllib.urlopen(url).readlines())
        guess = chardet.detect(data)
        result = dict(url=url,data=data,**guess)
        detected.append(result)

    # 各サイトごとにaタグの文字とリンク先を引っ張ってくる
    for p in detected:
        print '%s -> %s (%s)' % (p['url'], p['encoding'], p['confidence'])
        unicoded = p['data'].decode(p['encoding'])  # デコード
        d = pq(unicoded)
        for link in d.find('a'):  # 見つけたaタグごとにタイトルとURLを抜き出す
            link_title = pq(link).text()
            link_url = pq(link).attr.href
            print '    %s => %s' % (link_title, link_url)
