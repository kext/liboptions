#include <stdlib.h>
#include <stdio.h>

#include "options.h"

#define ON(x) ((x) ? "on" : "off")

static const char *program = "test";
static void help(const char *opt, const char *arg, int l)
{
  printf("Usage: %s [-adhv] [-i input-file] [-l log-level] ...\n", program);
  exit(1);
}

static int verbosity = 0;
static void verbose(const char *opt, const char *arg, int l)
{
  verbosity += 1;
}

int main(int argc, char **argv)
{
  int flag_all = 0;
  int flag_debug = 0;
  char *input_file = "";
  char *log_level = "";
  int i;

  program = argv[0];
  parse_options(&argc, &argv, OPTIONS(
    FLAG('a', "all", flag_all, 1),
    FLAG('d', "debug", flag_debug, 1),
    PARAMETER('i', "input-file", input_file),
    PARAMETER_DEFAULT('l', "log-level", log_level, "error"),
    FLAG_CALLBACK('h', "help", help),
    FLAG_CALLBACK('v', 0, verbose)
  ));

  for (i = 0; i <= argc; ++i) {
    if (argv[i])
      printf("argv[%d] = \"%s\";\n", i, argv[i]);
    else
      printf("argv[%d] = 0;\n", i);
  }

  printf(
    "      All: %s\n"
    "    Debug: %s\n"
    "Verbosity: %d\n"
    "    Input: '%s'\n"
    "Log Level: '%s'\n",
    ON(flag_all),
    ON(flag_debug),
    verbosity,
    input_file,
    log_level
  );

  return 0;
}
