local correct = false
local enterpass = ""
local os = require("os")
local event = require("event")
local io = require("io")
local term = require("term")
local component = require("component")
local sides = require("sides")
local function reset()
  term.clear()
  component.gpu.setResolution(40, 20)
  component.gpu.setBackground(0, true)
  component.gpu.setForeground(15, true)
  component.gpu.fill(1, 1, 40, 20, " ")
  local sel = "started"
  local selx = "started"
  local sely = "started"
  
  component.gpu.set(10, 6, "1")
  component.gpu.set(20, 6, "2")
  component.gpu.set(30, 6, "3")
  component.gpu.set(10, 9, "4")
  component.gpu.set(20, 9, "5")
  component.gpu.set(30, 9, "6")
  component.gpu.set(10, 12, "7")
  component.gpu.set(20, 12, "8")
  component.gpu.set(30, 12, "9")
  component.gpu.set(10, 15, "N")
  component.gpu.set(20, 15, "0")
  component.gpu.set(30, 15, "Y")
  print(enterpass)
end
local passfile = io.open("/home/pass", "r")
local pass = passfile:read()
reset()
while true do
  local _,_,tx,ty = event.pull("touch")
  sel = "started"
  sely = "nothing"
  if ty == 6.0 then
    sely = 0
  end
  if ty == 9.0 then
    sely = 3
  end
  if ty == 12.0 then
    sely = 6
  end
  if ty == 15.0 then
    sely = -2
  end
----------------------------------------
  selx = "nothing"
  if tx == 10 then
    selx = 1
  end
  if tx == 20 then
    selx = 2
  end
  if tx == 30 then
    selx = 3
  end
----------------------------------------
  if sely == -2 and selx == 1 then
    sel = "N"
  end
  if sely == -2 and selx == 3 then
    sel = "Y"
  end
  if sely == "nothing" or selx == "nothing" then
    sel = "nothing"
  end
  if sel == "started" then
    sel = tostring(selx + sely)
    enterpass = enterpass .. sel
  end
  if sel == "Y" then
    if enterpass == pass then
      correct = true
    end
    enterpass = ""
  end
  if sel == "N" then
    enterpass = ""
  end
  reset()
  if correct == true then
    component.redstone.setOutput(sides.west, 15)
    component.redstone.setOutput(sides.west, 0)
    correct = false
  end
end