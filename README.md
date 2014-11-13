# liboptions

Easy option parsing.

## License

> The author disclaims copyright to this source code.  In place of
> a legal notice, here is a blessing:
>
> * May you do good and not evil.
> * May you find forgiveness for yourself and forgive others.
> * May you share freely, never taking more than you give.

## Example

```c
#include <stdlib.h>
#include <stdio.h>
#include "options.h"

static const char *program = "example";
static void help(const char *opt, const char *arg, int l)
{
  printf("Usage: %s ...\n", program);
  exit(1);
}

int main(int argc, char **argv)
{
  int flag_debug = 0;

  program = argv[0];
  parse_options(&argc, &argv, OPTIONS(
    FLAG('d', "debug", flag_debug, 1),
    FLAG_CALLBACK('h', "help", help)
  ));

  printf("Debug: %d\n", flag_debug);

  return 0;
}
```

Compile with `cc -o example example.c options.c`.

## Usage

### int parse_options(int \*argc, char \*\*\*argv, option_t \*\*options);

The main work is done with the `parse_options` function.
It expects pointers to `argc` and `argv`.
When the parsing process is complete, `argc` and `argv` will be modified to hold only the positional arguments.
All the options will be removed.

The third argument is a list of supported options.

The most natural way to use it is like this:

```c
parse_options(&argc, &argv, OPTIONS(
  ...
));
```

### OPTIONS(...)

This macro creates a zero terminated list of options.
You can pass any number of options.
The options should be created with the option macros.

### FLAG(s, l, f, v)

This macro creates a flag option.
A Flag has no arguments but sets the variable `f` to the value `v`, if it is encountered on the command line.
`f` must be an `int` lvalue and `v` an `int` value.

`s` and `l` are always the short and long option names.
`s` must be a `char`, `l` must be a c string.
If you do not need either the short or the long option, `s` or `l` may be set to `0`.

### FLAG_CALLBACK(s, l, c)

This macro creates a flag option with a callback.
Instead of setting a variable, the callback function `c` is called, if the flag is encountered on the command line.

All callback functions must be of type `void c(const char *opt, const char *arg, int l)`.
`opt` is a c string holding the option name (without leading hyphens), `arg` is a c string holding the supplied value and `l` is nonzero, if `opt` is a long option.

Because a flag does not take any arguments, the callback function is called with a null pointer for `arg`.

### PARAMETER(s, l, p)

This macro creates an option which requires a parameter.
`p` must be a `char *` lvalue which will be set to the encountered value.

### PARAMETER_CALLBACK(s, l, c)

This macro creates a parameter option with a callback.
Instead of storing the value into a variable, the callback function `c` is called with the encountered value for `arg`.

### PARAMETER_DEFAULT(s, l, p, v)

Like `PARAMETER`, but if the value is ommitted on the command line, `p` will be set to `v`.

### PARAMETER_DEFAULT_CALLBACK(s, l, c, v)

Like `PARAMETER_CALLBACK`, but if the value is ommitted on the command line, the callback function `c` is called with `v` for `arg`.
