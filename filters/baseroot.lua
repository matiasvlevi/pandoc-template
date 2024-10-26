local base = ''
function Meta(meta) base = meta.root end

function join(a, b)
    if b:sub(1, 1) == '.' then b = b:sub(2, #b); end
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
    return url:sub(1,2) == './' and join(pandoc.utils.stringify(base), url) or url 
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