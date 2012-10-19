#!/usr/bin/env python

import os, os.path, stat, sys
homeDir = os.environ[ 'HOME' ]

def walk_dirs( top_path, action, only_these_dirs=None, except_these_dirs=None, only_these_files=None, except_these_files=None):
    """
    walk_dirs( path_to_search_into, callback_to_call_on_each_file,
    iteratable_only_these_dirs=None, iteratable_except_these_dirs=None,
    tuple_only_these_file_endings=None, tuple_except_these_file_ending=None )
    """
    top_path = os.path.abspath( top_path )
    files = os.listdir( top_path )

    for name in files:
        name = os.path.join( top_path, name )
        try:
            details = os.stat( name )
        except OSError, why:
            sys.stderr.write( why.filename + ': ' + why.strerror +'\n' )

        if stat.S_ISDIR( details.st_mode ):
            # Note that this is the only case where action() is called with a directory name
            if only_these_dirs and os.path.basename( name ) in only_these_dirs:
                action( name, details)
                # don't descend further; action() has handled this dir
                continue
            elif except_these_dirs and os.path.basename( name ) in except_these_dirs:
                continue
            walk_dirs( name, action, only_these_dirs, except_these_dirs, only_these_files, except_these_files )
        # process files only if we are not looking for directories alone
        if not only_these_dirs and stat.S_ISREG( details.st_mode ):
            if only_these_files and not os.path.basename( name ).endswith( only_these_files ):
                continue
            elif except_these_files and os.path.basename( name ).endswith( except_these_files ):
                continue
            # home_path = os.path.join( homeDir, name[len(g_repo_dir)+1:] )
            action( name, details )

