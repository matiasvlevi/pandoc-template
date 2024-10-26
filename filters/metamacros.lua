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
  
function replace_macros(macros, text)
	for literal in text:gmatch("{{(.-)}}") do
		local value = '';
		
		if macros[literal] then
			-- Get from 
			value = macros[literal];
		else 
			-- Evaluate as lua
			
			value = load('return current_macros.' .. literal)();
			print(literal, value);

			literal = literal:gsub("%[", "%%[");
			literal = literal:gsub("%]", "%%]");
			literal = literal:gsub("%.", "%%.");
			literal = literal:gsub("%\"", "%%\"");
			literal = literal:gsub("%<", "%%<");
			literal = literal:gsub("%>", "%%>");

			--literal = literal:gsub("%", "%%'");
		end
		
		text = text:gsub('{{'.. literal ..'}}', pandoc.utils.stringify(value));
	end

	return text
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