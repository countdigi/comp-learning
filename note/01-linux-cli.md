# notes/linux-cli.md

- [The Linux Command Line](https://www.kea.nu/files/textbooks/humblesec/thelinuxcommandline.pdf)
- MIT missing semester: <https://missing.csail.mit.edu/2020/course-shell/>

## 1. shell

The `shell` is a program that takes keyboard commands and passes them to the operating system to carry out.

Almost all Linux distributions supply a shell program from the GNU Project called `bash`.

The name is an acronym for bourne-again shell, a reference to the fact that `bash` is an enhanced replacement
for `sh`, the original Unix shell program written by Steve Bourne

When using a graphical user interface (GUI), we need another program called a terminal emulator to interact with the shell.

## 2. shell prompt

When you login to the shell, you will see something like this:
```bash
$
```

This is called a *shell prompt* and it will appear whenever a shell is ready to accept input.

The shell prompt above prints the name of the directory you are in followed by the `$` which is
typically used to indicate the shell is ready for input.

Now type a *command* which will then be interpreted by the shell:

```bash
$ date
```
```
Fri 10 Jan 2020 11:49:31 AM EST
```

We can also execute a command with *arguments*:
```bash
$ echo hello
```
```
hello
```

We just told the shell to execute the program `echo` with the argument `hello`.

The `echo` program simply prints out its arguments.

The shell parses the command by splitting it by whitespace, and then runs the program indicated by the first word, supplying each subsequent word as an argument that the program can access.

If you want to provide an argument that contains spaces or other special characters (e.g., a directory named “My Photos”), you can either quote the argument with `'` or `"` (e.g. `"My Photos"`), or escape just the relevant characters with `\ My \Photos`.

---

How does the shell know how to find the `date` or `echo` programs?

- Since the shell is a programming environment, it has built-in commands
- If the command you type does *not* match the built-in command, it consults and *environmental variable* called `$PATH` that lists what directories the shell should search for programs when it is given a command

```bash
$ echo $PATH
```
```
/usr/local/bin:/usr/bin:/usr/sbin
```

We can find out which file is executed for a given program name using the `which` program. We can also bypass `$PATH` entirely by giving the path to the file we want to execute, e.g. `/usr/bin/date`.

## 3. Navigating in the shell

A path on the shell is a delimited list of directories; separated by forward slashes (`/`).

The path `/` is the “root” of the file system, under which all directories and files lie.

A path that starts with `/` is called an absolute path.

Any other path is a relative path.

Relative paths are relative to the current working directory.

In a path, `.` refers to the current directory, and `..` to its parent directory.

You can run more than one command on a line by terminating each command with a semi-colon (`;`). We will
do this to save space (e.g. `cd /home; pwd`):


```bash
$ cd $HOME; pwd
/home/beattyga

$ cd /home; pwd
/home

$ cd ..; pwd
/

$ cd ./home; pwd
/home

$ cd beattga; pwd
/home/beattyga

$ ../../bin/echo hello
hello
```

To see what lives in a given directory, type `ls` which stands for "list directory contents".

Let's change to your home directory which is in the environmental variable `$HOME`.

You can change to your home directory 4 different ways:
- `cd /home/beattyga`
- `cd $HOME` - since `HOME=/home/beattyga`, the shell expands your command to `cd /home/beattyga`
- `cd ~` - The tilde (`~`) is a bash shortcut to reference your `$HOME`
- `cd` - Typing `cd` with no arguments changes to your `$HOME` directory

Now lets list your directory:
```bash
$ ls
```

You should see nothing.

Now change to the `/home` directory and run `ls` then change to the root directory and run `ls`.

```
$ cd /home

$ ls
beattyga

$ cd /

$ ls
bin
boot
dev
etc
```

Unless a directory is given as its first argument, `ls` will print the contents of the current directory.

Most commands accept flags and options (flags with values) that start with `-` (short option) or `--` (long option) to modify their behavior.

Usually running a program with the `-h` or `--help` flag will print some help text that tells you what flagas and optionis are available.

For example, `ls --help` will tell us:
```
-l               use a long listing format
```

```bash
$ ls -l /home
drwxr-xr-x 1 beattyga beattyga 4096 Jun 1 beattyga
```
