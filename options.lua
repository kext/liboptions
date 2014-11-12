local function parse_options(arguments, options)
  local r = {}
  local longopts = {}
  local shortopts = {}
  for i, o in ipairs(options) do
    if o.short then
      shortopts[o.short] = o
    end
    if o.long then
      longopts[o.long] = o
    end
  end
  local function error(s)
    print(s)
    os.exit(1)
  end
  local lastopt = ''
  local function parse(option, argument)
    if option.argument then
      if not argument and not option.default then
        error(string.format('Option ‘%s’ needs an argument.', lastopt))
      end
      if type(option.action) == 'function' then
        option.action(argument or option.default)
      else
        r[option.action] = argument or option.default
      end
    else
      if type(option.action) == 'function' then
        option.action(option.default)
      else
        r[option.action] = option.default
      end
    end
  end
  local parsing = nil
  for i, a in ipairs(arguments) do
    if string.sub(a, 1, 1) == '-' then
      if parsing then
        parse(parsing)
        parsing = nil
      end
      if a == '--' then
        for j = i + 1, #arguments do
          r[#r + 1] = arguments[j]
        end
        return r
      elseif string.sub(a, 1, 2) == '--' then
        local a = string.sub(a, 3, -1)
        local x = string.find(a, '=', 1, true)
        local v
        if x then
          a, v = string.sub(a, 1, x - 1), string.sub(a, x + 1, -1)
        end
        lastopt = '--' .. a
        local o = longopts[a]
        if not o then
          error(string.format('Unrecognised option ‘--%s’.', a))
        else
          if o.argument then
            if v then
              parse(o, v)
            else
              parsing = o
            end
          else
            parse(o)
          end
        end
      else
        local j = 2
        while j <= #a do
          local s = string.sub(a, j, j)
          lastopt = '-' .. s
          local o = shortopts[s]
          if not o then
            error(string.format('Unrecognised option ‘-%s’.', s))
          else
            if o.argument then
              if j == #a then
                parsing = o
              else
                parse(o, string.sub(a, j + 1))
              end
              break
            else
              parse(o)
              j = j + 1
            end
          end
        end
      end
    else
      if parsing then
        parse(parsing, a)
        parsing = nil
      else
        r[#r + 1] = a
      end
    end
  end
  if parsing then
    parse(parsing)
  end
  return r
end

local function flag(short, long, action, value)
  return {
    argument = false,
    short = short,
    long = long,
    action = action,
    default = value
  }
end

local function argument(short, long, action, default)
  return {
    argument = true,
    short = short,
    long = long,
    action = action,
    default = default
  }
end

return {
  parse = parse_options,
  flag = flag,
  argument = argument
}
