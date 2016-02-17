#!/usr/bin/env python

import sys
import re
import os

g_normal_form_separator = os.environ.get('MYACK_NORMAL_FORM_SEPARATOR', '_')

def normalize(token):
    camelcase_re = re.compile(r'[a-z]+(?:[A-Z][a-z]+)+')
    def is_html_token(token):
        return g_normal_form_separator in token

    def is_js_token(token):
        if not token:
            return False
        # normal angularjs token is lowercase
        if 'a' <= token[0] <= 'z':
            return camelcase_re.match(token)
        return False

    normal_token = token
    if is_html_token(token):
        parts = token.split(g_normal_form_separator)
        cParts = [p.capitalize() for p in parts[1:]]
        normal_token = parts[0] + ''.join(cParts)
    elif is_js_token(token):
        camelparts = []
        start = 0
        i = 0
        while i < len(token):
            if 'A' <= token[i] <= 'Z':
                camelparts.append(token[start:i])
                start = i
            i += 1
        camelparts.append(token[start:])
        camelparts = [p.lower() for p in camelparts]
        normal_token = g_normal_form_separator.join(camelparts)

    return normal_token

if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)
    normal_from = normalize(sys.argv[1])
    sys.stdout.write(normal_from + '\n')
