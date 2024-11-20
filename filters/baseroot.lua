local pwd  = '';

function Meta (meta) 
    -- Get pwd and store globally and in meta
    pwd = os.getenv('PWD')
    return meta;
end

function join(a, b)
    if (a == pwd) then
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

function Image (img)
    img.src = fix_link(img.src);
    return img 
end

return {
    {Meta = Meta}, 
    {Image = Image}
}