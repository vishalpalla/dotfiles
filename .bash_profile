# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\u@\h:\w [\t]\`parse_git_branch\` "

#Functions
jumphost_login()
{
	USERNAME=vishal
	if [[ ! -z $2 ]];
	then
		USERNAME=$2
	fi
	echo "Logging in to $USERNAME@$1"
	ssh -i ~/.ssh/jumphost $USERNAME@$1
}

jumphost_scp()
{
	USERNAME=vishal
	if [[ ! -z $3 ]];
        then    
                USERNAME=$3
        fi
	echo "Copying $1 to $USERNAME@$2:/tmp/"
	scp -i ~/.ssh/jumphost $1 $USERNAME@$2:/tmp/
}

code()
{
	cd ~/Bidgely/code/$1
}

#Shortcuts
mkcd='mkdir $1 && cd $1'

#Jumphost
alias jumphost-dev='jumphost_login jumphost-dev.bidgely.com'
alias jumphost-na='jumphost_login jumphost-prodna.bidgely.com'
alias jumphost-eu='jumphost_login jumphost-eu vishalp'

#Code Navigation
alias pingpong='code pingpong'
alias carrom='code carrom'
alias deployment='code deployment'

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gcor='git checkout release'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'

# ----------------------
# Git Functions
# ----------------------
# Git log find by commit message
function glf() { git log --all --grep="$1"; }

#Environment Variables
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export HISTSIZE=10000000
export HISTFILESIZE=10000000

#Hadoop Path
export HADOOP_HOME=/Users/vishalpalla/lab/hadoop-2.9.2
export HADOOP_CONF_DIR=/Users/vishalpalla/lab/hadoop-conf/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

#Spark Path
export SPARK_HOME=/Users/vishalpalla/lab/spark-2.4.5-bin-hadoop2.7
export PATH=$PATH:$SPARK_HOME/bin
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
export PYSPARK_PYTHON=python3
export PATH=$PATH:$SPARK_HOME

#Other Path
export PATH="$PATH:/usr/local/opt/bison/bin"
export PATH=$PATH:/Users/vishalpalla/Downloads/dsc-cassandra-3.0.7/bin
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
