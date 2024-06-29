local component = require("component")
local internet = component.internet
local filesystem = require("filesystem")

-- Path to the .cfg file
local cfgFilePath = "/install.cfg"

-- Function to download a file
local function downloadFile(url, path)
  local result, response = pcall(internet.request, url)
  if not result then
    return
  end

  local file = io.open(path, "wb")
  if not file then
    return
  end

  for chunk in response do
    file:write(chunk)
  end

  file:close()
end

-- Read the .cfg file
local file = io.open(cfgFilePath, "r")
if not file then
  return
end

-- Download each file from the URLs in the .cfg file
for url in file:lines() do
  local filename = url:match("^.+/(.+)$")
  if filename then
    local path = "/lib" .. filename
    downloadFile(url, path)
  end
end

file:close()

-- Installation complete, ask for reboot
io.write("Installation complete. Reboot now? [y/n]: ")
local answer = io.read()
if answer == "y" or answer == "Y" then
  computer.shutdown(true)
end

