torch = require('torch')

if arg[2] == "debug" then
    require("lldebugger").start()
  end
  
io.stdout:setvbuf("no")

function love.load()

    --Screen setup

    love.window.setFullscreen(true)
    
    love.window.setVSync(0)

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    love.graphics.setBackgroundColor(1,1,1,1)
    love.graphics.setColor(.2,.2,.2)

    size = 70
    scale = 1.2

    highScore = 0

    restartGame()
end

function restartGame()
    board = {}
    for i = 1,4 do
        table.insert(board,{})
        for j = 1,4 do
            table.insert(board[#board],{0,0})            
        end
    end
    addRandom()
    moving = 0
    timer = 0
    score = 0
    successCount = 0
end

function moveLeft() 
    success = 0
    for i = 2,4 do
        for j = 1,4 do
            if (board[i][j][1] > 0) then
                if (board[i-1][j][1] == 0) then
                    board[i-1][j][1] = board[i][j][1]
                    board[i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
                if (board[i-1][j][1] == board[i][j][1] and board[i][j][2] == 0 and board[i-1][j][2] == 0) then
                    board[i-1][j][2] = 1
                    board[i-1][j][1] = board[i-1][j][1] * 2
                    score = score + board[i][j][1] * 2
                    board[i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
            end
        end
    end
    moving = moving * success
end

function moveRight() 
    success = 0
    for i = 1,3 do
        for j = 1,4 do
            if (board[4-i][j][1] > 0) then
                if (board[5-i][j][1] == 0) then
                    board[5-i][j][1] = board[4-i][j][1]
                    board[4-i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
                if (board[5-i][j][1] == board[4-i][j][1] and board[4-i][j][2] == 0 and board[5-i][j][2] == 0) then
                    board[5-i][j][2] = 1
                    board[5-i][j][1] = board[5-i][j][1] * 2
                    score = score + board[4-i][j][1] * 2
                    board[4-i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
            end
        end
    end
    moving = moving * success
end

function moveUp() 
    success = 0
    for i = 1,4 do
        for j = 2,4 do
            if (board[i][j][1] > 0) then
                if (board[i][j-1][1] == 0) then
                    board[i][j-1][1] = board[i][j][1]
                    board[i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
                if (board[i][j-1][1] == board[i][j][1] and board[i][j][2] == 0 and board[i][j-1][2] == 0) then
                    board[i][j-1][2] = 1
                    board[i][j-1][1] = board[i][j-1][1] * 2
                    score = score + board[i][j][1] * 2
                    board[i][j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
            end
        end
    end
    moving = moving * success
end

function moveDown() 
    success = 0
    for i = 1,4 do
        for j = 1,3 do
            if (board[i][4-j][1] > 0) then
                if (board[i][5-j][1] == 0) then
                    board[i][5-j][1] = board[i][4-j][1]
                    board[i][4-j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
                if (board[i][5-j][1] == board[i][4-j][1] and board[i][4-j][2] == 0 and board[i][5-j][2] == 0) then
                    board[i][5-j][2] = 1
                    board[i][5-j][1] = board[i][5-j][1] * 2
                    score = score + board[i][4-j][1] * 2
                    board[i][4-j][1] = 0
                    success = 1
                    successCount = successCount + 1
                end
            end
        end
    end
    moving = moving * success
end

function addRandom() 
    usable = {}
    for i = 1,4 do
        for j = 1,4 do
            board[i][j][2] = 0
            if (board[i][j][1] == 0) then
                table.insert(usable,{i,j})
            end
        end
    end
    coordinates = usable[love.math.random(1,#usable)]
    board[coordinates[1]][coordinates[2]][1] = love.math.random(1,2) * 2
    lose = 0
    if (#usable > 1) then
        lose = 1
    end
    for i = 2,4 do
        for j = 2,4 do
            if (board[i][j][1] == board[i-1][j][1] or board[i][j][1] == board[i][j-1][1]) then
                lose = 1
            end
        end
    end
    if (lose == 0) then
        restartGame()
    end

end

function love.keypressed(key) 
    if (moving == 0) then
        if (key == "left") then
            moving = 1
        end
        if (key == "right") then
            moving = 2
        end
        if (key == "up") then
            moving = 3
        end
        if (key == "down") then
            moving = 4
        end
    end
end

function love.update(dt)
    if (score > highScore) then
        highScore = score
    end
    if (moving > 0) then
        timer = timer + dt
        if (timer >= 0) then
            timer = 0
            if (moving == 1) then
                moveLeft()
            elseif (moving == 2) then
                moveRight()
            elseif (moving == 3) then
                moveUp()
            else
                moveDown()
            end

            if (moving == 0 and successCount > 0) then
                addRandom()
            end
            if (successCount == 0) then
                moving = math.random(1,4)
            end
        end
    else
        successCount = 0
        moving = love.math.random(2,3)
    end
end

function love.draw()
    for i=1,4 do
        for j = 1,4 do
            love.graphics.rectangle("line",(width/2 - (scale * size * 3.5)) + scale * size * i,(height/2 - (scale * size * 3.5)) + scale * size * j,size,size)
            if (board[i][j][1] > 0) then
                love.graphics.setColor(math.log(board[i][j][1],2)/5,math.log(board[i][j][1],2)/7,1-math.log(board[i][j][1],2)/30,1)
                love.graphics.rectangle("fill",(width/2 - (scale * size * 3.5)) + scale * size * i,(height/2 - (scale * size * 3.5)) + scale * size * j,size,size)
                love.graphics.setColor(0,0,0,1)
                love.graphics.print("score: "..score,0,0)
                love.graphics.print("high score: "..highScore,0,10)
                love.graphics.print(board[i][j][1],(width/2 - (scale * size * 3.5)) + scale * size * i + size/2,(height/2 - (scale * size * 3.5)) + scale * size * j + size/2)
            end
        end
    end
end