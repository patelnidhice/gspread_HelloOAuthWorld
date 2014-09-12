#!/bin/bash
#
#    This script will prepare a virtual execution environment for Python.
#    To run this script:
#    $ sudo ./prepare_virtualenv.sh
#    
# Root check
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#
YOU=$(logname)
# Make a temorary directory for installers
mkdir -p ~/deleteMe
#
# Step into it
pushd ~/deleteMe
#
# Install curl if it isn't present
apt-get install curl
#
# Use  curl to the pip installer toolkit
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py
#
# Install pip
easy_install pip
#
# Use pip to install the virtual environment stuff
pip install virtualenv
pip install virtualenvwrapper
#
# Get out of the temporary directory
popd
#
# Delete the temporary directory
rm -fr ~/deleteMe
#
# Create a default directory for virtualized projects
export WORKON_HOME=~/.python_virtual_environments
mkdir -p $WORKON_HOME
chown ${YOU}:${YOU} ~/.python_virtual_environments
#
# If not done before, put the control commands int the users execution environment
hasMkvenv=$(cat ~/.bashrc | grep -c "mkvirtualenv")
hasWrpper=$(cat ~/.bashrc | grep -c "virtualenvwrapper.sh")
hasPipCmp=$(cat ~/.bashrc | grep -c "pip_completion")
#
if [ ${hasMkvenv} -lt 1 ] && [ ${hasWrpper} -lt 1 ] && [ ${hasPipCmp} -lt 1 ]; then
  pip completion --bash >> ~/.bashrc
  echo "export WORKON_HOME=$WORKON_HOME" >> ~/.bashrc
  echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
  echo "alias mkvirtualenv='mkvirtualenv --no-site-packages'" >> ~/.bashrc
  echo "export PIP_REQUIRE_VIRTUALENV=true" >> ~/.bashrc
  echo "export PIP_VIRTUALENV_BASE=$WORKON_HOME" >> ~/.bashrc
  echo "#" >> ~/.bashrc
  echo "" >> ~/.bashrc
else
  echo "~/.bashrc untouched"
fi
#
echo " *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  "
echo " * "
echo " *   The changes made will not be useable until you run this command : "
echo " * "
echo "source ~/.bashrc"
echo " * "
echo "These are typical commands for managing virtual environments."
echo "  mkvirtualenv test_dir"
echo "  python -c \"import sys; print sys.path\""
echo "  deactivate"
echo "  workon test_dir"
echo "  rmvirtualenv test_dir"
echo "  "
echo "  "

