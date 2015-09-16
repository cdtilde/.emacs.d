sudo rm /usr/local/bin/emacs
sudo rm /usr/local/bin/emacsclient
sudo rm /usr/local/bin/ctags
sudo rm /usr/local/bin/etags
sudo rm /usr/local/bin/grep-changelog
sudo rm /usr/local/bin/ebrowse

cd $1
cd Contents/MacOS/bin

sudo ln -s $1Contents/MacOS/bin/ctags /usr/local/bin/ctags
sudo ln -s $1Contents/MacOS/bin/etags /usr/local/bin/etags
sudo ln -s $1Contents/MacOS/bin/emacsclient /usr/local/bin/emacsclient
sudo ln -s $1Contents/MacOS/bin/ebrowse /usr/local/bin/ebrowse
sudo ln -s $1Contents/MacOS/bin/grep-changelog /usr/local/bin/grep-changelog

sudo echo "#!/bin/bash" > /usr/local/bin/emacs
sudo echo "$1"'Contents/MacOS/Emacs -nw "$@"' >> /usr/local/bin/emacs
sudo chmod +x /usr/local/bin/emacs



