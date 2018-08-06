local skynet    = require "skynet"
local util      = require "util"
local sname     = require "sname"

local M = {}
setmetatable(M, {
    __index = function(t, k)
        local v = rawget(t, k)
        if v then
            return v
        else
            return function(...)
                return skynet.call(sname.MONGO, "lua", k, ...)
            end
        end
    end
})

return M
