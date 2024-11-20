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
            fvalue = load('local function index(a)\n' .. '  return a.' ..
                              convertToStraight(literal) .. ';\n' ..
                              'end;\n\nreturn index;');

            if fvalue ~= nil then
                value = fvalue()(macros)
                literal = fmt(literal);
            end
        end

        new_text = new_text:gsub(fmt(text:sub(start_index, end_index)),
                                 pandoc.utils.stringify(value))


    end
    print("\x1b[93m" .. text .. "\x1b[0m", "=>", "\x1b[92m" .. new_text .. "\x1b[0m")
    
    return new_text;
end

current_macros = nil;
function Meta(meta)
    current_macros = meta
    return meta
end


function processInlines(el)
	
	-- get the link value from el if is link
	local s = pandoc.utils.stringify(el)


	if el.t == "Str" and not (s:match("^https?://") or s:match("^#")) and el.text:match("{{(.-)}}") then
		local c = replace_macros(current_macros, el.text);
        return pandoc.Str(c)
	else
		return el
	end
end

function checkForMacros(el)
    if el.text and el.text == "{{TODO}}" then
        local value = pandoc.utils.stringify(el);
        return pandoc.walk_inline(pandoc.Strong({pandoc.Str(value)}), { Str = processInlines })
    end

    return el;
end


function processEachElement(el)
    if el.t == "Str" then
        -- Directly process string elements
        return processInlines(el)
    else

        -- Walk through any elements with potential inline components
       return pandoc.walk_block(pandoc.walk_block(el, { Str = checkForMacros }), { Str = processInlines })
    end
end

function Pandoc(doc)
    current_macros = doc.meta;

	for i, block in ipairs(doc.blocks) do
        doc.blocks[i] = processEachElement(block)
	end

    return doc
end
