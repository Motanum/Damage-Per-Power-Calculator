--message('Thank you for trying the Damage Mana Efficiency Calculator by Motaunm!')

print("Thank you " .. UnitName("Player") .. " for installing the Damage Mana Efficiency Calculator by Motanum!")

--numeric for loop
local function testForLoop(iEnd)
for i = 1, iEnd, 1 do
	print(i)
end
print("loop ended")
end

local function counter(...)
	print(#{...})
	
	--return (a * b) + c;
	
end

testForLoop(15)

counter(15, 10 , 5 , 6 , 10 , "hello", "hi", 'c', {14, 5, 'dude'}, 5 , 4, 3);

counter(5, {3,2,4});