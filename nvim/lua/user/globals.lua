prequire = function(...)
    local status, lib = pcall(require, ...)

    if status then
        return lib
    end

    return nil
end

P = function(v)
    print(vim.inspect(v))
    return v
end

RELOAD = function(name)
    package.loaded[name] = nil
    return require(name)
end
