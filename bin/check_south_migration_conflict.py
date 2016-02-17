#!/usr/bin/env python
import os
import re
import sys

from collections import defaultdict

g_migration_pat = re.compile(b'(^\d{4})_.*\.py$')
g_historic_conflicts = set([
    '0006_auto__add_field_patientactivationrecord_created__add_field_patientacti.py',
    '0006_auto__add_field_patientreport_created__add_field_patientreport_updated.py',
    '0014_auto__add_field_agency_item_payroll_rate_number_care_logs__add_field_a.py',
    '0014_remove_agency_other_payroll_company.py',
    '0002_auto__add_ub04revenuecode.py',
])

def do_check(start_dir='.', skip_historic_conflicts=True):
    for root, dirs, files in os.walk(start_dir):
        if not root.endswith('migrations'):
            continue
        migs = defaultdict(list)
        for f in files:
            m = g_migration_pat.match(f)
            if m:
                if skip_historic_conflicts and f in g_historic_conflicts:
                    continue
                migs[m.groups()[0]].append(f)
        for mig_n, mig_l in filter(lambda i: len(i[1]) > 1, migs.iteritems()):
            print("Collision in: %s for %s:\n\t%s" % (root, mig_n, mig_l))


if __name__ == '__main__':
    directorys = ['.']
    skip_historic_conflicts = True
    args = sys.argv[1:]
    if args and args[0] == '-h':
        print(
"""Usage: {} [-a] [dirs_to_look_into]
    -a Show historic conflicts that will never be fixed and are just noise
    dirs_to_look_into one or more space separated dirs to look into; Defaults to .""".format(sys.argv[0]))
        sys.exit(0)
    if args and args[0] == '-a':
        skip_historic_conflicts = False
        args = args[1:]
    if args:
        directorys = args

    for directory in directorys:
        do_check(directory, skip_historic_conflicts)
