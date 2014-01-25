--[[
Copyright (c) 2011, 2014 Arto Jonsson <artoj@iki.fi>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--]]

-- Arto's Brainfuck Interpreter

Abi = {}
Abi.__index = Abi

function Abi:new()
	local abi = {}
	setmetatable(abi, Abi)

	local cells = {}

	-- Return 0 on non-existant indexes
	setmetatable(cells, {
		__index = function(n)
			return 0
		end
	})

	abi.cells = cells
	abi.dp = 1

	return abi
end

function Abi:do_string(s)

	-- Instruction pointer
	local ip = 1

	while ip <= #s do
		local op = s:sub(ip, ip)

		if op == ">" then
			self.dp = self.dp + 1
		elseif op == "<" then
			self.dp = self.dp - 1
		elseif op == "+" then
			self.cells[self.dp] = self.cells[self.dp] + 1
		elseif op == "-" then
			self.cells[self.dp] = self.cells[self.dp] - 1
		elseif op == "." then
			io.write(string.format('%c', self.cells[self.dp]))
		elseif op == "," then
			self.cells[self.dp] = io.read(1):byte()
		elseif op == "[" then
			if self.cells[self.dp] == 0 then
				ip = ip + 1

				-- Find the next matching "]" and jump over it
				local s1
				local depth = 0
				while true do
					ip = ip + 1
					s1 = s:sub(ip, ip)

					if s1 == "[" then
						depth = depth + 1
					elseif s1 == "]" then
						if depth == 0 then
							break
						else
							depth = depth - 1
						end
					end
				end
			end
		elseif op == "]" then
			if self.cells[self.dp] ~= 0 then
				ip = ip - 1

				-- Find the previous matching "[" and use the instruction
				-- after it
				local s1
				local depth = 0
				while true do
					ip = ip - 1
					s1 = s:sub(ip, ip)

					if s1 == "]" then
						depth = depth + 1
					elseif s1 == "[" then
						if depth == 0 then
							break
						else
							depth = depth - 1
						end
					end
				end
			end
		end
		ip = ip + 1
	end
end
