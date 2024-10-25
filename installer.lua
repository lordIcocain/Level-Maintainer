local shell = require("shell")
local filesystem = require("filesystem")
local scripts = {"AE2.lua", "Maintainer.lua"}

local function exists(filename)
    return filesystem.exists(shell.getWorkingDirectory() .. "/" .. filename)
end

local repo = "https://raw.githubusercontent.com/lordIcocain/Level-Maintainer/";
local branch = "master"

for i = 1, #scripts do
    if exists(scripts[i]) then
        filesystem.remove(shell.getWorkingDirectory() .. "/" .. scripts[i]);
    end

    shell.execute(string.format("wget %s%s/%s %s", repo, branch, scripts[i], scripts[i]));
end

if not exists("MaintainerList") then
    shell.execute(string.format("wget %s%s/MaintainerList", repo, branch));
end

shell.execute("reboot");