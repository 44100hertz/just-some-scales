local F = require 'Fraction'

local scales = {}

function scales.tuning_string (n)
   return type(n) == 'table' and n or scales.ratio_to_cents(n)
end

function scales.cents_to_ratio (cents) return math.pow(2.0, cents/1200.0) end
function scales.ratio_to_cents (ratio) return math.log(ratio, 2.0) * 1200.0 end

-- Test with various frequencys
for _,n in ipairs{0.001, 0.1, 0.5, 1.0, 2.0, 10.0, math.random(), math.random()*100} do
   local rat = scales.ratio_to_cents(n)
   local diff = scales.cents_to_ratio(rat) - n
   assert(math.abs(diff) < 0.00001)
end

-- Print out an equal temperament scale
-- i.e. same ratio between each note
function scales.tet (num_notes, octave_size)
   local t = {}
   octave_size = octave_size or 2.0
   for i = 1,num_notes do
      local ratio = math.pow(octave_size, i/num_notes)
      t[i] = scales.ratio_to_cents(ratio)
   end
   return t
end

-- Repeatedly multiply by a ratio in order to create a scale
function scales.rational (num_notes, ratio, octave)
   assert(1.0 < octave, 'Octave size must be greater than 1.0')
   assert(ratio < octave, 'Note ratio must be less than octave size')
   local base = F.new(1,1)
   octave = octave or F.new(2,1)
   local t = {}
   for i = 1,num_notes-1 do
      base = base * ratio
      if base > octave then
         base = base / octave
      end
      t[i] = base
   end
   t[num_notes] = octave
   table.sort(t, function (a,b) return a < b end)
   return t
end

-- Use a special averaging technique to even out the tonality of a rational
-- scale
function scales.meantone (num_notes, ratio, octave)
   local rat = scales.rational(num_notes, ratio, octave)
   local t = {}
   local half_num_notes = math.floor(num_notes/2)
   local half_octave_ratio = rat[half_num_notes]
   for i = 1,num_notes do
      local opposite_index = (i + half_num_notes - 1) % num_notes + 1
      local opposite = rat[opposite_index] / half_octave_ratio
      if opposite <= 1.0 then opposite = opposite * octave end
      print(rat[i]:value(), opposite:value())
      t[i] = (rat[i] + opposite) / 2.0
   end
   return t
end

scales.presets = {
   pythagorean = {kind = 'rational', 12, F.new(3,2), F.new(2,1)},
   well = {kind = 'meantone', 12, F.new(3,2), F.new(2,1)},
   major = {kind = 'rational', 7, F.new(3,2), F.new(2,1)},
   minor = {kind = 'rational', 7, F.new(5,4), F.new(2,2)},
}

function scales.use_preset(p) return scales[p.kind](table.unpack(p)) end
function scales.use_preset_name(p) return scales.use_preset(scales.presets[p]) end

function scales.print_scale (s) for _,v in ipairs(s) do print(scales.tuning_string(v)) end end
scales.print_scale(scales.rational(7, F.new(5,4), F.new(2,1)))

return scales
