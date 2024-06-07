# 1. ansible保留主机变量

+ `all` 所有定义的和未定义的主机, 等于`localhost`+`ungrouped`
+ `localhost` 本机,即运行ansible命令的主机
+ `ungrouped ` 所有未分组的主机
+ `_meta` 特殊的组,用于存储动态inventory的元数据信息,一般由动态inventory插件自动生成,用于存储动态生成的主机信息

# 2. ansibel命令选项(`-a`)

这个`-a`其实就是`ansible`命令的参数,类似于`-i`,`-e`,`-f`,`-m`等等

```bash
$ ansible --help
Usage: ansible <host-pattern> [options]

#选项:
  -a MODULE_ARGS, --args=MODULE_ARGS                                #指定模块的参数
  --ask-vault-pass                                                  #询问账号的密码
  -B SECONDS, --background=SECONDS                                  #异步运行，在指定秒后异步运行失败
  -C, --check                                                       #不做出任何改变，只是进行测试检查
  -D, --diff                                                        #当更改(小)文件和模板时，显示这些文件中的差异
  -e EXTRA_VARS, --extra-vars=EXTRA_VARS                            #将其他变量设置为key=value或YAML/JSON，如果文件名前面有@
  -f FORKS, --forks=FORKS                                           #指定要使用的并行进程数，例如100台机器，-f指定每次运行几台,默认每次运行5台
  -i INVENTORY, --inventory=INVENTORY, --inventory-file=INVENTORY   #指定主机列表路径，如果不指定，默认为/etc/ansible/ansible.cfg中指定的hosts
  -l SUBSET, --limit=SUBSET                                         #将选定的主机限制为附加模式。
  -m MODULE_NAME, --module-name=MODULE_NAME                         #指定要执行的模块名称，默认为 command 模块
  -M MODULE_PATH, --module-path=MODULE_PATH                         #指定要执行模块的路径，默认模块路径为~/.ansible/plugins/modules:/usr/share/ansible/plugins
  -o, --one-line                                                    #浓缩输出
  --playbook-dir=BASEDIR                                            #指定playbook文件目录
  -P POLL_INTERVAL, --poll=POLL_INTERVAL                            #指定轮训间隔时间，默认为15
  -t TREE, --tree=TREE                                              #将ansible输出记录到指定目录
  --vault-id=VAULT_IDS  the vault identity to use
  --vault-password-file=VAULT_PASSWORD_FILES
                        vault password file
  -v, --verbose                                                     #详细模式（-VVV更多，-VVVV可启用连接调试）
 
  #特权提升选项:
    -b, --become                                                    #临时使用--become-method指定的提取方法
    -K, --ask-become-pass                                           #请求权限提升密码

  #连接选项:
    -k, --ask-pass                                                  #请求连接密码
    --private-key=PRIVATE_KEY_FILE, --key-file=PRIVATE_KEY_FILE     #指定私钥文件进行登录
    -u REMOTE_USER, --user=REMOTE_USER                              #指定连接用户，默认不指定则为hosts文件中用户
    -c CONNECTION, --connection=CONNECTION                          #连接方式，默认为smart，还有ssh和sftp
    -T TIMEOUT, --timeout=TIMEOUT                                   #ansible连接超时时间，默认为10s
```

# 3. `etc/ssh/ssh_host_rsa_key.pub和 ~/.ssh/authorized_keys`的区别

1. **`/etc/ssh/ssh_host_rsa_key.pub`**：
   - 这是目标主机上 SSH 服务器（sshd）的 RSA 公钥文件。
   - 它用于主机认证，客户端连接到远程主机时，会用来验证远程主机的身份。
   - 这个公钥文件是由 SSH 服务器生成和管理的，用于进行 SSH 连接的安全验证。
2. **`~/.ssh/authorized_keys`**：
   - 这是用户在远程主机上的授权密钥文件。
   - 它用于用户认证，你可以将本地计算机上的公钥文件的内容添加到目标主机上的 `~/.ssh/authorized_keys` 文件中，以进行无密码登录。
   - 当你尝试通过 SSH 连接到远程主机时，远程主机会检查你在 `~/.ssh/authorized_keys` 文件中列出的公钥是否与你尝试连接的用户匹配。如果匹配成功，你将被授权登录到远程主机。

``/etc/ssh/ssh_host_rsa_key.pub` 是用于验证 SSH 服务器是否是 OpenSSH 的公钥文件。通常情况下，安装 SSH 服务（如 OpenSSH）时，会自动生成这个公钥文件，并将其用于 SSH 客户端连接到服务器时进行主机认证。

在建立 SSH 连接时，客户端会使用服务器的公钥进行主机认证。如果服务器的公钥与客户端预期的公钥匹配，那么连接就可以继续进行。这样可以确保客户端连接到的确实是预期的服务器，而不是中间人发起的欺骗攻击。

因此，`/etc/ssh/ssh_host_rsa_key.pub` 是用于验证服务器身份的重要文件之一，它可以帮助确保建立的 SSH 连接是安全可信的
