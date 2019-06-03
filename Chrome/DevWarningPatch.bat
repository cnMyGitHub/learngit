<＃：
@echo关闭
copy / b“％~f0”“％temp％\％~n0.ps1”> nul
powershell -Version 2 -ExecutionPolicy bypass -noprofile“％temp％\％~n0.ps1”“％cd％”“％〜1”
del“％temp％\％~n0.ps1”
暂停
退出/ b
＃>
param（[string] $ cwd ='。'，[string] $ dll）

功能主{
    “Chrome'开发者模式扩展'警告禁用v1.0.10.20170114`n”
    $ pathsDone = @ {}
    if（$ dll -and（gi -literal $ dll））{
        doPatch“DRAG'n'DROPPED”（（gi -literal $ dll）.directoryName +'\'）
        出口
    }
    doPatch CURRENT（（gi -literal $ cwd）.fullName +'\'）
    （'HKLM'，'HKCU'）| ％{$ hive = $ _
        （''，'\ Wow6432Node'）| ％{
            $ key =“$ {hive}：\ SOFTWARE $ _ \ Google \ Update \ Clients”
            gci -ea默默地继续$ key -r | gp | ？{$ _。CommandLine} | ％{
                $ path = $ _。CommandLine -replace'“（。+？\\\ d + \。\ d + \。\ d + \。\ d + \\）。+'，'$ 1'
                doPatch REGISTRY $ path
            }
        }
    }
}

function doPatch（[string] $ pathLabel，[string] $ path）{
    if（$ pathsDone [$ path.toLower（）]）{return}

    $ dll = $ path +“chrome.dll”
    if（！（test-path -literal $ dll））{
        返回
    }
    “=======================”
    “$ pathLabel PATH $（（gi -literal $ dll）.DirectoryName）”

    “`tREADING Chrome.dll ......”
    $ bytes = [IO.File] :: ReadAllBytes（$ dll）

    #process PE头
    $ BC = [BitConverter]
    $ coff = $ BC :: ToUInt32（$ bytes，0x3C）+ 4
    $ is64 = $ BC :: ToUInt16（$ bytes，$ coff）-eq 0x8664
    $ opthdr = $ coff + 20
    $ codesize = $ BC :: ToUInt32（$ bytes，$ opthdr + 4）
    $ imagebase32 = $ BC :: ToUInt32（$ bytes，$ opthdr + 28）

    ＃修补数据部分中的标志
    $ data = $ BC :: ToString（$ bytes，$ codesize）
    $ flag =“ExtensionDeveloperModeWarning”
    $ stroffs = $ data.IndexOf（$ BC :: ToString（$ flag [1..99]））/ 3  -  1
    if（$ stroffs -lt 0）{
        write-host -f red“`t $ flag not found”
        返回
    }
    $ stroffs + = $ codesize
    if（$ bytes [$ stroffs] -eq 0）{
        写主机-f darkgreen“`tALREADY PATCHED”
        返回
    }

    $ exe = join-path（split-path $ path）chrome.exe
    $ EA = $ ErrorActionPreference
    $ ErrorActionPreference ='silentlyContinue'
    while（（get-process chrome -module |？{$ _.FileName -eq $ exe}））{
        forEach（15..0中的$ timeout）{
            write-host -n -b yellow -f black`
                “`rChrome正在运行，并将在超时秒内终止。”
            write-host -n -b yellow -f darkyellow“按ENTER键立即执行。”
            if（[console] :: KeyAvailable）{
                $ key = $ Host.UI.RawUI.ReadKey（“AllowCtrlC，IncludeKeyDown，NoEcho”）
                if（$ key.virtualKeyCode -eq 13）{break}
                if（$ key.virtualKeyCode -eq 27）{write-host; 出口 }
            }
            睡觉1
        }
        写主机
        get-process chrome | ？{
            $ _。MainWindowHandle.toInt64（） - 和（$ _ | gps -file）.FileName -eq $ exe
        } | ％{
            “好好退出......”
            if（$ _。CloseMainWindow（））{
                睡觉1
            }
        }
        $ killLabelShown = 0
        get-process chrome | ？{
            （$ _ | gps -file | select -expand FileName）-eq $ exe
        } | ％{
            if（！$ killLabelShown ++）{
                “`tTerminating背景镀铬工艺......”
            }
            停止进程$ _ -force
        }
        睡觉 - 毫秒200
    }
    $ ErrorActionPreference = $ EA

    $ bytes [$ stroffs] = 0
    “`tPATCHED $ flag flag”

    ＃修补stable / beta的通道限制代码
    $ code = $ BC :: ToString（$ bytes，0，$ codesize）
    $ rxChannel = '83 -F8  - （？：03-7D | 02-7F）'
    ＃旧代码：cmp eax，3; jge ......
    #new code：cmp eax，2; jg ......
    $ chanpos = 0
    尝试{
        if（$ is64）{
            $ pos = 0
            $ rx = [regex]“$ rxChannel  - 。{1,100} -48-8D”
            做{
                $ m = $ rx.match（$ code，$ pos）
                if（！$ m.success）{break}
                $ chanpos = $ m.index / 3 + 2
                $ pos = $ m.index + $ m.length + 1
                $ offs = $ BC :: ToUInt32（$ bytes，$ pos / 3 + 1）
                $ diff = $ pos / 3 + 5 + $ offs  -  $ stroffs
            }（$ diff -ge 0 -and $ diff -le 4096 -and $ diff％256 -eq 0）
            if（！$ m.success）{
                $ rx = [regex]“84-C0。{18,48}（$ rxChannel） - 。{30,60} 84-C0”
                $ m = $ rx.matches（$ code）
                if（$ m.count -ne 1）{throw}
                $ chanpos = $ m [0] .groups [1] .index / 3 + 2
            }
        } else {
            $ flagOffs = [uint32] $ stroffs + [uint32] $ imagebase32
            $ flagOffsStr = $ BC :: ToString（$ BC :: GetBytes（$ flagOffs））
            $ variants =“（？<channel> $ rxChannel  - 。{1,100}） -  68  - （？<flag>`$ 1  - 。{6}`$ 2）”，
                    “68  - （<标志>`$ 1  -  {6}`$ 2）。（？<通道> $ rxChannel）{300500} {E8} 12,32”，
                    “E8 {12,32}（<通道> $ rxChannel？）{300500} 68  - 。。（？<标志>`$ 1  -  {6}`$ 2）”
            forEach（$ variants中的$ variant）{
                $ pattern = $ flagOffsStr -replace'^（..） - 。{6}（..）'，$ variant
                “`tLooking for $（$ pattern -replace'\？<。+？>'，''）......”
                $ minDiff = 65536
                foreach（[regex]中的$ m :: matches（$ code，$ pattern））{
                    $ maybeFlagOffs = $ BC :: toUInt32（$ bytes，$ m.groups ['flag']。index / 3）
                    $ diff = [Math] :: abs（$ maybeFlagOffs  -  $ flagOffs）
                    if（$ diff％256 -eq 0 -and $ diff -lt $ minDiff）{
                        $ minDiff = $ diff
                        $ chanpos = $ m.groups ['channel'] .index / 3 + 2
                    }
                }
            }
            if（！$ chanpos）{throw}
        }
    } catch {
        write-host -f red“`t无法找到频道代码，请尝试更新我”
        write-host -f red“`thttp：//stackoverflow.com/a/30361260”
        返回
    }
    $ bytes [$ chanpos] = 9
    “`tTATCHED Chrome发布渠道限制”

    “写一个临时的dll ......”
    [IO.File] :: WriteAllBytes（ “$ dll.new”，$字节）

    “`回到原来的dll ......”
    移动-literal $ dll“$ dll.bak”-force

    “`将临时dll作为原始dll进行重命名......”
    移动-literal“$ dll.new”$ dll -force

    $ pathsDone [$ path.toLower（）] = $ true
    write-host -f green“`tDONE .n”
    [GC] ::收集（）
}
