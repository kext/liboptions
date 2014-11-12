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
static void help(char *arg)
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
