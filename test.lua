local options = require('options')

for i, a in pairs(options.parse(arg, {
  options.flag('a', 'all', 'all', true),
  options.flag('d', 'debug', 'debug', true),
  options.argument('f', 'file', 'file'),
  options.argument('h', 'help', function()
    print('test [-ad] [-f file] [...]')
    os.exit(1)
  end, 1)
})) do
  print(i, a)
end
