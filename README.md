Torch7-tools
============

This would be a collection of useful routines and function currently missing in Torch7.  
Most of the time the scripts are just usefull routines or functions I am using for my job and I am allowed to extract and publish here.

## Cuda to Float network converter
`netConverter` converts a `cuda` network into an equivalent `float` one.
```bash
./netConverter.lua ../results/multinet-cuda.net
```
The scripts automatically changes the extension to `-float.net` and saves the new network in the same location of the input one (which is specified as argument of the routine, as you can see from the example above).
