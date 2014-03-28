Torch7-tools
============

This would be a collection of useful routines and function currently missing in Torch7.  
Most of the time the scripts are just usefull routines or functions I am using for my job and I am allowed to extract and publish here.

## Tools description

### Table of contents
 - [Network lightener](#network-lightener)
 - [Gradient repopulation](#gradient-repopulation)
 - [Command line parser](#command-line-parser)
 - [Cuda to Float network converter](#cuda-to-float-network-converter)

### Important!
The new `net-toolkit` Torch7 package will be released soon. Basically it will provide a way for easily handling networks and it will include the following two functions, which are to be considered therefore deprecated.

> ### Network lightener
> `netLighter` library provides a `saveNet(name, network)` function which saves a lighter version of your current network, removing all unnecessary data from it (such as *gradients*, *temporal data* and etc...). The default location is `./`; if a different one is preferred instead, you may want to specify it with a global option `opt.save = 'my-path/'`. Usage:

> ```lua
> -- if './' is not ok:
> opt = opt or {}
> opt.save = 'my-path/'
> -- otherwise, it will be sufficient only:
> require 'netLighter'
> -- net = nn.Sequential() and other stuff
> saveNet('myNet.net',net)
> ```

> ### Gradient repopulation
> Let's say we would like to load a network we have previously saved with `saveNet()` for continuing a training > session on it. Some inner parameters (something about *gradients*) have to be restored, since `saveNet()` did a pruning operation on the network in order to save space. Here is how we can handle this case:

> ```lua
> local networkFile = '/path/To/MyNet.net'
> model = torch.load(networkFile)
> repopulateGrad(model)
> ```

> Now we can keep training, perhaps without forgetting to define a *criterion* `loss` (the criterion is not saved with the network, so we have to re-define it, if we don't already do it somewhere else in the code).

### Command line parser
`penlightTest` shows a great deal of command line parser options that could turn helpful when we need to send some initial configuration values to the script in a compact manner. Running the script in `lua` (or `torch`) with no argument will print on screen the help screen (usually reachable with the option `--help` or `-h`, which in **this** case has been deliberately overwritten to be the `height` handle).
```bash
lua penlightTest.lua
```
Moreover, you can notice the presence of `default false` and `default true` flags and short *multi-letter* handles as well, which are not iterpreted as in the Unix environment (say like `ls -al`) because of `slack = true` of `lapp` has been (intentionally) set to `true`.
You can run the test like this (it will show everything it can do that I care)
```bash
lua penlightTest.lua -v abc --time 40 -h 20 -sk 15 --flag1 -f3
```
The same two lines above could have been written by sustituting `lua` with `torch` (and this is what I usually do). Further documentation on the `lapp` command line parser can be found [here](https://github.com/stevedonovan/Penlight/blob/master/doc/manual/08-additional.md#command-line-programs-with-lapp).

### Cuda to Float network converter
`netConverter` converts a `cuda` network into an equivalent `float` one.
```bash
./netConverter.lua ../results/multinet-cuda.net
```
The scripts automatically changes the extension to `-float.net` and saves the new network in the same location of the input one (which is specified as argument of the routine, as you can see from the example above).
