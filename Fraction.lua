local Fraction = {}

Fraction.__index = Fraction

function Fraction.new (num, denom)
   denom = denom or 1
   assert(type(num) == 'number' and type(denom) == 'number',
          'Invalid arguments to Fraction constructor')
   local f = setmetatable({num=num, denom=denom}, Fraction)
   if num % 1.0 ~= 0 or denom % 1.0 ~= 0 then
      -- num and denom must be integers
      return f:value()
   end
   f:simplify()
   return f
end

function Fraction:value ()
   return self.num / self.denom
end

function Fraction.tonum (n)
   return type(n)=='table' and n:value() or n
end

function Fraction.tofrac (n)
   if type(n) == 'number' then n = Fraction.new(n) end
   return type(n) == 'table' and n
end

function Fraction:simplify ()
   local function gcd (a,b)
      return b == 0 and a or gcd(b, a%b)
   end
   local d = gcd(self.num,self.denom)
   self.num, self.denom = self.num/d, self.denom/d
end

function Fraction:__unm ()
   return Fraction.new(-self.num, self.denom)
end

function Fraction.__add (a,b)
   a,b = Fraction.tofrac(a), Fraction.tofrac(b)
   return Fraction.new(a.num * b.denom + b.num * a.denom,
                       a.denom * b.denom)
end

function Fraction:__sub (v)
   return self:__add(-v)
end

function Fraction.__mul (a,b)
   a,b = Fraction.tofrac(a), Fraction.tofrac(b)
   return Fraction.new(a.num * b.num, a.denom * b.denom)
end

function Fraction.__div (a,b)
   a,b = Fraction.tofrac(a), Fraction.tofrac(b)
   return Fraction.new(a.num * b.denom, a.denom * b.num)
end

function Fraction.__eq (a,b)
   return Fraction.tonum(a) == Fraction.tonum(b)
end

function Fraction.__lt (a,b)
   return Fraction.tonum(a) < Fraction.tonum(b)
end

function Fraction.__le (a,b)
   return Fraction.tonum(a) <= Fraction.tonum(b)
end

function Fraction:__tostring ()
   return string.format('%d/%d', self.num, self.denom)
end

return Fraction
