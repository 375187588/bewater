local skynet  = require "skynet.manager"
local bewater = require "bw.bewater"
local log     = require "bw.log"

local table_insert = table.insert
local table_remove = table.remove

local addr_list = {}

local CMD = {}
function CMD.register(addr)
    assert(addr)
    table_insert(addr_list, addr)
    log.infof("register %s", addr)
end

function CMD.unregister(addr)
    for i, v in ipairs(addr_list) do
        if v == addr then
            table_remove(v, i)
        end
    end
end

function CMD.shutdown(force)
    log.debug("monitor shutdown")
    for _, v in pairs(addr_list) do
        log.debug("shutdown", v)
        if force then
            bewater.try(function()
                skynet.call(v, "lua", "shutdown", force)
            end)
        else
            skynet.call(v, "lua", "shutdown", force)
        end
    end
    skynet.timeout(100, function()
        skynet.abort()
    end)
end

bewater.start(CMD)