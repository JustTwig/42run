# 42run

Test any C function without writing a `main`.

Point 42run at a `.c` file and it compiles it with the 42 flags, asks you for the arguments of the last function in the file, calls it, and tells you whether norminette is happy. Made for the piscine, where half the time goes into throwaway test mains.

```
$ 42run ft_print_string.c
42run: calling ft_print_string(str)
str (string): Hello 42!
--- output ---
Hello 42!
--- norminette ---
NOT OK (42 issues)
```

## Install

You only need `python3`, `cc` and `git`.

```sh
git clone --depth 1 https://github.com/JustTwig/42run ~/.local/share/42run
~/.local/share/42run/install.sh
```

This links `~/.local/bin/42run` and adds `~/.local/bin` to your `PATH` if it's missing. Open a new terminal afterwards.

## Usage

```
42run [options] file.c
```

| Flag              | What it does                                                        |
|-------------------|---------------------------------------------------------------------|
| `-n`, `--no-norm` | Skip the norminette report at the end                               |
| `-w`, `--watch`   | Open a new terminal running `watch norminette file.c`               |
| `-u`, `--update`  | Update 42run (`git pull`)                                           |
| `-v`, `--version` | Print the version                                                   |
| `-h`, `--help`    | Show the help                                                       |

`-w` needs a graphical session and `watch` installed. It tries `$TERMINAL` first, then common terminals (ghostty, kitty, alacritty, foot, wezterm, gnome-terminal, konsole, xfce4-terminal, tilix, xterm). The window stays open after 42run exits, so you can keep editing and see the result update every second.

It asks for each parameter by name and type:

| C type             | Prompt                                    |
|--------------------|-------------------------------------------|
| `int`, `long`, ... | a number                                  |
| `float`, `double`  | a decimal number                          |
| `char`             | one character                             |
| `char *`           | a string                                  |
| `int *`, `float *` | comma-separated numbers                   |
| `char **`          | space-separated words                     |
| `main(int, char **)` | the arguments (`argc` and `argv[0]` are filled in for you) |

## How it works

1. Compiles the file into a temporary shared library with `cc -Wall -Wextra -Werror -g -shared -fPIC`.
2. Reads the DWARF debug info to find the function declared lowest in the file and its parameter types.
3. Prompts for the arguments, then calls the function from a forked child process.
4. Runs `norminette` on the source and prints `OK`, or `NOT OK (N issues)`. This happens even if the compile failed or the function crashed.
5. Deletes the temporary directory. Nothing is written next to your source.

A segfault in your code only kills the child process, so you get `--- crashed: SIGSEGV ---` and a clean exit. If your code loops forever, press Ctrl+C: it stops the child (`--- interrupted: SIGINT ---`), then the norminette check and cleanup still run. The child is also killed if 42run itself dies, so nothing keeps printing in the background.

## Limitations

- **Linux only** (it reads ELF files).
- **Single file.** Calls into other `.c` files fail to link.
- **`static` functions** can't be called from outside, so remove `static` while testing.
- Structs aren't supported (raw pointer prompt only).
- Norminette is optional. Install it with `pipx install norminette` if you don't have it.

## Uninstall

```sh
~/.local/share/42run/uninstall.sh
rm -rf ~/.local/share/42run
```

## Credits

Bundles [pyelftools](https://github.com/eliben/pyelftools) (public domain) in `vendor/`, so there is nothing to install separately.

## License

MIT, see `LICENSE`.
