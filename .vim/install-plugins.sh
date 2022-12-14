mkdir -p ~/.vim/
mkdir -p ~/.vim/{autoload,bundle}
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim || exit 1
cd ~/.vim/
git init

git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
#git submodule add https://github.com/msanders/snipmate.vim.git bundle/snipmate
git submodule add https://github.com/tpope/vim-git.git bundle/git
#git submodule add https://github.com/sontek/minibufexpl.vim.git bundle/minibufexpl
# not working
#git submodule add https://github.com/wincent/Command-T.git bundle/command-t
#git submodule add https://github.com/mitechie/pyflakes-pathogen.git bundle/pyflakes-pathogen
#git submodule add https://github.com/mileszs/ack.vim.git bundle/ack
#git submodule add https://github.com/sjl/gundo.vim.git bundle/gundo
#git submodule add https://github.com/fs111/pydoc.vim.git bundle/pydoc
#git submodule add https://github.com/vim-scripts/pep8.git bundle/pep8
#git submodule add https://github.com/alfredodeza/pytest.vim.git bundle/py.test
#git submodule add https://github.com/reinh/vim-makegreen bundle/makegreen
#git submodule add https://github.com/vim-scripts/TaskList.vim.git bundle/tasklist
#git submodule add https://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
# not working
#git submodule add https://github.com/sontek/rope-vim.git bundle/ropevim
git submodule add https://github.com/majutsushi/tagbar.git bundle/tagbar
git submodule add https://github.com/ervandew/supertab.git bundle/supertab
#git submodule add https://github.com/klen/python-mode.git bundle/python-mode
git submodule add git://github.com/tpope/vim-surround.git bundle/vim-surround
git submodule add https://github.com/jelera/vim-javascript-syntax.git bundle/vim-javascript-syntax
git submodule add https://github.com/pangloss/vim-javascript.git bundle/vim-javascript
git submodule add https://github.com/mxw/vim-jsx.git bundle/vim-jsx
#git submodule add https://github.com/nathanaelkane/vim-indent-guides.git bundle/indent-guides
git submodule add https://github.com/scrooloose/syntastic.git bundle/syntastic
git submodule add https://github.com/ekalinin/Dockerfile.vim.git bundle/Dockerfile
#git submodule add https://github.com/tomlion/vim-solidity.git bundle/vim-solidity
git submodule add https://github.com/editorconfig/editorconfig-vim.git bundle/editorconfig
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update --remote

# XXX to remove a submodule
# git submodule deinit asubmodule
# git rm asubmodule
# git rm --cached asubmodule
