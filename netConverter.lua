#!/usr/bin/env torch
--------------------------------------------------------------------------------
-- Conversion script: it turns a CUDA network into a CPU one
--------------------------------------------------------------------------------
--
-- Iteratively scanning the network, it disregard the transposition modules
-- and convert <SpatialConvolutionCUDA> into <SpatialConvolution> and 
-- <SpatialMaxPoolingCUDA> into <SpatialMaxPooling>. Al other modules are copied
--
--------------------------------------------------------------------------------

require 'cunn'
require 'nnx'

--------------------------------------------------------------------------------

if not arg[1] then print "Network unspecified (type it after the program's name)" return
else print('Loading: ' .. arg[1]) end

cudaNet = torch.load(arg[1])
cudaCNN = cudaNet.modules[1]
classifier = cudaNet.modules[2]

torch.setdefaulttensortype('torch.FloatTensor')

function smartCopy(cudaModule,floatNetwork)
   -- if cudaModule.__typename == 'nn.Sequential' then
   --    floatNetwork = nn.Sequential()
   if cudaModule.__typename == 'nn.SpatialConvolutionCUDA' then
      print(' + Converting <nn.SpatialConvolutionCUDA> into <nn.SpatialConvolution>')
      floatNetwork:add(nn.SpatialConvolution(cudaModule.nInputPlane, cudaModule.nOutputPlane, cudaModule.kW, cudaModule.kH))
      floatNetwork.modules[#floatNetwork.modules].gradBias   = nil
      floatNetwork.modules[#floatNetwork.modules].gradWeight = nil
      floatNetwork.modules[#floatNetwork.modules].gradInput  = nil
      floatNetwork.modules[#floatNetwork.modules].weight     = cudaModule.weight:transpose(4,3):transpose(3,2):transpose(2,1):float()
   elseif cudaModule.__typename == 'nn.SpatialMaxPoolingCUDA' then
      print(' + Converting <nn.SpatialMaxPoolingCUDA> into <nn.SpatialMaxPooling>')
      floatNetwork:add(nn.SpatialMaxPooling(cudaModule.kW, cudaModule.kH, cudaModule.dW, cudaModule.dH))
      --floatNetwork.modules[#floatNetwork.modules].indices    = nil
      floatNetwork.modules[#floatNetwork.modules].gradInput  = nil
   elseif cudaModule.__typename ~= 'nn.Transpose' then
      print(' + Copying <' .. cudaModule.__typename .. '>')
      floatNetwork:add(cudaModule)
   end
end

function convert(cudaNetwork)
   local floatNetwork = nn.Sequential()
   if cudaNetwork.modules then
      for _,a in ipairs(cudaNetwork.modules) do
         smartCopy(a,floatNetwork)
      end
   end
   return floatNetwork
end

print 'Converting <cudaCNN> to <floatCNN>...'
floatCNN = convert(cudaCNN)
-- print('cuda CNN', cudaCNN)
-- print('float CNN', floatCNN)

print 'Assembling final float network'
floatNet = nn.Sequential()
print ' + Adding <floatCNN>'
floatNet:add(floatCNN)
print ' + Adding <classifier>'
floatNet:add(classifier:float())

--[[io.write("Type network's new name without extension: ")
newFileName = io.read() .. '.net']]
newFileName = string.sub(arg[1],1,-5) .. '-float.net'
print('Saving network as <' .. newFileName .. '>')
torch.save(newFileName,floatNet)

io.write 'Would you like to print the saved network on screen [y/(n)]? '
if io.read() == 'y' then print(floatNet) end
