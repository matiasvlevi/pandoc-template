function process_macros(meta)
	local macros = {}

	-- Collect all metadata fields as macros
	for key, value in pairs(meta) do

		if (key:find('.%[%d+%')) then
			print('YOOOO THIS IS INDEXING SOMETHING', key, key:find('.%[%d+%].'))

		end

		if type(value) == 'Inlines' or type(value) == 'Blocks' then
			print(value);
			macros[key] = pandoc.utils.stringify(pandoc.Pandoc(value))
		else
			macros[key] = pandoc.utils.stringify(value)
		end
	end

	return macros
end

function fmt(str)
	-- List of characters that need to be escaped in Lua patterns
	local specialCharacters = "%(%)%.%[%]%*%+%-%?%^%$"

	-- Use `gsub` to escape each occurrence of the special characters
	return (str:gsub("([" .. specialCharacters .. "])", "%%%1"))
end

function igmatch(s, pattern)
    local function iterator(s, index)
        -- Use string.find with the pattern to locate matches
        local startIndex, endIndex, content = string.find(s, pattern, index)
        if content then
            -- Return the content, start, and end index of the match
            return endIndex + 1, content, startIndex, endIndex
        end
    end
    
    -- Return the iterator function, initial state, and initial index
    return iterator, s, 1
end
  
function convertToTypographic(text)
    -- Replace straight single and double quotes with typographic quotes
    text = text:gsub("'", "’") -- Replace single quotes with curly single quotes
    text = text:gsub('"', '“') -- Replace double quotes with curly double quotes
    return text
end

-- Function to convert typographic quotes to straight quotes
function convertToStraight(text)
	text = text:gsub("’", "'");
	text = text:gsub("‘", "'");
    text = text:gsub('“', '"') -- Replace curly double quotes with straight double quote
	text = text:gsub('”', '"') -- Replace curly double quotes with straight double quote
    return text
end

function replace_macros(macros, text)
	local new_text = text;
	for _, literal, start_index, end_index in igmatch(text, "{{(.-)}}") do
		local value = '';
		
		if macros[literal] then
			-- Get from 
			value = macros[literal];
		else
			-- Evaluate as lua
			fvalue = load('local function index(a)\n'.. 
			'  return a.' .. convertToStraight(literal) .. ';\n'..
			'end;\n\nreturn index;');

			if fvalue ~= nil then
				value =  fvalue()(macros)
				literal = fmt(literal);
			end
		end

		new_text = new_text:gsub(
			fmt(text:sub(start_index, end_index)), 
			pandoc.utils.stringify(value)
		)
	end

	return new_text;
end

function Pandoc(doc)


	current_macros = doc.meta;
	local macros = process_macros(doc.meta)

	-- Apply the macros in the body text
	for i, block in ipairs(doc.blocks) do
		if block.t == 'Para' or block.t == 'Plain' then
			
			local content = pandoc.utils.stringify(block)
			local replaced_content = replace_macros(doc.meta, content)

			doc.blocks[i] = pandoc.Para(pandoc.Str(replaced_content))
		elseif block.t == 'Header' then

			local content = pandoc.utils.stringify(block)
			local replaced_content = replace_macros(doc.meta, content)
			local level = block.level
			
			doc.blocks[i] = pandoc.Header(level, pandoc.Str(replaced_content))
		end
	end
	current_macros = nil;
	return doc
end