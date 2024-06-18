function process_macros(meta)
	local macros = {}

	-- Collect all metadata fields as macros
	for key, value in pairs(meta) do
		if type(value) == 'Inlines' or type(value) == 'Blocks' then
			macros[key] = pandoc.utils.stringify(pandoc.Pandoc(value))
		else
			macros[key] = pandoc.utils.stringify(value)
		end
	end

	return macros
end
  
function replace_macros(macros, text)
	-- Replace all macros in the text
	for macro, value in pairs(macros) do
		text = text:gsub('{{' .. macro .. '}}', value)
	end
	return text
end

function Pandoc(doc)
	local macros = process_macros(doc.meta)

	-- Apply the macros in the body text
	for i, block in ipairs(doc.blocks) do
		if block.t == 'Para' or block.t == 'Plain' then
		local content = pandoc.utils.stringify(block)
		local replaced_content = replace_macros(macros, content)
		doc.blocks[i] = pandoc.Para(pandoc.Str(replaced_content))
		elseif block.t == 'Header' then
		local content = pandoc.utils.stringify(block)
		local replaced_content = replace_macros(macros, content)
		local level = block.level
		doc.blocks[i] = pandoc.Header(level, pandoc.Str(replaced_content))
		end
	end

	return doc
end