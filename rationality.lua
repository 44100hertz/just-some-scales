-- Failed experiment: 'rationality' -- I try to see which roots are the closest
-- to being whole fractions. It doesn't go very well.
--
--local scales = require 'scales'
--
-- local primes = {}

-- do
--    local sieve = {}
--    local len = 1000
--    for i = 1,len do
--       for j = i,len*len,i do
--          sieve[j] = true
--       end
--    end
--    for i = 1,len*len do
--       if not sieve[i] then primes[#primes+1] = i end
--    end
-- end

local function rationality (base, octave, tolerance, show_fraction)
   tolerance = tolerance or 0.005
   local sum = 0
   for i = 1,base do
      local ratio = math.pow(octave, i/base)
      for j = 1,1000 do
         local numer = ratio * j
         local numer_i = math.floor(numer + 0.5)
         local err = math.abs(numer - numer_i)
         if err < ratio * tolerance then
            if show_fraction then
--               print(string.format('Good fraction for %d: %d/%d', i, numer_i, j))
               print(string.format('%d/%d', numer_i, j))
            end
            sum = sum+j
            break
         end
      end
   end
   return sum/base
end

local function list_rationalities (min, max, tolerance)
   local t = {}
   for o = 1.5,2.5,1.0/128 do
      for i = min,max do
         t[#t+1] = {base = i, oct = o, rat = rationality(i, o, tolerance)}
      end
   end
   table.sort(t, function (a,b) return a.rat<b.rat end)
   for i=1,12 do local v = t[i] print(v.base, v.oct, v.rat) end
   rationality(t[1].base, t[1].oct, tolerance, true)
end

list_rationalities(10,16,0.01)
