local Fraction = require 'Fraction'

local denoms = {1,2,3,4,5,6,7}

local t = {}
for _,d in ipairs(denoms) do
   for i = d+1,d*2-1 do
      t[#t+1] = Fraction.new(i,d)
   end
end
table.sort(t, function (a,b) return a<b end)
local tones = {}
for i = 1,#t do
   if t[i] ~= t[i+1] then
      tones[#tones+1] = t[i]
   end
end
print(#tones, 'tones')
for _,v in ipairs(tones) do print(v) end
