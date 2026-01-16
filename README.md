# comp-learning

## resources

- [debian-13-install](https://www.youtube.com/watch?v=UklxKvXoRYc)
- [all-other.md](resources.md)

## network-tools

### ssh

```bash
ssh user@hostname
ssh user@hostname "command"
scp filename user@hostname:filename
```

#### config

```bash
cat ~/.ssh/config
```
```
Host *
  User beattyga
  StrictHostKeyChecking   no
```

#### reverse tunnel

```
ssh -R <remote-address>:<remote-port>:<local-address>:<local-port> user@remote-host
       127.0.0.1       :2222         :127.0.0.1      :22           beatty@vader
```
```bash
ssh -R 127.0.0.1:2222:127.0.0.1:22 beattyga@vader
ssh -R           2222:localhost:22 beattyga@vader
```

## networks

### resources

- [Lesson 1a - Hosts, IP Addresses, Networks](https://www.youtube.com/watch?v=bj-Yfakjllc)
- [Lesson 1b - Hub, Bridge, Switch, Router](https://www.youtube.com/watch?v=H7-NR3Q3BeI)

### ipv4

- Internet Protocol Version 4
- Introduced in 1980
- Address Space: 32-bits (`2^32 == 4,294,967,296`)
- An IP address has 4 8-bit "octets": `x.x.x.x` ranging from `0-255`
- RFC 1918 networks (non-routable, used locally only)
  - `10.0.0.0 - 10.255.255.255`     (`10.0.0.0/8`)
  - `172.16.0.0 - 172.31.255.255`   (`172.16.0.0/12`)
  - `192.168.0.0 - 192.168.255.255` (`192.168.0.0/16`) typically used in home networks
- loopback address
  - special reserved IP that lets host send data to itself
  - standard: `127.0.0.1` allows the device always points to the host itself (`localhost`)
  - `127.0.0.0/8` is the loopback network (non-routable on the internet)
- subnet
  - a logical division of a larger IP network into smaller segments. e.g:
    - using `10.0.0.0/8` - carve out 2 `/16` networks (each having `2^16 == 65536` host addresses)
    - `10.1.0.0/16`
    - `10.2.0.0/16`
  - we use CIDR notation (classless inter-domain routing) to specify the network prefix
    - `/24` sets first 24 bits to 1 and last 8 bits to `0` (e.g. `255.255.255.0`) (`2^8 == 256` addresses)
    - `/16` sets first 16 bits to 1 and last 16 bits to `0` (e.g. `255.255.0.0`) (`2^16 == 65536` addresses)
    - `/8` sets first 8 bits to 1 and last 24 bits to `0` (e.g. `255.0.0.0`) (`2^24 == 16777216` addresses)
  - the smaller the CIDR prefix, the larger the network
- subnet netmask
  - a bitmask that when applied by a bitwise `AND` operation yields the network (routing prefix)
  - this allows a router to know if they need to pass the packet to another network
  - example:
    ```
    host       10.1.72.11 == 00001010 00000001 01001000 00001011
    netmask    /16        == 11111111 11111111 00000000 00000000
    ------------------------------------------------------------
    network    10.1.0.0      00001010 00000001 00000000 00000000
    ```
- broadcast address
  - ip has all host bits (the right of the netmask) are set to 1
  - this sends a single message to all devices on the network
  - used for:
    - ARP (Address Resolution Protocol)
    - DHCP (Dynamic Host Configuration Protocol)
- TCP-IP Model (4-1 is `encapsulation`, 1-4 is `decapsulation`)
  - layer-4: application (logical)  protocol:`data`
  - layer-3: transport   (logical)  protocol:`tcp`
  - layer-2: internet    (logical)  protocol:`ip`
  - layer-1: link        (physical) protocol:`ethernet/wifi`

### ipv6

- Internet Protocol Version 6
- Introduced in 1997 (ratified as standard in 2017)
- Address Space: 128-bits (`2^128 == 340,282,366,920,938,463,463,374,607,431,768,211,456`)
  - For each IPv4 internet IP address, you have another IPv4 internet inside, then repeat 2 more times
- 8 quad-nibbles (8 x 16 bits)
  ```
  0000:0000:0000:0000:0000:0000:0000:0001 (localhost)
  ```
- shorthand
  - omit leading zeros: remove any zeros at the beginning of a 16-bit group
    - `0000` becomes `0`
    - `0db8` becomes `db8`
  - use double colon (`::`) replace one or more consecutive groups of all zeros with `::`, e.g.:
    - `2001:0db8:0000:0000:0000:0000:87c:140b` to `2001:db8::87c:140b`
    - `0000:0000:0000:0000:0000:0000:0000:0001` to `::1`
- IPv4 mapped
  - `192.0.2.128` becomes `::ffff:192.0.2.128` (or `::ffff:c000:0280` in hex)

## measurement

### units

| name           | symbol  | description      | combinations  | base-2   | base-10 | base-16 |
| ---            | ---     | ---              | ---           | ---      | ---     | ---     |
| bit            | b       | binary digit     | `2**1`        | 1        | 1       | 1       |
| nibble         | -       | 4 bits           | `2**4`        | 1111     | 15      | f       |
| byte           | B       | 8 bits           | `2**8`        | 11111111 | 255     | ff      |

### binary

| multiplier | binary      | decimal | hexadecimal |
| ---        | ---         | ---     | ---         |
| `2**0`     | `00000001`  | 1       | 1           |
| `2**1`     | `00000010`  | 2       | 2           |
| `2**2`     | `00000100`  | 4       | 4           |
| `2**3`     | `00001000`  | 8       | 8           |
| `2**4`     | `00010000`  | 16      | 10          |
| `2**5`     | `00100000`  | 32      | 20          |
| `2**6`     | `01000000`  | 64      | 40          |
| `2**7`     | `10000000`  | 128     | 80          |
| total      | `11111111`  | 255     | ff          |

### hexadecimal

base-16 notation used represent a nibble (4-bits)

| binary | decimal | hexadecimal |
| ---    | ---     | ---         |
| `0000` | 0       | 0           |
| `0001` | 1       | 1           |
| `0010` | 2       | 2           |
| `0011` | 3       | 3           |
| `0100` | 4       | 4           |
| `0101` | 5       | 5           |
| `0110` | 6       | 6           |
| `0111` | 7       | 7           |
| `1000` | 8       | 8           |
| `1001` | 9       | 9           |
| `1010` | 10      | a           |
| `1011` | 11      | b           |
| `1100` | 12      | c           |
| `1101` | 13      | d           |
| `1110` | 14      | e           |
| `1111` | 15      | f           |

2 hexadecimal digits represent 8 bits, e.g.:
- `1000 1111` is `8f` (`143`)
- `1100 1100` is `cc` (`204`)
- `1111 0001` is `f1` (`241`)
- `1111 1111` is `ff` (`255`)

### multiplier

| base-2     | base-10   | base-2 value                | base-10 value                |
| ---        | ---       | ---                         | ---                          |
| kibi (Ki)  | kilo (K) | `2**10 == 1024`             | `10**3  == 1000`             |
| mebi (Mi)  | mega (M) | `2**20 == 1048576`          | `10**6  == 1000000`          |
| gibi (Gi)  | giga (G) | `2**30 == 1073741824`       | `10**9  == 1000000000`       |
| tebi (Ti)  | tera (T) | `2**40 == 1099511627776`    | `10**12 == 1000000000000`    |
| pebi (Pi)  | peta (P) | `2**50 == 1125899906842624` | `10**15 == 1000000000000000` |

Note: `base-10` symbols are commonly used to represent `base-2` values, e.g:
- `KB` is often used instead of `KiB` to represent `1024` bytes    (`KB` should be `1000` bytes)
- `MB` is often used instead of `MiB` to represent `1048576` bytes (`MB` should be `1000000` bytes)
- etc...

### speed

| name           | symbol | desc       | multiplier | seconds         | light-distance |
| ---            | ---    | ---        | ---        | ---             | ---            |
| second         |  s     | -          | `10 **  0` | 1.0             | 300000 km      |
| millisecond    | ms     | thousandth | `10 ** -3` | 0.001           |    300 km      |
| microsecond    | us     | millionth  | `10 ** -6` | 0.000001        |    300 m       |
| nanosecond     | ns     | billionth  | `10 ** -9` | 0.000000001     |     30 cm      |
| picosecond     | ps     | trillionth | `10 **-12` | 0.000000000001  |      0.3 mm    |

Note: Earth has ~ 40000 km circumference at the equator (~ 130 ms for light to travel)

### back-of-the-envelope

| nanoseconds   | description              | time           |
| ---           | ---                      | ---            |
| `        1` | level-1 cache reference    | 0.5 ns         |
| `        5` | branch mispredict          | 5 ns           |
| `        7` | level-2 cache reference    | 7 ns           |
| `      100` | mutex lock/unlock          | 100 ns         |
| `      100` | main memory reference      | 100 ns         |
| `    10000` | compress 1 KB              | 10 us          |
| `    20000` | send 2 KB at 1 Gbps        | 20 us          |
| `   250000` | read 1 MB memory           | 250 us         |
| `   500000` | round trip same datacenter | 500 us         |
| ` 10000000` | rotational disk seek       | 10 ms          |
| ` 10000000` | read 1 MB from network     | 10 ms          |
| ` 30000000` | read 1 MB from rot disk    | 30 ms          |
| `150000000` | round trip US/CA - EUR/NL  | 150 ms         |

## vim

### resources

- run: `vimtutor` from the command line
- cheatsheets
  - <https://vimsheet.com/>
  - <https://thingsfittogether.com/tft-beautiful-vim-advanced.png>

### modes

- `normal` - (default) - typing moves cursor and manipulates text
- `command-line` - type `:` to enter command-line mode
- `insert` - inserts text when you type - use the `ESC` key to go back to `normal` mode

Remember: The `ESC` key always sends you to `normal` mode (`"When in doubt, ESCAPE it out!"`)

### normal mode

#### navigate

- `h` - move cursor left one character
- `j` - move cursor down one line
- `k` - move cursor down one line
- `l` - move cursor right one character
- `gg` - move cursor to top of file
- `G` - move cursor to bottom of file
- `z<ENTER>` - move cursor to top of screen
- `zz` - center screen at cursor
- `z-` - move cursor to bottom of screen
- `w` - move forward a word
- `W` - move forward a word (including punctuation)
- `b` - move backward a word
- `0` - move to beginning of line
- `$` - move to end of line
- `f<character>` - move forwards to `<character>`
- `F<character>` - move backwards to `<character>`
- `t<character>` - move forwards before (until) `<character>`
- `T<character>` - move backwards before (until) `<character>`

#### insert

- `i` - insert to the left of the cursor
- `a` - insert to the right of the cursor
- `I` - insert at the beginning of the line
- `A` - insert at the end of the line
- `o` - insert below the line
- `O` - insert above the line
- `J` - join line

#### delete

- `x` delete character under cursor
- `dd` delete line
- `u` undo
- `<C>-r` reverse undo

## yank-paste

- `yy` - yank line
- `p` - paste line below the cursor
- `P` - paste line above the cursor

### command-line mode

- `:w` save file
- `:q` quit vim
- `:wq` save file and quit vim
- `:q!` quit vim and throw-away (discard) changes
- `:%s/<search>/<replace>/g` - replace every occurrence on every line of `<search>` with `<replace>`
- `:. !<command>` - send current line into command and replace with output
- `:.,'a !<command>` - send current line to mark `a` into command and replace with output

### search

- `/<term>` search down
- `?<term>` search reverse
- `n` next, `N` previous
- `*` searches for word under cursor

### window

- `:sp[lit] [filename]` horizontal split
- `:vs[plit] [filename]` vertical split
- `<C-w> j` move to top window
- `<C-w> k` move to bottom window
- `<C-w> h` move to left window
- `<C-w> l` move to right window
- `<C-w> o` expand window (open to full size)

### marks

- `m[a-z]` - set mark (pick letter)
- `\`a` - jump to mark `a`
