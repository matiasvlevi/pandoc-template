local base = '';
local pwd  = '';

function Meta (meta) 
    -- Store root property globally
    base = meta.root;

    -- Get pwd and store globally and in meta
    pwd = os.getenv('PWD')
    meta.pwd = pwd;

    return meta;
end

function join(a, b)
    if (a == os.getenv('PWD')) then
        b = b:gsub("%.%./", "");
    end

    if b:sub(1, 1) == '.' then 
        b = b:sub(2, #b); 
    end

    if a:sub(-1) == '/' and b:sub(1, 1) ~= '/' or
       a:sub(-1) ~= '/' and b:sub(1, 1) == '/' then
        return a .. b;
    end

    if a:sub(-1) ~= '/' and b:sub(1, 1) ~= '/' then
        return a ..'/'.. b;
    end

    if a:sub(-1) == '/' and b:sub(1, 1) == '/' then
        return a:sub(1, #a - 1) .. b;
    end
end

function fix_link (url)
    return join(pandoc.utils.stringify(pwd), url) 
end

function Link (link) 
    link.target = fix_link(link.target); 
    return link 
end

function Image (img)
    img.src = fix_link(img.src);
    return img 
end

return {
    {Meta = Meta}, 
    {Link = Link, Image = Image}
}