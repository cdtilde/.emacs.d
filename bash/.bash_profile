if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

###
##
# Your previous /Users/ezachri/.bash_profile file was backed up as /Users/ezachri/.bash_profile.macports-saved_2014-07-15_at_12:12:18
##

# MacPorts Installer addition on 2014-07-15_at_12:12:18: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
export JAVA_HOME=$(/usr/libexec/java_home)
