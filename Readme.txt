Git学习笔记

学习记录：

	https://git-scm.com/docs

	https://www.runoob.com/manual/github-git-cheat-sheet.pdf

	https://www.runoob.com/git/git-tutorial.html

解释区
	
	Git 与 SVN 区别点：

		1、Git 是分布式的，SVN 不是：这是 Git 和其它非分布式的版本控制系统，例如 SVN，CVS 等，最核心的区别。

		2、Git 把内容按元数据方式存储，而 SVN 是按文件：所有的资源控制系统都是把文件的元信息隐藏在一个类似 .svn、.cvs 等的文件夹里。

		3、Git 分支和 SVN 的分支不同：分支在 SVN 中一点都不特别，其实它就是版本库中的另外一个目录。

		4、Git 没有一个全局的版本号，而 SVN 有：目前为止这是跟 SVN 相比 Git 缺少的最大的一个特征。

		5、Git 的内容完整性要优于 SVN：Git 的内容存储使用的是 SHA-1 哈希算法。这能确保代码内容的完整性，确保在遇到磁盘故障和网络问题时降低对版本库的破坏。

	Git 的工作就是创建和保存你的项目的快照及与之后的快照进行对比。
	
	master一般指主动发起请求的一方

	worker顾名思义工作者或任务对象

	GIT使用SHA1算法，40个十六进制字符

	VCS，版本控制系统。版本控制系统（version control system）,是一种记录一个或若干文件内容变化，以便将来查阅特定版本修订情况的系统。版本控制系统不仅可以应用于软件源代码的文本文件，而且可以对任何类型的文件进行版本控制
	GIT内只有三种状态：已提交（committed），已修改（modified）和已暂存（staged）。
	已提交表示该文件已经被安全地保存在本地数据库中了；
	已修改表示修改了某个文件，但还没有提交保存；
	已暂存表示把已修改的文件放在下次提交时要保存的清单中。

安装区

	git clone 出来的，.git
	git clone --bare, 新建目录本身

	安装依赖(curl, zlib, openssl, expat, libiconv)
	$ yum install curl-devel expat-devel gettext-devel\openssl-devel zlib-devel
	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext\libz-dev libssl-dev

	源代码
	http://git-scm.com/download

	编译并安装
	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

	把Git项目仓库克隆到本地，以便日后随时更新：
	$ git clone git://git.kernel.org/pub/scm/git/git.git

	Windows上安装
	http://msysgit.github.com/

配置区

	$ git config
	
	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com
	
	如果用了 --global 选项，那么更改的配置文件就是位于你用户主目录下的那个，以后你所有的项目都会默认使用这里配置的用户信息。
	如果要在某个特定的项目中使用其他名字或者电邮，只要去掉 --global 选项重新配置即可，新的设定保存在当前项目的 .git/config 文件里。
	
	需要输入一些额外消息的时候
	$ git config --global core.editor emacs
	
	在解决合并冲突时使用哪种差异分析工具
	$ git config --global merge.tool vimdiff
	
	查看配置信息
	$ git config --list
	
	查看已配置的用户名
	$ git config user.name

	设置远端仓库地址
	git remote set-url origin 你的远端地址 
	
	
	
获取帮助

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>
	
仓库

	在工作目录中初始化新仓库
	要对现有的某个项目开始用Git管理，只需到此项目所在的目录，执行：
	$ git init
	
	使用我们指定目录作为Git仓库。
	$ git init newrepo
	
	git add 命令可将该文件添加到缓存| 快照|暂存区
	如果当前目录下有几个文件想要纳入版本控制，需要先用 git add 命令告诉 Git 开始对这些文件进行跟踪，然后提交：
	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'
	
	
	克隆仓库的命令格式为 git clone [url]
	我们使用 git clone 从现有 Git 仓库中拷贝项目（类似 svn checkout）。

	克隆仓库的命令格式为：
	git clone <repo>
	在当前目录下创建一个名为grit的目录
	$ git clone git://github.com/schacon/grit.git
	
	
	如果我们需要克隆到指定的目录，可以使用以下命令格式：
	git clone <repo> <directory>
	新建的目录成了 mygrit，其他的都和上边的一样。
	$ git clone git://github.com/schacon/grit.git mygrit
	
	repo:Git 仓库。
	directory:本地目录。
	
	
	git clone 时，可以所用不同的协议，包括 ssh, git, https 等，其中最常用的是 ssh，因为速度较快，还可以配置公钥免输入密码。各种写法如下：

	git clone git@github.com:fsliurujie/test.git         --SSH协议
	git clone git://github.com/fsliurujie/test.git          --GIT协议
	git clone https://github.com/fsliurujie/test.git      --HTTPS协议
	
当执行

	当执行提交操作（git commit）时，暂存区的目录树写到版本库（对象库）中，master 分支会做相应的更新。即 master 指向的目录树就是提交时暂存区的目录树。
	每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较
	$ git commit
	
	当执行 "git reset HEAD" 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。
	$ git reset HEAD
	
	当执行 "git rm --cached <file>" 命令时，会直接从暂存区删除文件，工作区则不做出改变。
	$ git rm --cached <file>
	
	当执行 "git checkout ." 或者 "git checkout -- <file>" 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区的改动。
	$ git checkout .

	当执行 "git checkout HEAD ." 或者 "git checkout HEAD <file>" 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动。
	$ git checkout HEAD .


提交修改

	以查看在你上次提交之后是否有修改
	$ git status
	
	$ git status -s
	
		Changes to be committed 已经提交到缓存| 快照
		AM MM M A
		出现红色即还未提交
		出现绿色即已经提交
		红绿相加即提交后又进行了再次修改

	查看git status的结果的详细信息，显示已写入缓存与已修改但尚未写入缓存的改动的区别。git diff 有两个主要的应用场景。
	尽量别用，在不懂之前
	使用查看完之后按Q退出
	$ git diff
	
		尚未缓存的改动：git diff
		查看已缓存的改动： git diff --cached
		查看已缓存的与未缓存的所有改动：git diff HEAD
		显示摘要而非整个 diff：git diff --stat
		高版本更新diff --cache: git diff --staged
	
	设置远程地址：（上面新建的） 
	git remote add origin_new 新的地址 
	git remote –v查看 
	git push origin_new master重新推送 
	下面是设置用户名 
	Git config –global user.name “用户名” 
	git config –global user.email 邮箱地址

	设置代理： 
	git config –global https.proxy http://127.0.0.1:1080 
	取消设置代理： 
	git config –global –unset https.proxy
	
	取消git init操作时出现 rm: cannot remove ‘.git’: Is a directory 
	是因为输入的命令是： rm -f .git 
	解决办法：rm -rf .git 即删除整个.git目录

	failed to push some refs to ‘git@github.com:*.git’ hint: Updates were rejected ··· 
	使用git push origin master的时候出现一下错误：
	解决办法： 
	git push -f origin master或者git pull下
	
	恢复不小心删除的 git stash 文件：
	git fsck  //找到dangling的对象
	git show id  //上面列出的每一条记录的最后一个字符串，按 enter 查看具体信息
	git stash apply id
	
	git 回滚提交
	//reset将一个分支的末端指向另一个提交。这可以用来移除当前分支的一些提交, 让master分支向后回退了两个提交
	git checkout master
	git reset HEAD~2
	//Revert撤销一个提交的同时会创建一个新的提交, 找出倒数第二个提交，然后创建一个新的提交来撤销这些更改，然后把这个提交加入项目中。
	git revert HEAD~2 
	错误：Please enter a commit message to explain why this merge is necessary. 解决办法： 
		1. （可选）按键盘字母 i 进入insert模式 
		2. （可选）修改最上面那行黄色合并信息 
		3. 按键盘左上角”Esc” （退出insert模式） 
		4. 输入”:wq”,按回车键即可（提交）
	
	类似于git diff
	git show 
	
	查看git提交日记
	git log
	
	不知道啥作用，先留着
	git config --global core.pager ''
	
	
忽略某些文件

	一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表。通常都是些自动生成的文件，比如日志文件，或者编译过程中创建的临时文件等。我们可以创建一个名为 .gitignore 的文件，列出要忽略的文件模式。来看一个实际的例子：

	$ cat .gitignore
	*.[oa]
	*~
	第一行告诉 Git 忽略所有以 .o 或 .a 结尾的文件。一般这类对象文件和存档文件都是编译过程中出现的，我们用不着跟踪它们的版本。第二行告诉 Git 忽略所有以波浪符（~）结尾的文件，许多文本编辑软件（比如 Emacs）都用这样的文件名保存副本。此外，你可能还需要忽略 log，tmp 或者 pid 目录，以及自动生成的文档等等。要养成一开始就设置好 .gitignore 文件的习惯，以免将来误提交这类无用的文件。

	文件 .gitignore 的格式规范如下：

	所有空行或者以注释符号 ＃ 开头的行都会被 Git 忽略。
	可以使用标准的 glob 模式匹配。
	匹配模式最后跟反斜杠（/）说明要忽略的是目录。
	要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。
	所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。星号（*）匹配零个或多个任意字符；[abc] 匹配任何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）；问号（?）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配（比如 [0-9] 表示匹配所有 0 到 9 的数字）。

	我们再看一个 .gitignore 文件的例子：

	# 此为注释 – 将被 Git 忽略
	# 忽略所有 .a 结尾的文件
	*.a
	# 但 lib.a 除外
	!lib.a
	# 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
	/TODO
	# 忽略 build/ 目录下的所有文件
	build/
	# 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
	doc/*.txt
	# 忽略 doc/ 目录下所有扩展名为 txt 的文件
	doc/**/*.txt
	**\通配符从 Git 版本 1.8.2 以上已经可以使用。
	
移除文件
	要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。可以用 git rm 命令完成此项工作，并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清单中了。

	如果只是简单地从工作目录中手工删除文件，运行 git status 时就会在 “Changes not staged for commit” 部分（也就是未暂存清单）看到
	
	如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 -f（译注：即 force 的首字母），以防误删除文件后丢失修改的内容。
	
	另外一种情况是，我们想把文件从 Git 仓库中删除（亦即从暂存区域移除），但仍然希望保留在当前工作目录中。换句话说，仅是从跟踪清单中删除。比如一些大型日志文件或者一堆 .a 编译文件，不小心纳入仓库后，要移除跟踪但不删除文件，以便稍后在 .gitignore 文件中补上，用 --cached 选项即可：

	$ git rm --cached readme.txt
	后面可以列出文件或者目录的名字，也可以使用 glob 模式。比方说：

	$ git rm log/\*.log
	注意到星号 * 之前的反斜杠 \，因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开（译注：实际上不加反斜杠也可以运行，只不过按照 shell 扩展的话，仅仅删除指定目录下的文件而不会递归匹配。上面的例子本来就指定了目录，所以效果等同，但下面的例子就会用递归方式匹配，所以必须加反斜杠。）。此命令删除所有 log/ 目录下扩展名为 .log 的文件。类似的比如：

	$ git rm \*~
	会递归删除当前目录及其子目录中所有 ~ 结尾的文件。
	
移动文件
	运行 git mv 就相当于运行了下面三条命令：

	$ mv README.txt README
	$ git rm README.txt
	$ git add README
	如此分开操作，Git 也会意识到这是一次改名，所以不管何种方式都一样。当然，直接用 git mv 轻便得多，不过有时候用其他工具批处理改名的话，要记得在提交前删除老的文件名，再添加新的文件名
	
查看提交历史
	在提交了若干更新之后，又或者克隆了某个项目，想回顾下提交历史，使用可以git log命令查看。

	接下来的例子会用我专门用于演示的simplegit项目，运行下面的命令获取该项目源代码：

	git clone git://github.com/schacon/simplegit-progit.git
	然后在此项目中运行git log，应该会看到
	
	
	常用我们-p选项对话展开显示每次提交的内容差异，
	用-2则仅显示队最近的两次更新：
	$ git log -p -2
	
	某些时候，单词层面的对比，比行层面的对比，更加容易观察.Git提供了--word-diff选项。我们可以将其添加到git log -p命令的后面，从而获取单词层面上的对比。
	$ git log -U1 --word-diff
	
	
	加新的的相关资料：被{+ +}括起来，删除被的的相关资料：被[- -]括起来。在进行单词层面的对比的时候，你可能希望上下文（context）行数从默认的3行，减为1行，那么可以使用-U1选项。
	$ git log --stat
	
	
	每个提交都列出了修改过的文件，以及其中添加和移除的行数，并在最后列出所有增减行数小计。还有个常用的--pretty选项，可以指定使用完全不同于默认格式的方式展示提交历史。用比如oneline将每个提交放在一行显示，这在提交数很大时非常有用。另外还有short，full状语从句：fuller可以用，
	$ git log --pretty=oneline
	
	
	format，可以定制要显示的记录格式，这样的输出便于后期编程提取分析，像这样：
	$ git log --pretty=format:"%h - %an, %ar : %s"

		选项	说明
		%H	提交对象（提交）的完整哈希字串
		%h	提交对象的简短哈希字串
		%T	树对象（树）的完整哈希字串
		%t	树对象的简短哈希字串
		%P	父对象（父）的完整哈希字串
		%p	父对象的简短哈希字串
		%an	作者（作者）的名字
		%ae	作者的电子邮件地址
		%ad	作者修订日期（可以用-date =选项定制格式）
		%ar	作者修订日期，按多久以前的方式显示
		%cn	提交者（提交者）的名字
		%ce	提交者的电子邮件地址
		%cd	提交日期
		%cr	提交日期，按多久以前的方式显示
		%s	提交说明
	
	https://git-scm.com/book/zh/v1/Git-%E5%9F%BA%E7%A1%80-%E6%9F%A5%E7%9C%8B%E6%8F%90%E4%BA%A4%E5%8E%86%E5%8F%B2
	
	查看记录
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#########
创建分支命令：
git branch (branchname)

切换分支命令:
git checkout (branchname)

合并分支命令:
git merge 
	
	
$ mkdir gitdemo
$ cd gitdemo/
$ git init
Initialized empty Git repository...
$ touch README
$ git add README
$ git commit -m '第一次版本提交'

https://www.runoob.com/git/git-branch.html
查看记录 
#########
	
	
	
	
	
	
	
	
	