local widget = require("widget")

-- Screen center
local cx = display.contentCenterX
local cy = display.contentCenterY
local spacing = 40
local size = 90
local sequence = { math.random(1, 4) }
local isPlaying = false
local playerIndex = 1
local inputEnabled = false
local gridWidth = size * 2 + spacing
local gridHeight = size * 2 + spacing
local startX = cx - gridWidth / 2 + size / 2
local startY = cy - gridHeight / 2 + size / 2

local colors = {
    { name = "red",    color = {1, 0, 0}, x = startX,           y = startY },
    { name = "yellow", color = {1, 1, 0}, x = startX + size + spacing, y = startY },
    { name = "green",  color = {0, 1, 0}, x = startX,           y = startY + size + spacing },
    { name = "blue",   color = {0, 0, 1}, x = startX + size + spacing, y = startY + size + spacing },
}

local buttons = {}

for i, data in ipairs(colors) do
    local btn = display.newRect(data.x, data.y, size, size)
    btn:setFillColor(unpack(data.color))
    btn.strokeWidth = 3
    btn:setStrokeColor(1)
    btn.name = data.name
    btn.index = i
    buttons[#buttons + 1] = btn

    local label = display.newText({
        text = data.name:upper(),
        x = data.x,
        y = data.y + size / 2 + 24,
        font = native.systemFontBold,
        fontSize = 18
    })
    
    btn:addEventListener("tap", function()
        if not inputEnabled then return end
    
        -- Flash feedback
        btn:setFillColor(1, 1, 1)
        timer.performWithDelay(200, function()
            btn:setFillColor(unpack(colors[btn.index].color))
        end)
    
        if btn.index == sequence[playerIndex] then
            playerIndex = playerIndex + 1
            if playerIndex > #sequence then
                inputEnabled = false
                timer.performWithDelay(1000, function()
                    sequence[#sequence + 1] = math.random(1, 4)
                    flashSequence(1)
                end)
            end
        else
            inputEnabled = false
            native.showAlert("Wrong!", "Restarting game...", { "OK" }, function()
                sequence = { math.random(1, 4) }
                flashSequence(1)
            end)
        end
    end)
end

local playButton = widget.newButton({
    label = "PLAY",
    x = cx,
    y = cy + size * 2 + spacing,
    shape = "rect",
    width = 200,
    height = 50,
    fillColor = { default={0.2, 0.2, 0.2}, over={0.4,0.4,0.4} },
    labelColor = { default={1}, over={1,1,0} },
    onRelease = function()
        if isPlaying then return end
        isPlaying = true
        sequence = { math.random(1, 4) }
        flashSequence(1)
    end
    
})

function flashSequence(index)
    if index > #sequence then
        isPlaying = false
        inputEnabled = true
        playerIndex = 1
        return
    end

    local btn = buttons[sequence[index]]
    btn:setFillColor(1, 1, 1)  -- flash white
    timer.performWithDelay(400, function()
        btn:setFillColor(unpack(colors[btn.index].color))
        timer.performWithDelay(200, function()
            flashSequence(index + 1)
        end)
    end)
end


