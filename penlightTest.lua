-- Parsing the command line ----------------------------------------------------
-- lapp = require 'pl.lapp'
require 'pl'
lapp.slack = true
args = lapp [[
Does some calculations
   -v, --video              (string)             Specify input video
   -w, --width              (default 256)        Width of the video
   -h, --height             (default 144)        Height of the video
   -t, --time               (default 10)         Seconds of video to process
   -sk,--seek               (default 0)          Seek number of seconds
   -f1,--flag1                                   A false flag
   -f2,--flag2                                   A false flag
   -f3,--flag3              (default true)       A true flag
   -f4,--flag4              (default true)       A true flag
]]

-- Plotting the parsed commands ------------------------------------------------
print 'args ='
print(args)
pretty = require 'pl.pretty'
pretty.dump(args)
